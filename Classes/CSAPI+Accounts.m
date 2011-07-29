//
//  CSAPI+Accounts.m
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI+Accounts.h"

@implementation CSAPI (Accounts)

- (void)getAPIKey:(void (^)(NSString* APIKey))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler {
  NSDictionary* queryParameters = [NSDictionary dictionaryWithObject:self.siteURL forKey:@"siteurl"];
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPISlug:@"apikey"
                                                   queryParameters:queryParameters];
  
  request.username = self.username;
  request.password = self.password;
  
  [request setCompletionBlock:^{
    completionHandler([request.parsedResponse valueForKey:@"ApiKey"]);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getCountries:(void (^)(NSArray* countries))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler {
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey slug:@"countries"];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getTimezones:(void (^)(NSArray* timezones))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler {
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey slug:@"timezones"];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getSystemDate:(void (^)(NSDate* systemDate))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler {
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey slug:@"systemdate"];
  
  [request setCompletionBlock:^{
    NSDateFormatter* formatter = [CSAPIRequest sharedDateFormatter];
    NSDate* systemDate = [formatter dateFromString:[request.parsedResponse valueForKey:@"SystemDate"]];
    completionHandler(systemDate);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

@end
