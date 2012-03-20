//
//  CSAPI.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSRestClient.h"
#import "JSONKit.h"

typedef void (^CSAPIErrorHandler)(NSError* error);

/**
 Convenient blocks-based interface to the Campaign Monitor API.
 */
@interface CSAPI : NSObject

@property (nonatomic, retain) CSRestClient* restClient;

@property (nonatomic, copy) NSString* siteURL;
@property (nonatomic, copy) NSString* APIKey;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* password;

/**
 Creates and returns a CSAPI instance for interacting with the Campaign Monitor API.

 @param siteURL The site URL for your Campaign Monitor account. e.g. `@"http://myaccountname.createsend.com/"`

 @param APIKey The API key/token for your Campaign Monitor account.

 @return A `CSAPI` instance.
 */
- (id)initWithSiteURL:(NSString *)siteURL APIKey:(NSString *)APIKey;

/**
 Creates and returns a CSAPI instance, however it's only really useful if you
 don't have access to your API key and would like to request it via the API.

 @param siteURL The site URL for your Campaign Monitor account. e.g. `@"http://myaccountname.createsend.com/"`
 @param username Your Campaign Monitor account username.
 @param password Your Campaign Monitor account password.

 @return A CSAPI instance.

 @see getAPIKey:errorHandler:
 */
- (id)initWithSiteURL:(NSString *)siteURL username:(NSString *)username password:(NSString *)password;

+ (NSDateFormatter *)sharedDateFormatter;

+ (NSDictionary *)paginationParametersWithPage:(NSUInteger)page
                                      pageSize:(NSUInteger)pageSize
                                    orderField:(NSString *)orderField
                                     ascending:(BOOL)ascending;

@end

#import "CSAPI+Accounts.h"
#import "CSAPI+Campaigns.h"
#import "CSAPI+Lists.h"
#import "CSAPI+Subscribers.h"
#import "CSAPI+Clients.h"
#import "CSAPI+Segments.h"
#import "CSAPI+Templates.h"
