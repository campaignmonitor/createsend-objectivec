//
//  CSAPI+Accounts.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"

@interface CSAPI (Accounts)

- (void)getAPIKey:(void (^)(NSString* APIKey))completionHandler
     errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getCountries:(void (^)(NSArray* countries))completionHandler
        errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getTimezones:(void (^)(NSArray* timezones))completionHandler
        errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getSystemDate:(void (^)(NSDate* systemDate))completionHandler
         errorHandler:(CSAPIErrorHandler)errorHandler;

@end
