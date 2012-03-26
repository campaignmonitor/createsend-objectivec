//
//  CSAPI+Accounts.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"

/**
 Account-related APIs. See CSAPI for documentation of the other API categories.
 */
@interface CSAPI (Accounts)

/**
 Get the API key/token for your account.
 
     http://www.campaignmonitor.com/api/account/#getting_your_api_key

 @param completionHandler Completion callback, including the API key
 @param errorHandler Error callback
 */
- (void)getAPIKey:(void (^)(NSString* APIKey))completionHandler
     errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of valid countries.

     http://www.campaignmonitor.com/api/account/#getting_countries

 @param completionHandler Completion callback, including a list of country names as an `NSArray`
 @param errorHandler Error callback
 @see [CSAPI(Clients) createClientWithCompanyName:contactName:emailAddress:country:timezone:completionHandler:errorHandler:]
 */
- (void)getCountries:(void (^)(NSArray* countries))completionHandler
        errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of valid timezones.

     http://www.campaignmonitor.com/api/account/#getting_timezones

 @param completionHandler Completion callback, including a list of timezone names as an `NSArray`
 @param errorHandler Error callback
 @see [CSAPI(Clients) createClientWithCompanyName:contactName:emailAddress:country:timezone:completionHandler:errorHandler:]
 */
- (void)getTimezones:(void (^)(NSArray* timezones))completionHandler
        errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get the current time.

     http://www.campaignmonitor.com/api/account/#getting_systemdate

 @param completionHandler Completion callback, including the current time as an `NSDate`
 @param errorHandler Error callback
 @see [CSAPI(Clients) createClientWithCompanyName:contactName:emailAddress:country:timezone:completionHandler:errorHandler:]
 */
- (void)getSystemDate:(void (^)(NSDate* systemDate))completionHandler
         errorHandler:(CSAPIErrorHandler)errorHandler;

@end
