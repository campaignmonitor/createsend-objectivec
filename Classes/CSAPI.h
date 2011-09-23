//
//  CSAPI.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"
#import "CSRestClient.h"
#import "JSONKit.h"

typedef void (^CSAPICompletionHandler)(CSAPIRequest* request);
typedef void (^CSAPIErrorHandler)(NSError* error);

@interface CSAPI : NSObject

@property (nonatomic, retain) CSRestClient* restClient;

@property (nonatomic, copy) NSString* siteURL;
@property (nonatomic, copy) NSString* APIKey;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* password;

- (id)initWithSiteURL:(NSString *)siteURL APIKey:(NSString *)APIKey;
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
