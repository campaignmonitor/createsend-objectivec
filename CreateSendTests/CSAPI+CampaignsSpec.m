#import "CSSpecHelper.h"
#import "NSURL+CSAPI.h"

#import "CSAPI.h"
#import "CSClient.h"
#import "CSList.h"

SPEC_BEGIN(CSAPICampaignsSpec)

describe(@"CSAPI+Campaigns", ^{
    registerMatchers(@"OV");
    
    context(@"when an api caller is authenticated", ^{
        __block CSAPI *cs = nil;
        __block CSCampaign *campaign = nil;
        
        beforeEach(^{
            cs = [[CSAPI alloc] init];
            campaign = [[CSCampaign alloc] init];
            campaign.campaignID = @"787y87y87y87y87y87y87";
        });
        
        context(@"create a campaign", ^{
            NSString *clientID = @"87y8d7qyw8d7yq8w7ydwqwd";
            NSString *name = @"Campaign Name";
            NSString *subject = @"Campaign Subject";
            NSString *fromName = @"My Name";
            NSString *fromEmail = @"good.day@example.com";
            NSString *replyTo = @"gday.mate@example.com";
            NSString *htmlURL = @"http://example.com/campaign.html";
            NSString *textURL = @"http://example.com/campaign.txt";
            NSArray *listIDs = @[@"7y12989e82ue98u2e", @"dh9w89q8w98wudwd989"];
            NSArray *segmentIDs = @[@"y78q9w8d9w8ud9q8uw", @"djw98quw9duqw98uwd98"];
            
            it(@"should create a campaign", ^{
                NSURLRequest *request = nil;
                __block NSString *campaignID = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"create_campaign.json" returningRequest:&request whileExecutingBlock:^{
                    [cs createCampaignWithClientID:clientID name:name subject:subject fromName:fromName fromEmail:fromEmail replyTo:replyTo htmlURL:htmlURL textURL:textURL listIDs:listIDs segmentIDs:segmentIDs completionHandler:^(NSString *response) {
                        campaignID = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[campaignID should] equal:@"787y87y87y87y87y87y87"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{
                    @"Name": name,
                    @"Subject": subject,
                    @"FromName": fromName,
                    @"FromEmail": fromEmail,
                    @"ReplyTo": replyTo,
                    @"HtmlUrl": htmlURL,
                    @"TextUrl": textURL,
                    @"ListIDs": listIDs,
                    @"SegmentIDs": segmentIDs
                };
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs createCampaignWithClientID:clientID name:name subject:subject fromName:fromName fromEmail:fromEmail replyTo:replyTo htmlURL:htmlURL textURL:textURL listIDs:listIDs segmentIDs:segmentIDs completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });
        
        context(@"delete a campaign", ^{
            it(@"should delete a campaign", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs deleteCampaignWithID:campaign.campaignID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"DELETE"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs deleteCampaignWithID:campaign.campaignID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"send a draft campaign", ^{
            NSString *emailAddress = @"confirmation@example.com";
            NSDate *sendDate = [NSDate date];
            
            it(@"should send a draft campaign", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs sendCampaignWithCampaignID:campaign.campaignID confirmationEmailAddress:emailAddress sendDate:sendDate completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@/send.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"ConfirmationEmail": emailAddress, @"SendDate": [[CSAPI sharedDateFormatter] stringFromDate:sendDate]};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs sendCampaignWithCampaignID:campaign.campaignID confirmationEmailAddress:emailAddress sendDate:sendDate completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"send a draft campaign immediately", ^{
            NSString *emailAddress = @"confirmation@example.com";

            it(@"should send a draft campaign immediately", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs sendCampaignImmediatelyWithCampaignID:campaign.campaignID confirmationEmailAddress:emailAddress completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@/send.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"ConfirmationEmail": emailAddress, @"SendDate": @"Immediately"};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs sendCampaignImmediatelyWithCampaignID:campaign.campaignID confirmationEmailAddress:emailAddress completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"send a campaign preview", ^{
            NSArray *recipients = @[@"test+89898u9@example.com", @"test+787y8y7y8@example.com"];
            NSString *personalize = CSAPICampaignPreviewPersonalizeRandom;
            
            it(@"should send a campaign preview", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs sendCampaignPreviewWithCampaignID:campaign.campaignID recipients:recipients personalize:personalize completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@/sendpreview.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"PreviewRecipients": recipients, @"Personalize": personalize};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs sendCampaignPreviewWithCampaignID:campaign.campaignID recipients:recipients personalize:personalize completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"unschedule a campaign", ^{
            it(@"should unschedule a campaign", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs unscheduleCampaignWithID:campaign.campaignID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@/unschedule.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs unscheduleCampaignWithID:campaign.campaignID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });

        context(@"get a campaign summary", ^{
            it(@"should get a campaign summary", ^{
                NSURLRequest *request = nil;
                __block CSCampaignSummary *campaignSummary = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"campaign_summary.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getCampaignSummaryWithCampaignID:campaign.campaignID completionHandler:^(CSCampaignSummary *response) {
                        campaignSummary = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[theValue(campaignSummary.recipientCount) should] equal:theValue(5)];
                [[theValue(campaignSummary.openedCount) should] equal:theValue(10)];
                [[theValue(campaignSummary.clickCount) should] equal:theValue(0)];
                [[theValue(campaignSummary.unsubscribedCount) should] equal:theValue(0)];
                [[theValue(campaignSummary.bouncedCount) should] equal:theValue(0)];
                [[theValue(campaignSummary.uniqueOpenedCount) should] equal:theValue(5)];
                [[theValue(campaignSummary.spamComplaints) should] equal:theValue(23)];
                [[theValue(campaignSummary.mentionsCount) should] equal:theValue(23)];
                [[theValue(campaignSummary.forwardsCount) should] equal:theValue(11)];
                [[theValue(campaignSummary.likesCount) should] equal:theValue(32)];
                [[campaignSummary.webVersionPage should] equal:@"http://createsend.com/t/r-3A433FC72FFE3B8B"];
                [[campaignSummary.webVersionTextPage should] equal:@"http://createsend.com/t/r-3A433FC72FFE3B8B/t"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@/summary.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getCampaignSummaryWithCampaignID:campaign.campaignID completionHandler:^(CSCampaignSummary *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get campaign email client usage", ^{
            it(@"should get campaign email client usage", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"email_client_usage.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *emailClientUsage = nil;
                    [cs getCampaignEmailClientUsageWithCampaignID:campaign.campaignID completionHandler:^(NSArray *response) {
                        emailClientUsage = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];

                    [[[emailClientUsage should] have:6] items];
                    
                    CSCampaignEmailClient *firstEmailClient = [emailClientUsage objectAtIndex:0];
                    [[firstEmailClient.client should] equal:@"iOS Devices"];
                    [[firstEmailClient.version should] equal:@"iPhone"];
                    [[theValue(firstEmailClient.percentage) should] equal:theValue(19.83f)];
                    [[theValue(firstEmailClient.subscribers) should] equal:theValue(7056)];
                }];

                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@/emailclientusage.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });

            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getCampaignEmailClientUsageWithCampaignID:campaign.campaignID completionHandler:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });

        context(@"get the lists and segments for a campaign", ^{
            it(@"should get the lists and segments for a campaign", ^{
                NSURLRequest *request = nil;
                __block NSArray *lists = nil;
                __block NSArray *segments = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"campaign_listsandsegments.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getCampaignListsAndSegmentsWithCampaignID:campaign.campaignID completionHandler:^(NSArray *theLists, NSArray *theSegments) {
                        lists = theLists;
                        segments = theSegments;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[[lists should] have: 1] items];
                CSList *list = [lists objectAtIndex:0];
                [[list.listID should] equal:@"a58ee1d3039b8bec838e6d1482a8a965"];
                [[list.name should] equal:@"List One"];
                
                [[[segments should] have: 1] items];
                CSSegment *segment = [segments objectAtIndex:0];
                [[segment.segmentID should] equal:@"dba84a225d5ce3d19105d7257baac46f"];
                [[segment.listID should] equal:@"2bea949d0bf96148c3e6a209d2e82060"];
                [[segment.title should] equal:@"Segment for campaign"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@/listsandsegments.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getCampaignSummaryWithCampaignID:campaign.campaignID completionHandler:^(CSCampaignSummary *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get the recipients for a campaign", ^{
            it(@"should get the recipients for a campaign", ^{
                NSURLRequest *request = nil;
                __block CSPaginatedResult *paginatedResult = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"campaign_recipients.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getCampaignRecipientsWithCampaignID:campaign.campaignID page:1 pageSize:20 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        paginatedResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [paginatedResult shouldNotBeNil];
                [[paginatedResult.orderedBy should] equal:CSAPIOrderByEmail];
                [[theValue(paginatedResult.ascending) should] beTrue];
                [[theValue(paginatedResult.page) should] equal:theValue(1)];
                [[theValue(paginatedResult.pageSize) should] equal:theValue(20)];
                [[theValue(paginatedResult.resultCount) should] equal:theValue(20)];
                [[theValue(paginatedResult.totalResultCount) should] equal:theValue(2200)];
                [[theValue(paginatedResult.totalPages) should] equal:theValue(110)];
                [[[paginatedResult.results should] have:20] items];
                
                CSCampaignRecipient *recipient = [paginatedResult objectAtIndex:0];
                [[recipient.emailAddress should] equal:@"subs+6g76t7t0@example.com"];
                [[recipient.listID should] equal:@"a994a3caf1328a16af9a69a730eaa706"];
                                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@/recipients.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.path should] equal:expectedURL.path];
                
                NSDictionary *parameters = [request.URL cs_queryValuesForKeys:@[@"page", @"pagesize", @"orderfield", @"orderdirection", @"date"] error:nil];
                NSDictionary *expectedParameters = @{@"page": @"1", @"pagesize": @"20", @"orderfield": CSAPIOrderByEmail, @"orderdirection": @"asc"};
                [[parameters should] equal:expectedParameters];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getCampaignRecipientsWithCampaignID:campaign.campaignID page:1 pageSize:1000 orderField:CSAPIOrderByEmail ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get the opens for a campaign", ^{
            NSDate *date = [NSDate date];
            
            it(@"should get the opens for a campaign", ^{
                NSURLRequest *request = nil;
                __block CSPaginatedResult *paginatedResult = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"campaign_opens.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getCampaignOpensWithCampaignID:campaign.campaignID date:date page:1 pageSize:1000 orderField:CSAPIOrderByDate ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        paginatedResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [paginatedResult shouldNotBeNil];
                [[paginatedResult.orderedBy should] equal:CSAPIOrderByDate];
                [[theValue(paginatedResult.ascending) should] beTrue];
                [[theValue(paginatedResult.page) should] equal:theValue(1)];
                [[theValue(paginatedResult.pageSize) should] equal:theValue(1000)];
                [[theValue(paginatedResult.resultCount) should] equal:theValue(5)];
                [[theValue(paginatedResult.totalResultCount) should] equal:theValue(5)];
                [[theValue(paginatedResult.totalPages) should] equal:theValue(1)];
                [[[paginatedResult.results should] have:5] items];
                
                CSCampaignRecipient *recipient = [paginatedResult objectAtIndex:0];
                [[recipient.emailAddress should] equal:@"subs+6576576576@example.com"];
                [[recipient.listID should] equal:@"512a3bc577a58fdf689c654329b50fa0"];
                [[recipient.IPAddress should] equal:@"192.168.126.87"];
                [[recipient.date should] equal:[[CSAPI sharedDateFormatter] dateFromString:@"2010-10-11 08:29:00"]];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@/opens.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.path should] equal:expectedURL.path];
                
                NSDictionary *parameters = [request.URL cs_queryValuesForKeys:@[@"page", @"pagesize", @"orderfield", @"orderdirection", @"date"] error:nil];
                NSDictionary *expectedParameters = @{@"page": @"1", @"pagesize": @"1000", @"orderfield": CSAPIOrderByDate, @"orderdirection": @"asc"};
                [[parameters should] equal:expectedParameters];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getCampaignOpensWithCampaignID:campaign.campaignID date:date page:1 pageSize:1000 orderField:CSAPIOrderByDate ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get the clicks for a campaign", ^{
            NSDate *date = [NSDate date];
            
            it(@"should get the clicks for a campaign", ^{
                NSURLRequest *request = nil;
                __block CSPaginatedResult *paginatedResult = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"campaign_clicks.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getCampaignClicksWithCampaignID:campaign.campaignID date:date page:1 pageSize:1000 orderField:CSAPIOrderByDate ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        paginatedResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [paginatedResult shouldNotBeNil];
                [[paginatedResult.orderedBy should] equal:CSAPIOrderByDate];
                [[theValue(paginatedResult.ascending) should] beTrue];
                [[theValue(paginatedResult.page) should] equal:theValue(1)];
                [[theValue(paginatedResult.pageSize) should] equal:theValue(1000)];
                [[theValue(paginatedResult.resultCount) should] equal:theValue(3)];
                [[theValue(paginatedResult.totalResultCount) should] equal:theValue(3)];
                [[theValue(paginatedResult.totalPages) should] equal:theValue(1)];
                [[[paginatedResult.results should] have:3] items];
                
                CSCampaignRecipientClicked *recipient = [paginatedResult objectAtIndex:0];
                [[recipient.emailAddress should] equal:@"subs+6576576576@example.com"];
                [[recipient.listID should] equal:@"512a3bc577a58fdf689c654329b50fa0"];
                [[recipient.IPAddress should] equal:@"192.168.126.87"];
                [[recipient.date should] equal:[[CSAPI sharedDateFormatter] dateFromString:@"2010-10-11 08:29:00"]];
                [[recipient.URL.absoluteString should] equal:@"http://video.google.com.au/?hl=en&tab=wv"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@/clicks.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.path should] equal:expectedURL.path];
                
                NSDictionary *parameters = [request.URL cs_queryValuesForKeys:@[@"page", @"pagesize", @"orderfield", @"orderdirection", @"date"] error:nil];
                NSDictionary *expectedParameters = @{@"page": @"1", @"pagesize": @"1000", @"orderfield": CSAPIOrderByDate, @"orderdirection": @"asc"};
                [[parameters should] equal:expectedParameters];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getCampaignClicksWithCampaignID:campaign.campaignID date:date page:1 pageSize:1000 orderField:CSAPIOrderByDate ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get the unsubscribes for a campaign", ^{
            NSDate *date = [NSDate date];
            
            it(@"should get the unsubscribes for a campaign", ^{
                NSURLRequest *request = nil;
                __block CSPaginatedResult *paginatedResult = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"campaign_unsubscribes.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getCampaignUnsubscribesWithCampaignID:campaign.campaignID date:date page:1 pageSize:1000 orderField:CSAPIOrderByDate ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        paginatedResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [paginatedResult shouldNotBeNil];
                [[paginatedResult.orderedBy should] equal:CSAPIOrderByDate];
                [[theValue(paginatedResult.ascending) should] beTrue];
                [[theValue(paginatedResult.page) should] equal:theValue(1)];
                [[theValue(paginatedResult.pageSize) should] equal:theValue(1000)];
                [[theValue(paginatedResult.resultCount) should] equal:theValue(1)];
                [[theValue(paginatedResult.totalResultCount) should] equal:theValue(1)];
                [[theValue(paginatedResult.totalPages) should] equal:theValue(1)];
                [[[paginatedResult.results should] have:1] items];
                
                CSCampaignRecipient *recipient = [paginatedResult objectAtIndex:0];
                [[recipient.emailAddress should] equal:@"subs+6576576576@example.com"];
                [[recipient.listID should] equal:@"512a3bc577a58fdf689c654329b50fa0"];
                [[recipient.IPAddress should] equal:@"192.168.126.87"];
                [[recipient.date should] equal:[[CSAPI sharedDateFormatter] dateFromString:@"2010-10-11 08:29:00"]];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@/unsubscribes.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.path should] equal:expectedURL.path];
                
                NSDictionary *parameters = [request.URL cs_queryValuesForKeys:@[@"page", @"pagesize", @"orderfield", @"orderdirection", @"date"] error:nil];
                NSDictionary *expectedParameters = @{@"page": @"1", @"pagesize": @"1000", @"orderfield": CSAPIOrderByDate, @"orderdirection": @"asc"};
                [[parameters should] equal:expectedParameters];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getCampaignUnsubscribesWithCampaignID:campaign.campaignID date:date page:1 pageSize:1000 orderField:CSAPIOrderByDate ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });

        context(@"get the spam complaints for a campaign", ^{
            NSDate *date = [NSDate date];

            it(@"should get the spam complaints for a campaign", ^{
                NSURLRequest *request = nil;
                __block CSPaginatedResult *paginatedResult = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"campaign_spam.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getCampaignSpamComplaintsWithCampaignID:campaign.campaignID date:date page:1 pageSize:1000 orderField:CSAPIOrderByDate ascending:YES completionHandler:^(CSPaginatedResult *response) {
                        paginatedResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [paginatedResult shouldNotBeNil];
                [[paginatedResult.orderedBy should] equal:CSAPIOrderByDate];
                [[theValue(paginatedResult.ascending) should] beTrue];
                [[theValue(paginatedResult.page) should] equal:theValue(1)];
                [[theValue(paginatedResult.pageSize) should] equal:theValue(1000)];
                [[theValue(paginatedResult.resultCount) should] equal:theValue(1)];
                [[theValue(paginatedResult.totalResultCount) should] equal:theValue(1)];
                [[theValue(paginatedResult.totalPages) should] equal:theValue(1)];
                [[[paginatedResult.results should] have:1] items];

                CSCampaignRecipient *recipient = [paginatedResult objectAtIndex:0];
                [[recipient.emailAddress should] equal:@"subs+6576576576@example.com"];
                [[recipient.listID should] equal:@"512a3bc577a58fdf689c654329b50fa0"];
                [[recipient.date should] equal:[[CSAPI sharedDateFormatter] dateFromString:@"2010-10-11 08:29:00"]];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"campaigns/%@/spam.json", campaign.campaignID] relativeToURL:cs.baseURL];
                [[request.URL.path should] equal:expectedURL.path];
                
                NSDictionary *parameters = [request.URL cs_queryValuesForKeys:@[@"page", @"pagesize", @"orderfield", @"orderdirection", @"date"] error:nil];
                NSDictionary *expectedParameters = @{@"page": @"1", @"pagesize": @"1000", @"orderfield": CSAPIOrderByDate, @"orderdirection": @"asc"};
                [[parameters should] equal:expectedParameters];
            });

            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getCampaignSpamComplaintsWithCampaignID:campaign.campaignID date:date page:1 pageSize:1000 orderField:CSAPIOrderByDate ascending:YES completionHandler:^(CSPaginatedResult *response) {
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