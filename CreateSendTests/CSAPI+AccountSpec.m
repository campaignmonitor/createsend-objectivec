#import "CSSpecHelper.h"
#import "CSAPI.h"
#import "CSClient.h"

SPEC_BEGIN(CSAPIAccountSpec)

describe(@"CSAPI+Account", ^{
    registerMatchers(@"OV");
    
    context(@"when an api caller is authenticated", ^{
        __block CSAPI *cs = nil;
        
        beforeEach(^{
            cs = [[CSAPI alloc] init];
        });
        
        context(@"get api key", ^{
            NSString *username = @"myusername";
            NSString *password = @"mypassword";
            NSString *siteURL = @"http://iamadesigner.createsend.com/";
            
            it (@"should get the api key", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"apikey.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSString *APIKey = nil;
                    [cs getAPIKeyWithSiteURL:siteURL username:username password:password completionHandler:^(NSString *response) {
                        APIKey = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [[APIKey should] equal:@"981298u298ue98u219e8u2e98u2"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:@"apikey.json?siteurl=http%3A%2F%2Fiamadesigner.createsend.com%2F" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getAPIKeyWithSiteURL:siteURL username:username password:password completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get all clients", ^{
            it(@"should get all clients", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"clients.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *clients = nil;
                    [cs getClients:^(NSArray *response) {
                        clients = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [[[clients should] have:2] items];
                    
                    CSClient *firstClient = [clients objectAtIndex:0];
                    [[firstClient.clientID should] equal:@"4a397ccaaa55eb4e6aa1221e1e2d7122"];
                    [[firstClient.name should] equal:@"Client One"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:@"clients.json" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getClients:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidClient message:CSAPIErrorInvalidClientMessage];
                }];
            });
        });

        context(@"get billing details", ^{
            it(@"should get all clients", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"billingdetails.json" returningRequest:&request whileExecutingBlock:^{
                    __block CSBillingDetails *billingDetails = nil;
                    [cs getBillingDetails:^(CSBillingDetails *response) {
                        billingDetails = response;
                    } errorHandler:^(NSError *error) {
                        [error shouldBeNil];
                    }];

                    [[theValue(billingDetails.credits) should] equal:theValue(3021)];
                }];

                NSURL *expectedURL = [NSURL URLWithString:@"billingdetails.json" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getBillingDetails:^(CSBillingDetails *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });

        context(@"get all countries", ^{
            it(@"should get all countries", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"countries.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *countries = nil;
                    [cs getCountries:^(NSArray *response) {
                        countries = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [[[countries should] have:245] items];
                    [[countries should] contain:@"Australia"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:@"countries.json" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getCountries:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get all timezones", ^{
            it(@"should get all timezones", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"timezones.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSArray *timezones = nil;
                    [cs getTimezones:^(NSArray *response) {
                        timezones = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [[[timezones should] have:97] items];
                    [[timezones should] contain:@"(GMT+12:00) Fiji"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:@"timezones.json" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
                        
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getTimezones:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get system date", ^{
            it(@"should get system date", ^{
                NSURLRequest *request = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"systemdate.json" returningRequest:&request whileExecutingBlock:^{
                    __block NSDate *systemDate = nil;
                    [cs getSystemDate:^(NSDate *response) {
                        systemDate = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                    
                    [[[[CSAPI sharedDateFormatter] stringFromDate:systemDate] should] equal:@"2010-10-15 09:27:00"];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:@"systemdate.json" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getSystemDate:^(NSDate *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"add an administrator", ^{
            NSString *name = @"Admin";
            NSString *emailAddress = @"admin@example.com";
            
            it(@"should add an administrator", ^{
                NSURLRequest *request = nil;
                __block NSString *administratorEmailAddress = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"add_admin.json" returningRequest:&request whileExecutingBlock:^{
                    [cs addAdministratorWithName:name emailAddress:emailAddress completionHandler:^(NSString *response) {
                        administratorEmailAddress = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[administratorEmailAddress should] equal:emailAddress];
                
                NSURL *expectedURL = [NSURL URLWithString:@"admins.json" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"Name": name, @"EmailAddress": emailAddress};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs addAdministratorWithName:name emailAddress:emailAddress completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage];
                }];
            });
        });
        
        context(@"update an administrator", ^{
            NSString *name = @"Admin";
            NSString *emailAddress = @"admin@example.com";
            NSString *newEmailAddress = @"new_email_address@example.com";
            
            it(@"should update an administrator", ^{
                NSURLRequest *request = nil;
                __block NSString *administratorEmailAddress = nil;
                [NSURLConnection stubSendAsynchronousRequestAndExecuteCompletionHandlerWithDataFromDictionary:@{@"EmailAddress": newEmailAddress} returningRequest:&request whileExecutingBlock:^{
                    [cs updateAdministratorWithEmailAddress:emailAddress name:name newEmailAddress:newEmailAddress completionHandler:^(NSString *response) {
                        administratorEmailAddress = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[administratorEmailAddress should] equal:newEmailAddress];
                
                NSURL *expectedURL = [NSURL URLWithString:@"admins.json?email=admin%40example.com" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
                
                NSDictionary *expectedPostBody = @{@"Name": name, @"EmailAddress": newEmailAddress};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs updateAdministratorWithEmailAddress:emailAddress name:name newEmailAddress:newEmailAddress completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage];
                }];
            });
        });
        
        context(@"delete an administrator", ^{
            NSString *emailAddress = @"admin@example.com";
            
            it(@"should delete an administrator", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^ {
                    [cs deleteAdministratorWithEmailAddress:emailAddress completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:@"admins.json?email=admin%40example.com" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"DELETE"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs deleteAdministratorWithEmailAddress:emailAddress completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage];
                }];
            });
        });
        
        context(@"get an administrator by email address", ^{
            NSString *emailAddress = @"admin@example.com";
            
            it(@"should get an administrator by email address", ^{
                NSURLRequest *request = nil;
                __block CSAdministrator *administrator = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"admin_details.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getAdministratorWithEmailAddress:emailAddress completionHandler:^(CSAdministrator *response) {
                        administrator = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[administrator.name should] equal:@"Admin One"];
                [[administrator.emailAddress should] equal:emailAddress];
                [[administrator.status should] equal:@"Active"];
                
                NSURL *expectedURL = [NSURL URLWithString:@"admins.json?email=admin%40example.com" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getAdministratorWithEmailAddress:emailAddress completionHandler:^(CSAdministrator *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get all administrators", ^{
            it(@"should get all administrators", ^{
                NSURLRequest *request = nil;
                __block NSArray *administrators = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"administrators.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getAdministrators:^(NSArray *response) {
                        administrators = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[[administrators should] have: 2] items];
                CSAdministrator *firstAdministrator = [administrators objectAtIndex:0];
                [[firstAdministrator.name should] equal:@"Admin One"];
                [[firstAdministrator.emailAddress should] equal:@"admin1@blackhole.com"];
                [[firstAdministrator.status should] equal:@"Active"];
                
                NSURL *expectedURL = [NSURL URLWithString:@"admins.json" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getAdministrators:^(NSArray *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"set primary contact", ^{
            NSString *emailAddress = @"admin@blackhole.com";
            
            it(@"should set primary contact", ^{
                NSURLRequest *request = nil;
                __block NSString *primaryContactEmailAddress = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"admin_set_primary_contact.json" returningRequest:&request whileExecutingBlock:^{
                    [cs setPrimaryContactWithEmailAddress:emailAddress completionHandler:^(NSString *response) {
                        primaryContactEmailAddress = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[primaryContactEmailAddress should] equal:emailAddress];
                
                NSURL *expectedURL = [NSURL URLWithString:@"primarycontact.json?email=admin%40blackhole.com" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorInvalidEmailAddress message:CSAPIErrorInvalidEmailAddressMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs setPrimaryContactWithEmailAddress:emailAddress completionHandler:^(NSString *response) {
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
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"admin_get_primary_contact.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getPrimaryContact:^(NSString *response) {
                        primaryContactEmailAddress = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[primaryContactEmailAddress should] equal:@"admin@blackhole.com"];
                
                NSURL *expectedURL = [NSURL URLWithString:@"primarycontact.json" relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getPrimaryContact:^(NSString *response) {
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