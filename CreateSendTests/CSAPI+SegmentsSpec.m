#import "CSSpecHelper.h"

#import "CSAPI.h"
#import "CSClient.h"
#import "CSList.h"

SPEC_BEGIN(CSAPISegmentsSpec)

describe(@"CSAPI+Segments", ^{
    registerMatchers(@"OV");
    
    context(@"when an api caller is authenticated", ^{
        __block CSAPI *cs = nil;
        NSString *segmentID = @"98y2e98y289dh89h938389";
        
        beforeEach(^{
            cs = [[CSAPI alloc] init];
        });
        
        context(@"create a segment", ^{
            NSString *listID = @"2983492834987394879837498";
            NSString *title = @"new segment title";
            NSArray *rules = @[[CSSegmentRule segmentRuleWithSubject:@"EmailAddress" clauses:@[@"CONTAINS example.com"]]];
            
            it(@"should create a segment", ^{
                NSURLRequest *request = nil;
                __block NSString *segmentID = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"create_segment.json" returningRequest:&request whileExecutingBlock:^{
                    [cs createSegmentWithListID:listID title:title rules:rules completionHandler:^(NSString *response) {
                        segmentID = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[segmentID should] equal:@"0246c2aea610a3545d9780bf6ab89006"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"segments/%@.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"Title": title, @"Rules": [rules valueForKey:@"dictionaryValue"]};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs createSegmentWithListID:listID title:title rules:rules completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"update a segment", ^{
            NSString *title = @"updated segment title";
            NSArray *rules = @[[CSSegmentRule segmentRuleWithSubject:@"Name" clauses:@[@"EQUALS subscriber"]]];

            it(@"should update a client", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs updateSegmentWithSegmentID:segmentID title:title rules:rules completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"segments/%@.json", segmentID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
                
                NSDictionary *expectedPostBody = @{@"Title": title, @"Rules": [rules valueForKey:@"dictionaryValue"]};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs updateSegmentWithSegmentID:segmentID title:title rules:rules completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"delete a segment", ^{
            it(@"should delete a segment", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^ {
                    [cs deleteSegmentWithID:segmentID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"segments/%@.json", segmentID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"DELETE"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs deleteSegmentWithID:segmentID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"add a rule to a segment", ^{
            CSSegmentRule *rule = [CSSegmentRule segmentRuleWithSubject:@"EmailAddress" clauses:@[@"CONTAINS example.com"]];
            
            it(@"should add a rule to a segment", ^{
                NSURLRequest *request = nil;
                __block NSString *segmentID = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs addRuleToSegmentWithID:segmentID rule:rule completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"segments/%@/rules.json", segmentID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = [rule valueForKey:@"dictionaryValue"];
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs addRuleToSegmentWithID:segmentID rule:rule completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"deleting a segment's rules", ^{
            it(@"should delete a segment's rules", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^ {
                    [cs removeAllRulesFromSegmentWithID:segmentID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"segments/%@/rules.json", segmentID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"DELETE"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs removeAllRulesFromSegmentWithID:segmentID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get the details of a segment", ^{
            it(@"should get the details of a segment", ^{
                NSURLRequest *request = nil;
                __block CSSegment *segment = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"segment_details.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getSegmentDetailsWithSegmentID:segmentID completionHandler:^(CSSegment *response) {
                        segment = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [segment shouldNotBeNil];
                [[segment.segmentID should] equal:@"dba84a225d5ce3d19105d7257baac46f"];
                [[segment.listID should] equal:@"2bea949d0bf96148c3e6a209d2e82060"];
                [[segment.title should] equal:@"My Segment"];
                [[theValue(segment.activeSubscriberCount) should] equal:theValue(0)];
                
                [[[segment.rules should] have:2] items];
                CSSegmentRule *segmentRule = [segment.rules objectAtIndex:0];
                [[segmentRule.subject should] equal:@"EmailAddress"];

                [[segmentRule.clauses should] have:1];
                NSString *clause = [segmentRule.clauses objectAtIndex:0];
                [[clause should] equal:@"CONTAINS @hello.com"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"segments/%@.json", segmentID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getSegmentDetailsWithSegmentID:segmentID completionHandler:^(CSSegment *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"active subscribers for a segment", ^{
            NSDate *date = [NSDate date];
            
            it(@"should get the active subscribers for a segment", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"segment_subscribers.json" returningRequest:&request whileExecutingBlock:^{
                    __block CSPaginatedResult *paginatedResult = nil;
                    [cs getActiveSubscribersWithSegmentID:segmentID date:date page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
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
                    [[firstSubscriber.emailAddress should] equal:@"personone@example.com"];
                    [[firstSubscriber.name should] equal:@"Person One"];
                    [[[[CSAPI sharedDateFormatter] stringFromDate:firstSubscriber.date] should] equal:@"2010-10-27 13:13:00"];
                    [[firstSubscriber.state should] equal:@"Active"];
                    [[firstSubscriber.customFields should] beEmpty];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"segments/%@/active.json", segmentID] relativeToURL:cs.baseURL];
                [[request.URL.path should] equal:expectedURL.path];
                
                NSDictionary *parameters = [request.URL cs_queryValuesForKeys:@[@"page", @"pagesize", @"orderfield", @"orderdirection", @"date"] error:nil];
                NSDictionary *expectedParameters = @{@"page": @"1", @"pagesize": @"1000", @"orderfield": CSAPIOrderByEmail, @"orderdirection": @"asc", @"date": [[CSAPI sharedDateFormatter] stringFromDate:date]};
                [[parameters should] equal:expectedParameters];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getActiveSubscribersWithSegmentID:segmentID date:date page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        [response shouldBeNil];
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