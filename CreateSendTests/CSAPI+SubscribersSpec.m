#import "CSSpecHelper.h"
#import "CSSubscriber.h"
#import "CSList.h"
#import "CSAPI.h"

SPEC_BEGIN(CSAPISubscribersSpec)

describe(@"CSAPI+Subscribers", ^{
    registerMatchers(@"OV");
    
    context(@"when an api caller is authenticated", ^{
        __block CSAPI *cs = nil;
        NSString *emailAddress = @"subscriber@example.com";
        NSString *name = @"Subscriber";
        NSString *listID = @"d98h2938d9283d982u3d98u88";
        
        beforeEach(^{
            cs = [[CSAPI alloc] init];
        });
        
        context(@"subscribe to list", ^{
            BOOL shouldResubscribe = YES;
            
            it(@"should add a subscriber without custom fields", ^{
                NSURLRequest *request = nil;
                __block NSString *subscribedAddress = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"add_subscriber.json" returningRequest:&request whileExecutingBlock:^{
                    [cs subscribeToListWithID:listID emailAddress:emailAddress name:name shouldResubscribe:shouldResubscribe customFields:nil completionHandler:^(NSString *response) {
                        subscribedAddress = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[subscribedAddress should] equal:emailAddress];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"subscribers/%@.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"EmailAddress": emailAddress, @"Name": name, @"Resubscribe": @(shouldResubscribe), @"CustomFields": @[]};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should add a subscriber with only an email address", ^{
                NSURLRequest *request = nil;
                __block NSString *subscribedAddress = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"add_subscriber.json" returningRequest:&request whileExecutingBlock:^{
                    [cs subscribeToListWithID:listID emailAddress:emailAddress name:nil shouldResubscribe:shouldResubscribe customFields:nil completionHandler:^(NSString *response) {
                        subscribedAddress = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[subscribedAddress should] equal:emailAddress];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"subscribers/%@.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"EmailAddress": emailAddress, @"Resubscribe": @(shouldResubscribe), @"CustomFields": @[]};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should add a subscriber with custom fields", ^{
                NSDate *birthDate = [NSDate dateWithTimeIntervalSince1970:1340216160];
                NSArray *customFields = @[[CSCustomField customFieldWithKey:@"website" value:@"http://example.com"], [CSCustomField customFieldWithKey:@"birthdate" value:birthDate]];
                NSURLRequest *request = nil;
                __block NSString *subscribedAddress = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"add_subscriber.json" returningRequest:&request whileExecutingBlock:^{
                    [cs subscribeToListWithID:listID emailAddress:emailAddress name:name shouldResubscribe:shouldResubscribe customFields:customFields completionHandler:^(NSString *response) {
                        subscribedAddress = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[subscribedAddress should] equal:emailAddress];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"subscribers/%@.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"EmailAddress": emailAddress, @"Name": name, @"Resubscribe": @(shouldResubscribe), @"CustomFields": [customFields valueForKey:@"dictionaryValue"]};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should add a subscriber with custom fields including multi-option fields", ^{
                NSMutableArray *customFields = [[NSMutableArray alloc] init];
                [customFields addObject:[CSCustomField customFieldWithKey:@"multioptionselectone" value:@"myoption"]];
                [customFields addObject:[CSCustomField customFieldWithKey:@"multioptionselectmany" value:@"firstoption"]];
                [customFields addObject:[CSCustomField customFieldWithKey:@"multioptionselectmany" value:@"secondoption"]];
                
                NSURLRequest *request = nil;
                __block NSString *subscribedAddress = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"add_subscriber.json" returningRequest:&request whileExecutingBlock:^{
                    [cs subscribeToListWithID:listID emailAddress:emailAddress name:name shouldResubscribe:shouldResubscribe customFields:customFields completionHandler:^(NSString *response) {
                        subscribedAddress = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[subscribedAddress should] equal:emailAddress];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"subscribers/%@.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"EmailAddress": emailAddress, @"Name": name, @"Resubscribe": @(shouldResubscribe), @"CustomFields": [customFields valueForKey:@"dictionaryValue"]};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs subscribeToListWithID:listID emailAddress:emailAddress name:name shouldResubscribe:shouldResubscribe customFields:nil completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage];
                }];
            });
        });
        
        context(@"update a subscriber", ^{
            NSString *newEmailAddress = @"new_email_address@example.com";
            BOOL shouldResubscribe = YES;
            NSArray *customFields = @[[CSCustomField customFieldWithKey:@"website" value:@"http://example.com/"]];

            it(@"should update a subscriber with custom fields", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs updateSubscriptionWithListID:listID currentEmailAddress:emailAddress newEmailAddress:newEmailAddress name:name shouldResubscribe:shouldResubscribe customFields:customFields completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"subscribers/%@.json?email=%@", listID, [emailAddress cs_urlEncodedString]] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
                
                NSDictionary *expectedPostBody = @{@"EmailAddress": newEmailAddress, @"Name": name, @"Resubscribe": @(shouldResubscribe), @"CustomFields": [customFields valueForKey:@"dictionaryValue"]};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should update a subscriber with custom fields including the clear option", ^{
                NSArray *customFields = @[@{@"Key": @"website", @"Value": @"http://example.com/", @"Clear": @(YES)}];
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs updateSubscriptionWithListID:listID currentEmailAddress:emailAddress newEmailAddress:newEmailAddress name:name shouldResubscribe:shouldResubscribe customFields:customFields completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"subscribers/%@.json?email=%@", listID, [emailAddress cs_urlEncodedString]] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
                
                NSDictionary *expectedPostBody = @{@"EmailAddress": newEmailAddress, @"Name": name, @"Resubscribe": @(shouldResubscribe), @"CustomFields": [customFields valueForKey:@"dictionaryValue"]};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
                        
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs updateSubscriptionWithListID:listID currentEmailAddress:emailAddress newEmailAddress:newEmailAddress name:name shouldResubscribe:shouldResubscribe customFields:customFields completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage];
                }];
            });
        });
        
        context(@"unsubscribe a subscriber", ^{
            it(@"should unsubscribe a subscriber", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs unsubscribeFromListWithID:listID emailAddress:emailAddress completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"subscribers/%@/unsubscribe.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];

                NSDictionary *expectedPostBody = @{@"EmailAddress": emailAddress,};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs unsubscribeFromListWithID:listID emailAddress:emailAddress completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage];
                }];
            });
        });
        
        context(@"get a subscriber by list id and email address", ^{
            it(@"should get a subscriber by list id and email address", ^{
                NSURLRequest *request = nil;
                __block CSSubscriber *subscriber = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"subscriber_details.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getSubscriberDetailsWithListID:listID emailAddress:emailAddress completionHandler:^(CSSubscriber *response) {
                        subscriber = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[subscriber.name should] equal:@"Subscriber One"];
                [[subscriber.emailAddress should] equal:emailAddress];
                [[subscriber.state should] equal:@"Active"];
                [[subscriber.date should] equal:[[CSAPI sharedDateFormatter] dateFromString:@"2010-10-25 10:28:00"]];

                [[[subscriber.customFields should] have:3] items];
                CSCustomField *firstCustomField = [subscriber.customFields objectAtIndex:0];
                [[firstCustomField.key should] equal:@"website"];
                [[firstCustomField.value should] equal:@"http://example.com"];
                [[subscriber.readsEmailWith should] equal:@"Gmail"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"subscribers/%@.json?email=%@", listID, [emailAddress cs_urlEncodedString]] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getSubscriberDetailsWithListID:listID emailAddress:emailAddress completionHandler:^(CSSubscriber *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get a subscriber's history", ^{
            it(@"should get a subscriber's history", ^{
                NSURLRequest *request = nil;
                __block NSArray *historyItems = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"subscriber_history.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getSubscriberHistoryWithListID:listID emailAddress:emailAddress completionHandler:^(NSArray *response) {
                        historyItems = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[[historyItems should] have:1] items];
                CSSubscriberHistoryItem *firstItem = [historyItems objectAtIndex:0];
                [[firstItem.typeID should] equal:@"fc0ce7105baeaf97f47c99be31d02a91"];
                [[firstItem.type should] equal:@"Campaign"];
                [[firstItem.name should] equal:@"Campaign One"];

                [[[firstItem.actions should] have:6] items];
                CSSubscriberAction *firstAction = [firstItem.actions objectAtIndex:0];
                [[firstAction.event should] equal:@"Open"];
                [[firstAction.date should] equal:[[CSAPI sharedDateFormatter] dateFromString:@"2010-10-12 13:18:00"]];
                [[firstAction.IPAddress should] equal:@"192.168.126.87"];
                [[firstAction.detail should] equal:@""];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"subscribers/%@/history.json?email=%@", listID, [emailAddress cs_urlEncodedString]] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getSubscriberHistoryWithListID:listID emailAddress:emailAddress completionHandler:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"importing subscribers", ^{
            NSArray *subscribers = @[
                [CSSubscriber subscriberWithEmailAddress:@"example+1@example.com" name:@"Example One" customFields:nil],
                [CSSubscriber subscriberWithEmailAddress:@"example+2@example.com" name:@"Example Two" customFields:nil],
                [CSSubscriber subscriberWithEmailAddress:@"example+3@example.com" name:@"Example Three" customFields:nil]
            ];
            BOOL shouldResubscribe = YES;
            BOOL shouldQueueSubscriptionBasedAutoresponders = NO;
            BOOL shouldRestartSubscriptionBasedAutoresponders = NO;
            
            it(@"should import many subscribers at once", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"import_subscribers.json" returningRequest:&request whileExecutingBlock:^{
                    __block CSSubscriberImportResult *subscriberImportResult = nil;
                    [cs importSubscribersToListWithID:listID subscribers:subscribers shouldResubscribe:shouldResubscribe shouldQueueSubscriptionBasedAutoresponders:shouldQueueSubscriptionBasedAutoresponders shouldRestartSubscriptionBasedAutoresponders:shouldRestartSubscriptionBasedAutoresponders completionHandler:^(CSSubscriberImportResult *response) {
                        subscriberImportResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [subscriberImportResult shouldNotBeNil];
                    [[theValue(subscriberImportResult.totalUniqueEmailsSubmitted) should] equal:theValue(3)];
                    [[theValue(subscriberImportResult.totalExistingSubscribers) should] equal:theValue(0)];
                    [[theValue(subscriberImportResult.totalNewSubscribers) should] equal:theValue(3)];
                    [[subscriberImportResult.duplicateEmailsInSubmission should] beEmpty];
                    [[subscriberImportResult.failureDetails should] beEmpty];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"subscribers/%@/import.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                __block NSMutableArray *expectedSubscribers = [[NSMutableArray alloc] initWithCapacity:subscribers.count];
                [subscribers enumerateObjectsUsingBlock:^(CSSubscriber *subscriber, NSUInteger idx, BOOL *stop) {
                    NSArray *customFieldValues = [subscriber.customFields valueForKey:@"dictionaryValue"];
                    [expectedSubscribers addObject:[CSSubscriber dictionaryWithEmailAddress:subscriber.emailAddress name:subscriber.name customFieldValues:customFieldValues]];
                }];
                
                NSDictionary *expectedPostBody = @{@"Subscribers": expectedSubscribers, @"Resubscribe": @(shouldResubscribe), @"QueueSubscriptionBasedAutoResponders": @(shouldQueueSubscriptionBasedAutoresponders), @"RestartSubscriptionBasedAutoresponders": @(shouldRestartSubscriptionBasedAutoresponders)};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should import many subscribers at once, and start subscription-based autoresponders", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"import_subscribers.json" returningRequest:&request whileExecutingBlock:^{
                    __block CSSubscriberImportResult *subscriberImportResult = nil;
                    [cs importSubscribersToListWithID:listID subscribers:subscribers shouldResubscribe:shouldResubscribe shouldQueueSubscriptionBasedAutoresponders:YES shouldRestartSubscriptionBasedAutoresponders:shouldRestartSubscriptionBasedAutoresponders completionHandler:^(CSSubscriberImportResult *response) {
                        subscriberImportResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [subscriberImportResult shouldNotBeNil];
                    [[theValue(subscriberImportResult.totalUniqueEmailsSubmitted) should] equal:theValue(3)];
                    [[theValue(subscriberImportResult.totalExistingSubscribers) should] equal:theValue(0)];
                    [[theValue(subscriberImportResult.totalNewSubscribers) should] equal:theValue(3)];
                    [[subscriberImportResult.duplicateEmailsInSubmission should] beEmpty];
                    [[subscriberImportResult.failureDetails should] beEmpty];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"subscribers/%@/import.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                __block NSMutableArray *expectedSubscribers = [[NSMutableArray alloc] initWithCapacity:subscribers.count];
                [subscribers enumerateObjectsUsingBlock:^(CSSubscriber *subscriber, NSUInteger idx, BOOL *stop) {
                    NSArray *customFieldValues = [subscriber.customFields valueForKey:@"dictionaryValue"];
                    [expectedSubscribers addObject:[CSSubscriber dictionaryWithEmailAddress:subscriber.emailAddress name:subscriber.name customFieldValues:customFieldValues]];
                }];
                
                NSDictionary *expectedPostBody = @{@"Subscribers": expectedSubscribers, @"Resubscribe": @(shouldResubscribe), @"QueueSubscriptionBasedAutoResponders": @(YES), @"RestartSubscriptionBasedAutoresponders": @(shouldRestartSubscriptionBasedAutoresponders)};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"import many subscribers at once with custom fields, including the clear option", ^{
                CSCustomField *customFieldWithClearOption = [CSCustomField customFieldWithName:@"Website" key:@"website" dataType:CSCustomFieldTextDataType options:nil value:@"http://example1.com"];
                customFieldWithClearOption.clear = YES;
                
                NSArray *subscribersWithCustomFields = @[
                    [CSSubscriber subscriberWithEmailAddress:@"example+1@example.com" name:@"Example One" customFields:@[customFieldWithClearOption]],
                    [CSSubscriber subscriberWithEmailAddress:@"example+2@example.com" name:@"Example Two" customFields:@[[CSCustomField customFieldWithName:@"Website" key:@"website" dataType:CSCustomFieldTextDataType options:nil value:@"http://example2.com"]]],
                    [CSSubscriber subscriberWithEmailAddress:@"example+3@example.com" name:@"Example Three" customFields:@[[CSCustomField customFieldWithName:@"Website" key:@"website" dataType:CSCustomFieldTextDataType options:nil value:@"http://example3.com"]]]
                ];
                
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"import_subscribers.json" returningRequest:&request whileExecutingBlock:^{
                    __block CSSubscriberImportResult *subscriberImportResult = nil;
                    [cs importSubscribersToListWithID:listID subscribers:subscribersWithCustomFields shouldResubscribe:shouldResubscribe shouldQueueSubscriptionBasedAutoresponders:shouldQueueSubscriptionBasedAutoresponders shouldRestartSubscriptionBasedAutoresponders:shouldRestartSubscriptionBasedAutoresponders completionHandler:^(CSSubscriberImportResult *response) {
                        subscriberImportResult = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [subscriberImportResult shouldNotBeNil];
                    [[theValue(subscriberImportResult.totalUniqueEmailsSubmitted) should] equal:theValue(3)];
                    [[theValue(subscriberImportResult.totalExistingSubscribers) should] equal:theValue(0)];
                    [[theValue(subscriberImportResult.totalNewSubscribers) should] equal:theValue(3)];
                    [[subscriberImportResult.duplicateEmailsInSubmission should] beEmpty];
                    [[subscriberImportResult.failureDetails should] beEmpty];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"subscribers/%@/import.json", listID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                __block NSMutableArray *expectedSubscribers = [[NSMutableArray alloc] initWithCapacity:subscribers.count];
                [subscribersWithCustomFields enumerateObjectsUsingBlock:^(CSSubscriber *subscriber, NSUInteger idx, BOOL *stop) {
                    NSArray *customFieldValues = [subscriber.customFields valueForKey:@"dictionaryValue"];
                    [expectedSubscribers addObject:[CSSubscriber dictionaryWithEmailAddress:subscriber.emailAddress name:subscriber.name customFieldValues:customFieldValues]];
                }];
                
                NSDictionary *expectedPostBody = @{@"Subscribers": expectedSubscribers, @"Resubscribe": @(shouldResubscribe), @"QueueSubscriptionBasedAutoResponders": @(shouldQueueSubscriptionBasedAutoresponders), @"RestartSubscriptionBasedAutoresponders": @(shouldRestartSubscriptionBasedAutoresponders)};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"import many subscribers at once with partial success", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"import_subscribers_partial_success.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs importSubscribersToListWithID:listID subscribers:subscribers shouldResubscribe:shouldResubscribe shouldQueueSubscriptionBasedAutoresponders:shouldQueueSubscriptionBasedAutoresponders shouldRestartSubscriptionBasedAutoresponders:shouldRestartSubscriptionBasedAutoresponders completionHandler:^(CSSubscriberImportResult *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [error shouldNotBeNil];
                    [[theValue([error code]) should] equal:theValue(CSAPIErrorSubscriberImportHadSomeFailures)];
                    
                    CSSubscriberImportResult *subscriberImportResult = [[error userInfo] objectForKey:CSAPIErrorSubscriberImportResultKey];
                    [[theValue(subscriberImportResult.totalUniqueEmailsSubmitted) should] equal:theValue(3)];
                    [[theValue(subscriberImportResult.totalExistingSubscribers) should] equal:theValue(2)];
                    [[theValue(subscriberImportResult.totalNewSubscribers) should] equal:theValue(0)];
                    [[subscriberImportResult.duplicateEmailsInSubmission should] beEmpty];

                    [[subscriberImportResult.failureDetails should] have:1];
                    NSDictionary *firstFailure = [subscriberImportResult.failureDetails objectAtIndex:0];
                    [[[firstFailure valueForKey:@"EmailAddress"] should] equal:@"example+1@example"];
                    [[[firstFailure valueForKey:@"Code"] should] equal:@(1)];
                    [[[firstFailure valueForKey:@"Message"] should] equal:@"Invalid Email Address"];
                }];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs importSubscribersToListWithID:listID subscribers:subscribers shouldResubscribe:shouldResubscribe shouldQueueSubscriptionBasedAutoresponders:shouldQueueSubscriptionBasedAutoresponders shouldRestartSubscriptionBasedAutoresponders:shouldRestartSubscriptionBasedAutoresponders completionHandler:^(CSSubscriberImportResult *response) {
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
