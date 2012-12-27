#import "CSSpecHelper.h"

#import "CSAPI.h"
#import "CSList.h"
#import "CSSubscriber.h"

SPEC_BEGIN(CSAPIListsSpec)

describe(@"CSAPI+Lists", ^{
    registerMatchers(@"OV");
    
    context(@"when an api caller is authenticated", ^{
        __block CSAPI *cs = nil;
        NSString *clientID = @"4a397ccaaa55eb4e6aa1221e1e2d7122";
        NSString *listID = @"e3c5f034d68744f7881fdccf13c2daee";
        
        beforeEach(^{
            cs = [[CSAPI alloc] init];
        });

        context(@"create list", ^{
            NSString *title = @"List One";
            NSString *unsubscribePage = @"example.com/unsubscribe";
            NSString *confirmationSuccessPage = @"example.com/success";
            BOOL shouldConfirmOptIn = NO;
            
            it(@"should create a list", ^{
                NSURLRequest *request = nil;
                __block NSString *listID = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"create_list.json" returningRequest:&request whileExecutingBlock:^{
                    [cs createListWithClientID:clientID title:title unsubscribePage:unsubscribePage confirmationSuccessPage:confirmationSuccessPage shouldConfirmOptIn:shouldConfirmOptIn completionHandler:^(NSString *response) {
                        listID = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[listID should] equal:@"e3c5f034d68744f7881fdccf13c2daee"];

                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"Title": title, @"ConfirmationSuccessPage": confirmationSuccessPage, @"UnsubscribePage": unsubscribePage, @"ConfirmedOptIn": @(shouldConfirmOptIn)};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorListTitleEmpty message:CSAPIErrorListTitleEmptyMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs createListWithClientID:clientID title:title unsubscribePage:unsubscribePage confirmationSuccessPage:confirmationSuccessPage shouldConfirmOptIn:shouldConfirmOptIn completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorListTitleEmpty message:CSAPIErrorListTitleEmptyMessage];
                }];
            });
        });
        
        context(@"update list", ^{
            NSString *title = @"List One Renamed";
            NSString *unsubscribePage = @"example.com/unsubscribe-renamed";
            NSString *confirmationSuccessPage = @"example.com/success-renamed";
            BOOL shouldConfirmOptIn = YES;
            
            it(@"should update a list", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs updateListWithListID:listID title:title unsubscribePage:unsubscribePage confirmationSuccessPage:confirmationSuccessPage shouldConfirmOptIn:shouldConfirmOptIn completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
                
                NSDictionary *expectedPostBody = @{@"Title": title, @"ConfirmationSuccessPage": confirmationSuccessPage, @"UnsubscribePage": unsubscribePage, @"ConfirmedOptIn": @(shouldConfirmOptIn)};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorListTitleEmpty message:CSAPIErrorListTitleEmptyMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs updateListWithListID:listID title:title unsubscribePage:unsubscribePage confirmationSuccessPage:confirmationSuccessPage shouldConfirmOptIn:shouldConfirmOptIn completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorListTitleEmpty message:CSAPIErrorListTitleEmptyMessage];
                }];
            });
        });
        
        context(@"delete list", ^{
            it(@"should delete a list", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs deleteListWithID:listID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"DELETE"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs deleteListWithID:listID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"details of a list", ^{
            it(@"should get the details of a list", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"list_details.json" returningRequest:&request whileExecutingBlock:^{
                    __block CSList *list = nil;
                    [cs getListDetailsWithListID:listID completionHandler:^(CSList *response) {
                        list = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];

                    [list shouldNotBeNil];
                    [[list.listID should] equal:@"2fe4c8f0373ce320e2200596d7ef168f"];
                    [[list.name should] equal:@"a non-basic list :)"];
                    [[list.unsubscribePage should] equal:@""];
                    [[list.confirmationSuccessPage should] equal:@""];
                    [[list.unsubscribeSetting should] equal:@"AllClientLists"];
                    [[theValue(list.confirmOptIn) should] beFalse];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getListDetailsWithListID:listID completionHandler:^(CSList *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"stats for a list", ^{
            it(@"should get the stats for a list", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"list_stats.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSDictionary *listStatistics = nil;
                    [cs getListStatisticsWithListID:listID completionHandler:^(NSDictionary *response) {
                        listStatistics = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [listStatistics shouldNotBeNil];
                    [[[listStatistics valueForKey:CSAPIListStatisticTotalActiveSubscribersKey] should] equal:theValue(6)];
                    [[[listStatistics valueForKey:CSAPIListStatisticTotalUnsubscribesKey] should] equal:theValue(2)];
                    [[[listStatistics valueForKey:CSAPIListStatisticTotalDeletedKey] should] equal:theValue(0)];
                    [[[listStatistics valueForKey:CSAPIListStatisticTotalBouncesKey] should] equal:theValue(0)];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/stats.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getListStatisticsWithListID:listID completionHandler:^(NSDictionary *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"segments for a list", ^{
            it(@"should get the segments for a list", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"segments.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *segments = nil;
                    [cs getListSegmentsWithListID:listID completionHandler:^(NSArray *response) {
                        segments = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [segments shouldNotBeNil];
                    [[[segments should] have:2] items];
                    
                    CSSegment *firstSegment = [segments objectAtIndex:0];
                    [[firstSegment.listID should] equal:@"a58ee1d3039b8bec838e6d1482a8a965"];
                    [[firstSegment.segmentID should] equal:@"46aa5e01fd43381863d4e42cf277d3a9"];
                    [[firstSegment.title should] equal:@"Segment One"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/segments.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getListSegmentsWithListID:listID completionHandler:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"active subscribers for a list", ^{
            NSDate *date = [NSDate date];
        
            it(@"should get the active subscribers for a list", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"active_subscribers.json" returningRequest:&request whileExecutingBlock:^{
                    __block CSPaginatedResult *paginatedResult = nil;
                    [cs getActiveSubscribersWithListID:listID date:date page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        paginatedResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [paginatedResult shouldNotBeNil];
                    [[paginatedResult.orderedBy should] equal:CSAPIOrderByEmail];
                    [[theValue(paginatedResult.ascending) should] beTrue];
                    [[theValue(paginatedResult.page) should] equal:theValue(1)];
                    [[theValue(paginatedResult.pageSize) should] equal:theValue(1000)];
                    [[theValue(paginatedResult.resultCount) should] equal:theValue(5)];
                    [[theValue(paginatedResult.totalResultCount) should] equal:theValue(5)];
                    [[theValue(paginatedResult.totalPages) should] equal:theValue(1)];
                    [[[paginatedResult.results should] have:5] items];
                    
                    CSSubscriber *firstSubscriber = [paginatedResult objectAtIndex:0];
                    [[firstSubscriber.emailAddress should] equal:@"subs+7t8787Y@example.com"];
                    [[firstSubscriber.name should] equal:@"Person One"];
                    [[[[CSAPI sharedDateFormatter] stringFromDate:firstSubscriber.date] should] equal:@"2010-10-25 10:28:00"];
                    [[firstSubscriber.state should] equal:@"Active"];
                    [[[firstSubscriber.customFields should] have:3] items];
                    [[firstSubscriber.readsEmailWith should] equal:@"Gmail"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/active.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.path should] equal:expectedURL.path];
                
                NSDictionary *parameters = [request.URL cs_queryValuesForKeys:@[@"page", @"pagesize", @"orderfield", @"orderdirection", @"date"] error:nil];
                NSDictionary *expectedParameters = @{@"page": @"1", @"pagesize": @"1000", @"orderfield": CSAPIOrderByEmail, @"orderdirection": @"asc", @"date": [[CSAPI sharedDateFormatter] stringFromDate:date]};
                [[parameters should] equal:expectedParameters];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getActiveSubscribersWithListID:listID date:date page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });

        context(@"unconfirmed subscribers for a list", ^{
            NSDate *date = [NSDate date];
            
            it(@"should get the unconfirmed subscribers for a list", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"unconfirmed_subscribers.json" returningRequest:&request whileExecutingBlock:^{
                    __block CSPaginatedResult *paginatedResult = nil;
                    [cs getUnconfirmedSubscribersWithListID:listID date:date page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        paginatedResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];

                    [paginatedResult shouldNotBeNil];
                    [[paginatedResult.orderedBy should] equal:CSAPIOrderByEmail];
                    [[theValue(paginatedResult.ascending) should] beTrue];
                    [[theValue(paginatedResult.page) should] equal:theValue(1)];
                    [[theValue(paginatedResult.pageSize) should] equal:theValue(1000)];
                    [[theValue(paginatedResult.resultCount) should] equal:theValue(2)];
                    [[theValue(paginatedResult.totalResultCount) should] equal:theValue(2)];
                    [[theValue(paginatedResult.totalPages) should] equal:theValue(1)];
                    [[[paginatedResult.results should] have:2] items];

                    CSSubscriber *firstSubscriber = [paginatedResult objectAtIndex:0];
                    [[firstSubscriber.emailAddress should] equal:@"subs+7t8787Y@example.com"];
                    [[firstSubscriber.name should] equal:@"Unconfirmed One"];
                    [[[[CSAPI sharedDateFormatter] stringFromDate:firstSubscriber.date] should] equal:@"2010-10-25 10:28:00"];
                    [[firstSubscriber.state should] equal:@"Unconfirmed"];
                    [[[firstSubscriber.customFields should] have:1] items];
                    [[firstSubscriber.readsEmailWith should] equal:@""];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/unconfirmed.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.path should] equal:expectedURL.path];
                
                NSDictionary *parameters = [request.URL cs_queryValuesForKeys:@[@"page", @"pagesize", @"orderfield", @"orderdirection", @"date"] error:nil];
                NSDictionary *expectedParameters = @{@"page": @"1", @"pagesize": @"1000", @"orderfield": CSAPIOrderByEmail, @"orderdirection": @"asc", @"date": [[CSAPI sharedDateFormatter] stringFromDate:date]};
                [[parameters should] equal:expectedParameters];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getUnconfirmedSubscribersWithListID:listID date:date page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });

        context(@"unsubscribed subscribers for a list", ^{
            NSDate *date = [NSDate date];
            
            it(@"should get the unsubscribed subscribers for a list", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"unsubscribed_subscribers.json" returningRequest:&request whileExecutingBlock:^{
                    __block CSPaginatedResult *paginatedResult = nil;
                    [cs getUnsubscribedSubscribersWithListID:listID date:date page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        paginatedResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [paginatedResult shouldNotBeNil];
                    [[paginatedResult.orderedBy should] equal:CSAPIOrderByEmail];
                    [[theValue(paginatedResult.ascending) should] beTrue];
                    [[theValue(paginatedResult.page) should] equal:theValue(1)];
                    [[theValue(paginatedResult.pageSize) should] equal:theValue(1000)];
                    [[theValue(paginatedResult.resultCount) should] equal:theValue(5)];
                    [[theValue(paginatedResult.totalResultCount) should] equal:theValue(5)];
                    [[theValue(paginatedResult.totalPages) should] equal:theValue(1)];
                    [[[paginatedResult.results should] have:5] items];
                    
                    CSSubscriber *firstSubscriber = [paginatedResult objectAtIndex:0];
                    [[firstSubscriber.emailAddress should] equal:@"subscriber@example.com"];
                    [[firstSubscriber.name should] equal:@"Unsub One"];
                    [[[[CSAPI sharedDateFormatter] stringFromDate:firstSubscriber.date] should] equal:@"2010-10-25 13:11:00"];
                    [[firstSubscriber.state should] equal:@"Unsubscribed"];
                    [[[firstSubscriber.customFields should] have:0] items];
                    [[firstSubscriber.readsEmailWith should] equal:@"Gmail"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/unsubscribed.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.path should] equal:expectedURL.path];
                
                NSDictionary *parameters = [request.URL cs_queryValuesForKeys:@[@"page", @"pagesize", @"orderfield", @"orderdirection", @"date"] error:nil];
                NSDictionary *expectedParameters = @{@"page": @"1", @"pagesize": @"1000", @"orderfield": CSAPIOrderByEmail, @"orderdirection": @"asc", @"date": [[CSAPI sharedDateFormatter] stringFromDate:date]};
                [[parameters should] equal:expectedParameters];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getUnsubscribedSubscribersWithListID:listID date:date page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"deleted subscribers for a list", ^{
            NSDate *date = [NSDate date];
            
            it(@"should get the deleted subscribers for a list", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"deleted_subscribers.json" returningRequest:&request whileExecutingBlock:^{
                    __block CSPaginatedResult *paginatedResult = nil;
                    [cs getDeletedSubscribersWithListID:listID date:date page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        paginatedResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [paginatedResult shouldNotBeNil];
                    [[paginatedResult.orderedBy should] equal:CSAPIOrderByEmail];
                    [[theValue(paginatedResult.ascending) should] beTrue];
                    [[theValue(paginatedResult.page) should] equal:theValue(1)];
                    [[theValue(paginatedResult.pageSize) should] equal:theValue(1000)];
                    [[theValue(paginatedResult.resultCount) should] equal:theValue(5)];
                    [[theValue(paginatedResult.totalResultCount) should] equal:theValue(5)];
                    [[theValue(paginatedResult.totalPages) should] equal:theValue(1)];
                    [[[paginatedResult.results should] have:5] items];
                    
                    CSSubscriber *firstSubscriber = [paginatedResult objectAtIndex:0];
                    [[firstSubscriber.emailAddress should] equal:@"subscriber@example.com"];
                    [[firstSubscriber.name should] equal:@"Deleted One"];
                    [[[[CSAPI sharedDateFormatter] stringFromDate:firstSubscriber.date] should] equal:@"2010-10-25 13:11:00"];
                    [[firstSubscriber.state should] equal:@"Deleted"];
                    [[[firstSubscriber.customFields should] have:0] items];
                    [[firstSubscriber.readsEmailWith should] equal:@"Gmail"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/deleted.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.path should] equal:expectedURL.path];
                
                NSDictionary *parameters = [request.URL cs_queryValuesForKeys:@[@"page", @"pagesize", @"orderfield", @"orderdirection", @"date"] error:nil];
                NSDictionary *expectedParameters = @{@"page": @"1", @"pagesize": @"1000", @"orderfield": CSAPIOrderByEmail, @"orderdirection": @"asc", @"date": [[CSAPI sharedDateFormatter] stringFromDate:date]};
                [[parameters should] equal:expectedParameters];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getDeletedSubscribersWithListID:listID date:date page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"bounced subscribers for a list", ^{
            NSDate *date = [NSDate date];
            
            it(@"should get the bounced subscribers for a list", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"bounced_subscribers.json" returningRequest:&request whileExecutingBlock:^{
                    __block CSPaginatedResult *paginatedResult = nil;
                    [cs getBouncedSubscribersWithListID:listID date:date page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        paginatedResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [paginatedResult shouldNotBeNil];
                    [[paginatedResult.orderedBy should] equal:CSAPIOrderByEmail];
                    [[theValue(paginatedResult.ascending) should] beTrue];
                    [[theValue(paginatedResult.page) should] equal:theValue(1)];
                    [[theValue(paginatedResult.pageSize) should] equal:theValue(1000)];
                    [[theValue(paginatedResult.resultCount) should] equal:theValue(1)];
                    [[theValue(paginatedResult.totalResultCount) should] equal:theValue(1)];
                    [[theValue(paginatedResult.totalPages) should] equal:theValue(1)];
                    [[[paginatedResult.results should] have:1] items];
                    
                    CSSubscriber *firstSubscriber = [paginatedResult objectAtIndex:0];
                    [[firstSubscriber.emailAddress should] equal:@"bouncedsubscriber@example.com"];
                    [[firstSubscriber.name should] equal:@"Bounced One"];
                    [[[[CSAPI sharedDateFormatter] stringFromDate:firstSubscriber.date] should] equal:@"2010-10-25 13:11:00"];
                    [[firstSubscriber.state should] equal:@"Bounced"];
                    [[[firstSubscriber.customFields should] have:0] items];
                    [[firstSubscriber.readsEmailWith should] equal:@""];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/bounced.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.path should] equal:expectedURL.path];
                
                NSDictionary *parameters = [request.URL cs_queryValuesForKeys:@[@"page", @"pagesize", @"orderfield", @"orderdirection", @"date"] error:nil];
                NSDictionary *expectedParameters = @{@"page": @"1", @"pagesize": @"1000", @"orderfield": CSAPIOrderByEmail, @"orderdirection": @"asc", @"date": [[CSAPI sharedDateFormatter] stringFromDate:date]};
                [[parameters should] equal:expectedParameters];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getBouncedSubscribersWithListID:listID date:date page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"custom fields with listID", ^{
            it(@"should get the custom fields for a list", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"custom_fields.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *customFields = nil;
                    [cs getCustomFieldsWithListID:listID completionHandler:^(NSArray *response) {
                        customFields = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [[[customFields should] have:3] items];
                    
                    CSCustomField *firstCustomField = [customFields objectAtIndex:0];
                    [[firstCustomField.key should] equal:@"[website]"];
                    [[firstCustomField.name should] equal:@"website"];
                    [[theValue(firstCustomField.dataType) should] equal:theValue(CSCustomFieldTextDataType)];
                    [[firstCustomField.options should] beEmpty];
                    [[theValue(firstCustomField.visibleInPreferenceCenter) should] equal:@(NO)];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/customfields.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getCustomFieldsWithListID:listID completionHandler:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });

        context(@"create custom field", ^{
            CSCustomField *customField = [CSCustomField customFieldWithName:@"new date field" key:@"[newdatefield]"
                dataType:CSCustomFieldDateDataType options:nil value:nil visibleInPreferenceCenter:NO];

            it(@"should create a custom field", ^{
                NSURLRequest *request = nil;
                __block NSString *customFieldKey = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"create_custom_field.json" returningRequest:&request whileExecutingBlock:^{
                    [cs createCustomFieldWithListID:listID customField:customField completionHandler:^(NSString *response) {
                        customFieldKey = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[customFieldKey should] equal:@"[newdatefield]"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/customfields.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];

                NSDictionary *expectedPostBody = @{@"FieldName": customField.name, @"DataType": [customField dataTypeString], @"VisibleInPreferenceCenter": @(customField.visibleInPreferenceCenter)};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorFieldKeyExists message:CSAPIErrorFieldKeyExistsMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs createCustomFieldWithListID:listID customField:customField completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorFieldKeyExists message:CSAPIErrorFieldKeyExistsMessage];
                }];
            });
        });

        context(@"update custom field", ^{
            CSCustomField *customField = [CSCustomField customFieldWithKey:@"[mycustomfield]" name:@"my renamed custom field" visibleInPreferenceCenter:YES];
            
            it(@"should update a custom field", ^{
                NSURLRequest *request = nil;
                __block NSString *newCustomFieldKey = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"update_custom_field.json" returningRequest:&request whileExecutingBlock:^{
                    [cs updateCustomFieldWithListID:listID customField:customField completionHandler:^(NSString *response) {
                        newCustomFieldKey = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];

                [[newCustomFieldKey should] equal:@"[myrenamedcustomfield]"];

                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/customfields/%@.json", listID, customField.key] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];

                NSDictionary *expectedPostBody = @{@"FieldName": customField.name, @"VisibleInPreferenceCenter": @(customField.visibleInPreferenceCenter)};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorFieldKeyExists message:CSAPIErrorFieldKeyExistsMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs updateCustomFieldWithListID:listID customField:customField completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorFieldKeyExists message:CSAPIErrorFieldKeyExistsMessage];
                }];
            });
        });

        context(@"update the options of a multi-optioned custom field", ^{
            NSString *customFieldKey = @"[newdatefield]";
            NSArray *options = @[@"one", @"two", @"three"];
            BOOL keepExisting = YES;
            
            it(@"should update the options of a multi-optioned custom field", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs updateCustomFieldOptionsWithListID:listID customFieldKey:customFieldKey options:options keepExisting:keepExisting completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/customfields/%@/options.json", listID, customFieldKey] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
                
                NSDictionary *expectedPostBody = @{@"KeepExistingOptions": @(keepExisting), @"Options": options};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });

            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorFieldKeyExists message:CSAPIErrorFieldKeyExistsMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs updateCustomFieldOptionsWithListID:listID customFieldKey:customFieldKey options:options keepExisting:keepExisting completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorFieldKeyExists message:CSAPIErrorFieldKeyExistsMessage];
                }];
            });
        });
        
        context(@"delete custom field", ^{
            NSString *customFieldKey = @"[newdatefield]";
            
            it(@"should delete a custom field", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs deleteCustomFieldWithListID:listID customFieldKey:customFieldKey completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/customfields/%@.json", listID, customFieldKey] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"DELETE"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs deleteCustomFieldWithListID:listID customFieldKey:customFieldKey completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"create a webhook for a list", ^{
            NSArray *events = @[@"Unsubscribe", @"Spam"];
            NSString *URLString = @"http://example.com/unsub";
            NSString *payloadFormat = CSAPIWebhookPayloadFormatJSON;
            
            it(@"should create a webhook for a list", ^{
                NSURLRequest *request = nil;
                __block NSString *webhookID = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"create_list_webhook.json" returningRequest:&request whileExecutingBlock:^{
                    [cs createWebhookWithListID:listID events:events URLString:URLString payloadFormat:payloadFormat completionHandler:^(NSString *response) {
                        webhookID = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[webhookID should] equal:@"6a783d359bd44ef62c6ca0d3eda4412a"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/webhooks.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"Events": events, @"PayloadFormat": payloadFormat, @"Url": URLString};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidWebhookURL message:CSAPIErrorInvalidWebhookURLMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs createWebhookWithListID:listID events:events URLString:URLString payloadFormat:payloadFormat completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidWebhookURL message:CSAPIErrorInvalidWebhookURLMessage];
                }];
            });
        });
        
        context(@"webhooks with listID", ^{
            it(@"should get the webhooks for a list", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"list_webhooks.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *webhooks = nil;
                    [cs getWebhooksWithListID:listID completionHandler:^(NSArray *response) {
                        webhooks = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [[[webhooks should] have:2] items];
                    
                    CSWebhook *firstWebhook = [webhooks objectAtIndex:0];
                    [[firstWebhook.webhookID should] equal:@"943678317049bc13"];
                    [[firstWebhook.url should] equal:@"http://www.postbin.org/d9w8ud9wud9w"];
                    [[firstWebhook.status should] equal:@"Active"];
                    [[firstWebhook.payloadFormat should] equal:CSAPIWebhookPayloadFormatJSON];
                    [[[firstWebhook.events should] have:1] items];
                    [[firstWebhook.events should] contain:@"Deactivate"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/webhooks.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getWebhooksWithListID:listID completionHandler:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"test a webhook for a list", ^{
            NSString *webhookID = @"jiuweoiwueoiwueowiueo";
            
            it(@"should test a webhook for a list", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs testWebhookWithListID:listID webhookID:webhookID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/webhooks/%@/test.json", listID, webhookID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"GET"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorWebhookRequestFailed message:CSAPIErrorWebhookRequestFailedMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs testWebhookWithListID:listID webhookID:webhookID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorWebhookRequestFailed message:CSAPIErrorWebhookRequestFailedMessage];
                }];
            });
        });
        
        context(@"delete a webhook for a list", ^{
            NSString *webhookID = @"jiuweoiwueoiwueowiueo";
            
            it(@"should delete a webhook for a list", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs deleteWebhookWithListID:listID webhookID:webhookID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/webhooks/%@.json", listID, webhookID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"DELETE"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs deleteWebhookWithListID:listID webhookID:webhookID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"activate a webhook for a list", ^{
            NSString *webhookID = @"jiuweoiwueoiwueowiueo";
            
            it(@"should activate a webhook for a list", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs activateWebhookWithListID:listID webhookID:webhookID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/webhooks/%@/activate.json", listID, webhookID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs activateWebhookWithListID:listID webhookID:webhookID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"deactivate a webhook for a list", ^{
            NSString *webhookID = @"jiuweoiwueoiwueowiueo";
            
            it(@"should deactivate a webhook for a list", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs deactivateWebhookWithListID:listID webhookID:webhookID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"lists/%@/webhooks/%@/deactivate.json", listID, webhookID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs deactivateWebhookWithListID:listID webhookID:webhookID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
    });
});

SPEC_END