#import "CSSpecHelper.h"
#import "NSURL+CSAPI.h"

#import "CSAPI.h"
#import "CSClient.h"
#import "CSList.h"

SPEC_BEGIN(CSAPIClientsSpec)

describe(@"CSAPI+Clients", ^{
    registerMatchers(@"OV");
    
    context(@"when an api caller is authenticated", ^{
        __block CSAPI *cs = nil;
        NSString *clientID = @"4a397ccaaa55eb4e6aa1221e1e2d7122";
        
        beforeEach(^{
            cs = [[CSAPI alloc] init];
        });
        
        context(@"create a client", ^{
            NSString *name = @"Client Company Name";
            NSString *contactName =@"Client Contact Name";
            NSString *emailAddress = @"client@example.com";
            NSString *timezone = @"(GMT+10:00) Canberra, Melbourne, Sydney";
            NSString *country = @"Australia";
            
            it(@"should create a client", ^{
                NSURLRequest *request = nil;
                __block NSString *clientID = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"create_client.json" returningRequest:&request whileExecutingBlock:^{
                    [cs createClientWithCompanyName:name contactName:contactName emailAddress:emailAddress country:country timezone:timezone completionHandler:^(NSString *response) {
                        clientID = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[clientID should] equal:@"32a381c49a2df99f1d0c6f3c112352b9"];
                
                NSURL *expectedURL = [NSURL URLWithString:@"clients.json" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"CompanyName": name, @"ContactName": contactName, @"EmailAddress": emailAddress, @"TimeZone": timezone, @"Country": country};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs createClientWithCompanyName:name contactName:contactName emailAddress:emailAddress country:country timezone:timezone completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage];
                }];
            });
        });
        
        context(@"update a client", ^{
            NSString *name = @"Client Company Name";
            NSString *contactName =@"Client Contact Name";
            NSString *emailAddress = @"client@example.com";
            NSString *timezone = @"(GMT+10:00) Canberra, Melbourne, Sydney";
            NSString *country = @"Australia";
            
            it(@"should update a client", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs updateClientWithClientID:clientID companyName:name contactName:contactName emailAddress:emailAddress country:country timezone:timezone completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/setbasics.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
                
                NSDictionary *expectedPostBody = @{@"CompanyName": name, @"ContactName": contactName, @"EmailAddress": emailAddress, @"TimeZone": timezone, @"Country": country};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs updateClientWithClientID:clientID companyName:name contactName:contactName emailAddress:emailAddress country:country timezone:timezone completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage];
                }];
            });
        });
        
        context(@"delete a client", ^{
            it(@"should delete a client", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^ {
                    [cs deleteClientWithID:clientID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"DELETE"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs deleteClientWithID:clientID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });
        
        context(@"set payg billing", ^{
            NSString *currency = CSAPICurrencyCanadianDollars;
            BOOL canPurchaseCredits = YES;
            BOOL clientPays = YES;
            float markupPercentage = 150.0f;
            float markupOnDelivery = 10.0f;
            float markupPerRecipient = 20.0f;
            float markupOnDesignSpamTest = 5.0f;
            
            it(@"should set payg billing", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^ {
                    [cs setClientPAYGBillingSettingsWithClientID:clientID
                                                        currency:currency
                                              canPurchaseCredits:canPurchaseCredits
                                                      clientPays:clientPays
                                                markupPercentage:markupPercentage
                                                markupOnDelivery:markupOnDelivery
                                              markupPerRecipient:markupPerRecipient
                                          markupOnDesignSpamTest:markupOnDesignSpamTest
                                               completionHandler:^() { }
                                                    errorHandler:^(NSError *errorResponse) { [errorResponse shouldBeNil]; }
                    ];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/setpaygbilling.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
                
                NSDictionary *expectedPostBody = @{
                    @"Currency": currency,
                    @"CanPurchaseCredits": @(canPurchaseCredits),
                    @"ClientPays": @(clientPays),
                    @"MarkupPercentage": @(markupPercentage),
                    @"MarkupOnDelivery": @(markupOnDelivery),
                    @"MarkupPerRecipient": @(markupPerRecipient),
                    @"MarkupOnDesignSpamTest": @(markupOnDesignSpamTest),
                };
                
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs setClientPAYGBillingSettingsWithClientID:clientID
                                                        currency:currency
                                              canPurchaseCredits:canPurchaseCredits
                                                      clientPays:clientPays
                                                markupPercentage:markupPercentage
                                                markupOnDelivery:markupOnDelivery
                                              markupPerRecipient:markupPerRecipient
                                          markupOnDesignSpamTest:markupOnDesignSpamTest
                                               completionHandler:^() { }
                                                    errorHandler:^(NSError *errorResponse) { error = errorResponse; }
                    ];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });
        
        context(@"set monthly billing", ^{
            NSString *currency = CSAPICurrencyCanadianDollars;
            BOOL clientPays = YES;
            float markupPercentage = 150.0f;
            
            it(@"should set monthly billing", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^ {
                    [cs setClientMonthlyBillingWithClientID:clientID
                                                   currency:currency
                                                 clientPays:clientPays
                                           markupPercentage:markupPercentage
                                          completionHandler:^() {}
                                               errorHandler:^(NSError *errorResponse) { [errorResponse shouldBeNil]; }
                     ];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/setmonthlybilling.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
                
                NSDictionary *expectedPostBody = @{
                    @"Currency": currency,
                    @"ClientPays": @(clientPays),
                    @"MarkupPercentage": @(markupPercentage),
                };
                
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs setClientMonthlyBillingWithClientID:clientID
                                                   currency:currency
                                                 clientPays:clientPays
                                           markupPercentage:markupPercentage
                                          completionHandler:^() {}
                                                    errorHandler:^(NSError *errorResponse) { error = errorResponse; }
                     ];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });
        
        context(@"get details of a client", ^{
            it(@"should get details of a client", ^{
                NSURLRequest *request = nil;
                __block CSClient *client = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"client_details.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getClientDetailsWithClientID:clientID completionHandler:^(CSClient *response) {
                        client = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[client.APIKey should] equal:@"639d8cc27198202f5fe6037a8b17a29a59984b86d3289bc9"];
                [[client.username should] equal:@"clientone"];
                [[theValue(client.accessLevel) should] equal:theValue(23)];
                
                [[client.clientID should] equal:@"4a397ccaaa55eb4e6aa1221e1e2d7122"];
                [[client.name should] equal:@"Client One"];
                [[client.contactName should] equal:@"Client One (contact)"];
                [[client.emailAddress should] equal:@"contact@example.com"];
                [[client.country should] equal:@"Australia"];
                [[client.timezone should] equal:@"(GMT+10:00) Canberra, Melbourne, Sydney"];
                
                [[theValue(client.canPurchaseCredits) should] beTrue];
                [[theValue(client.credits) should] equal:theValue(500)];
                [[theValue(client.clientPays) should] beTrue];
                [[client.currency should] equal:CSAPICurrencyUSDollars];
                [[theValue(client.markupOnDesignSpamTest) should] equal:theValue(0.0)];
                [[theValue(client.baseRatePerRecipient) should] equal:theValue(1.0)];
                [[theValue(client.markupPerRecipient) should] equal:theValue(0.0)];
                [[theValue(client.markupOnDelivery) should] equal:theValue(0.0)];
                [[theValue(client.baseDeliveryRate) should] equal:theValue(5.0)];
                [[theValue(client.baseDesignSpamTestRate) should] equal:theValue(5.0)];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getClientDetailsWithClientID:clientID completionHandler:^(CSClient *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });
        
        context(@"get sent campaigns with clientID", ^{
            it(@"should get the sent campaigns for a client", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"campaigns.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *campaigns = nil;
                    [cs getSentCampaignsWithClientID:clientID completionHandler:^(NSArray *response) {
                        campaigns = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [[[campaigns should] have:2] items];
                    
                    CSCampaign *campaign = [campaigns objectAtIndex:0];
                    [[campaign.campaignID should] equal:@"fc0ce7105baeaf97f47c99be31d02a91"];
                    [[campaign.name should] equal:@"Campaign One"];
                    [[campaign.subject should] equal:@"Campaign One"];
                    [[campaign.webVersionPage should] equal:@"http://createsend.com/t/r-765E86829575EE2C"];
                    [[campaign.webVersionTextPage should] equal:@"http://createsend.com/t/r-765E86829575EE2C/t"];
                    [[campaign.dateSent should] equal:[[CSAPI sharedDateFormatter] dateFromString:@"2010-10-12 12:58:00"]];
                    [[theValue(campaign.totalRecipients) should] equal:theValue(2245)];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/campaigns.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getSentCampaignsWithClientID:clientID completionHandler:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });
        
        context(@"get scheduled campaigns with clientID", ^{
            it(@"should get the scheduled campaigns for a client", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"scheduled_campaigns.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *campaigns = nil;
                    [cs getScheduledCampaignsWithClientID:clientID completionHandler:^(NSArray *response) {
                        campaigns = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [[[campaigns should] have:2] items];
                    
                    CSCampaign *campaign = [campaigns objectAtIndex:0];
                    [[campaign.campaignID should] equal:@"827dbbd2161ea9989fa11ad562c66937"];
                    [[campaign.name should] equal:@"Magic Issue One"];
                    [[campaign.subject should] equal:@"Magic Issue One"];
                    [[campaign.previewPage should] equal:@"http://createsend.com/t/r-DD543521A87C9B8B"];
                    [[campaign.previewTextPage should] equal:@"http://createsend.com/t/r-DD543521A87C9B8B/t"];
                    [[campaign.dateCreated should] equal:[[CSAPI sharedDateFormatter] dateFromString:@"2011-05-24 10:37:00"]];
                    [[campaign.dateScheduled should] equal:[[CSAPI sharedDateFormatter] dateFromString:@"2011-05-25 10:40:00"]];
                    [[campaign.scheduledTimeZone should] equal:@"(GMT+10:00) Canberra, Melbourne, Sydney"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/scheduled.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getScheduledCampaignsWithClientID:clientID completionHandler:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });
        
        context(@"get draft campaigns with clientID", ^{
            it(@"should get the draft campaigns for a client", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"drafts.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *campaigns = nil;
                    [cs getDraftCampaignsWithClientID:clientID completionHandler:^(NSArray *response) {
                        campaigns = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [[[campaigns should] have:2] items];
                    
                    CSCampaign *campaign = [campaigns objectAtIndex:0];
                    [[campaign.campaignID should] equal:@"7c7424792065d92627139208c8c01db1"];
                    [[campaign.name should] equal:@"Draft One"];
                    [[campaign.subject should] equal:@"Draft One"];
                    [[campaign.previewPage should] equal:@"http://createsend.com/t/r-E97A7BB2E6983DA1"];
                    [[campaign.previewTextPage should] equal:@"http://createsend.com/t/r-E97A7BB2E6983DA1/t"];
                    [[campaign.dateCreated should] equal:[[CSAPI sharedDateFormatter] dateFromString:@"2010-08-19 16:08:00"]];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/drafts.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getDraftCampaignsWithClientID:clientID completionHandler:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });
        
        context(@"get subscriber lists with clientID", ^{
            it(@"should get the subscriber lists for a client", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"lists.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *lists = nil;
                    [cs getSubscriberListsWithClientID:clientID completionHandler:^(NSArray *response) {
                        lists = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [[[lists should] have:2] items];
                    
                    CSList *firstList = [lists objectAtIndex:0];
                    [[firstList.listID should] equal:@"a58ee1d3039b8bec838e6d1482a8a965"];
                    [[firstList.name should] equal:@"List One"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/lists.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getSubscriberListsWithClientID:clientID completionHandler:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });
        
        context(@"get suppression lists with clientID", ^{
            it(@"should get the suppression lists for a client", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"suppressionlist.json" returningRequest:&request whileExecutingBlock:^{
                    __block CSPaginatedResult *paginatedResult = nil;
                    [cs getSuppressionListWithClientID:clientID page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
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
                    
                    CSSuppressedRecipient *firstRecipient = [paginatedResult objectAtIndex:0];
                    [[firstRecipient.suppressionReason should] equal:@"Unsubscribed"];
                    [[firstRecipient.emailAddress should] equal:@"example+1@example.com"];
                    [[firstRecipient.date should] equal:[[CSAPI sharedDateFormatter] dateFromString:@"2010-10-26 10:55:31"]];
                    [[firstRecipient.state should] equal:@"Suppressed"];
                }];
                
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/suppressionlist.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.path should] equal:expectedURL.path];
                
                NSDictionary *parameters = [request.URL cs_queryValuesForKeys:@[@"page", @"pagesize", @"orderfield", @"orderdirection", @"date"] error:nil];
                NSDictionary *expectedParameters = @{@"page": @"1", @"pagesize": @"1000", @"orderfield": CSAPIOrderByEmail, @"orderdirection": @"asc"};
                [[parameters should] equal:expectedParameters];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getSuppressionListWithClientID:clientID page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });
        
        context(@"get segments with clientID", ^{
            it(@"should get the segments for a client", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"segments.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *segments = nil;
                    [cs getSegmentsWithClientID:clientID completionHandler:^(NSArray *response) {
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
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/segments.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getSegmentsWithClientID:clientID completionHandler:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });
        
        context(@"get templates with clientID", ^{
            it(@"should get the templates for a client", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"templates.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *templates = nil;
                    [cs getTemplatesWithClientID:clientID completionHandler:^(NSArray *response) {
                        templates = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [[[templates should] have:2] items];
                    
                    CSTemplate *firstTemplate = [templates objectAtIndex:0];
                    [[firstTemplate.templateID should] equal:@"5cac213cf061dd4e008de5a82b7a3621"];
                    [[firstTemplate.name should] equal:@"Template One"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/templates.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getTemplatesWithClientID:clientID completionHandler:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });
        
        context(@"add a person", ^{
            NSString *name = @"Person";
            NSString *emailAddress = @"person@example.com";
            NSString *password = @"Password";
            NSUInteger accessLevel = 0;
            
            it(@"should add a person", ^{
                NSURLRequest *request = nil;
                __block NSString *personEmailAddress = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"add_person.json" returningRequest:&request whileExecutingBlock:^{
                    [cs addPersonWithClientID:clientID name:name emailAddress:emailAddress password:password accessLevel:accessLevel completionHandler:^(NSString *response) {
                        personEmailAddress = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[personEmailAddress should] equal:emailAddress];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/people.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"Name": name, @"EmailAddress": emailAddress, @"Password": password, @"AccessLevel": @(accessLevel)};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs addPersonWithClientID:clientID name:name emailAddress:emailAddress password:password accessLevel:accessLevel completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage];
                }];
            });
        });
        
        context(@"update a person", ^{
            NSString *name = @"Person";
            NSString *emailAddress = @"person@example.com";
            NSString *newEmailAddress = @"new_email_address@example.com";
            NSString *newPassword = @"NewPassword";
            NSUInteger accessLevel = 1023;
            
            it(@"should update a person", ^{
                NSURLRequest *request = nil;
                __block NSString *personEmailAddress = nil;
                [NSURLConnection stubSendAsynchronousRequestAndExecuteCompletionHandlerWithDataFromDictionary:@{@"EmailAddress": newEmailAddress} returningRequest:&request whileExecutingBlock:^{
                    [cs updatePersonWithClientID:clientID name:name currentEmailAddress:emailAddress newEmailAddress:newEmailAddress password:newPassword accessLevel:accessLevel completionHandler:^(NSString *response) {
                        personEmailAddress = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[personEmailAddress should] equal:newEmailAddress];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/people.json?email=%@", clientID, [emailAddress cs_urlEncodedString]] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
                
                NSDictionary *expectedPostBody = @{@"Name": name, @"EmailAddress": newEmailAddress, @"Password": newPassword, @"AccessLevel": @(accessLevel)};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs updatePersonWithClientID:clientID name:name currentEmailAddress:emailAddress newEmailAddress:newEmailAddress password:newPassword accessLevel:accessLevel completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage];
                }];
            });
        });
        
        context(@"delete a person", ^{
            NSString *emailAddress = @"person@example.com";
            
            it(@"should delete a person", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^ {
                    [cs deletePersonWithClientID:clientID emailAddress:emailAddress completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/people.json?email=%@", clientID, [emailAddress cs_urlEncodedString]] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"DELETE"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs deletePersonWithClientID:clientID emailAddress:emailAddress completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage];
                }];
            });
        });
        
        context(@"get a person by email address", ^{
            NSString *emailAddress = @"person@example.com";
            
            it(@"should get a person by email address", ^{
                NSURLRequest *request = nil;
                __block CSPerson *person = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"person_details.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getPersonDetailsWithClientID:clientID emailAddress:emailAddress completionHandler:^(CSPerson *response) {
                        person = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[person.name should] equal:@"Person One"];
                [[person.emailAddress should] equal:emailAddress];
                [[theValue(person.accessLevel) should] equal:theValue(1023)];
                [[person.status should] equal:@"Active"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/people.json?email=%@", clientID, [emailAddress cs_urlEncodedString]] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getPersonDetailsWithClientID:clientID emailAddress:emailAddress completionHandler:^(CSPerson *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get all people", ^{
            it(@"should get all people", ^{
                NSURLRequest *request = nil;
                __block NSArray *people = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"people.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getPeopleWithClientID:clientID completionHandler:^(NSArray *response) {
                        people = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[[people should] have: 2] items];
                CSPerson *firstPerson = [people objectAtIndex:0];
                [[firstPerson.name should] equal:@"Person One"];
                [[firstPerson.emailAddress should] equal:@"person1@blackhole.com"];
                [[theValue(firstPerson.accessLevel) should] equal:theValue(31)];
                [[firstPerson.status should] equal:@"Active"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/people.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getPeopleWithClientID:clientID completionHandler:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"set primary contact", ^{
            NSString *emailAddress = @"person@blackhole.com";
            
            it(@"should set primary contact", ^{
                NSURLRequest *request = nil;
                __block NSString *primaryContactEmailAddress = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"client_set_primary_contact.json" returningRequest:&request whileExecutingBlock:^{
                    [cs setPrimaryContactWithClientID:clientID emailAddress:emailAddress completionHandler:^(NSString *response) {
                        primaryContactEmailAddress = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[primaryContactEmailAddress should] equal:emailAddress];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/primarycontact.json?email=%@", clientID, [emailAddress cs_urlEncodedString]] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs setPrimaryContactWithClientID:clientID emailAddress:emailAddress completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage];
                }];
            });
        });
        
        context(@"get primary contact", ^{
            it(@"should get primary contact", ^{
                NSURLRequest *request = nil;
                __block NSString *primaryContactEmailAddress = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"client_get_primary_contact.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getPrimaryContactWithClientID:clientID completionHandler:^(NSString *response) {
                        primaryContactEmailAddress = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[primaryContactEmailAddress should] equal:@"person@blackhole.com"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"clients/%@/primarycontact.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getPrimaryContactWithClientID:clientID completionHandler:^(NSString *response) {
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