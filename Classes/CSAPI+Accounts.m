//
//  CSAPI+Accounts.m
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI+Accounts.h"

@implementation CSAPI (Accounts)

- (void)getAPIKey:(void (^)(NSString* APIKey))completionHandler
     errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSDictionary* queryParameters = [NSDictionary dictionaryWithObject:self.siteURL
                                                              forKey:@"siteurl"];
  
  [self.restClient getPath:@"apikey.json"
                parameters:queryParameters
                   success:^(id response) {
                     completionHandler([response valueForKey:@"ApiKey"]);
                   }
                   failure:errorHandler];
}

- (void)getCountries:(void (^)(NSArray* countries))completionHandler
        errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:@"countries.json"
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)getTimezones:(void (^)(NSArray* timezones))completionHandler
        errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:@"timezones.json"
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)getSystemDate:(void (^)(NSDate* systemDate))completionHandler
         errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:@"systemdate.json"
                parameters:nil
                   success:^(id response) {
                     NSDateFormatter* formatter = [CSAPI sharedDateFormatter];
                     NSDate* systemDate = [formatter dateFromString:[response valueForKey:@"SystemDate"]];
                     completionHandler(systemDate);
                   }
                   failure:errorHandler];
}

@end
