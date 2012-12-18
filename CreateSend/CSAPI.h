//
//  CSAPI.h
//  CSAPI
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSRestClient.h"
#import "CSOAuthConfig.h"

typedef void (^CSAPIErrorHandler)(NSError *error);
extern NSString * const CSAPIErrorDomain;
extern NSString * const CSAPIErrorResultDataKey;

extern NSString * const CSAPIClientScopeViewReports;
extern NSString * const CSAPIClientScopeManageLists;
extern NSString * const CSAPIClientScopeCreateCampaigns;
extern NSString * const CSAPIClientScopeImportSubscribers;
extern NSString * const CSAPIClientScopeSendCampaigns;
extern NSString * const CSAPIClientScopeViewSubscribersInReports;
extern NSString * const CSAPIClientScopeManageTemplates;
extern NSString * const CSAPIClientScopeAdministerPersons;
extern NSString * const CSAPIClientScopeAdministerAccount;

extern NSString * const CSAPICurrencyUSDollars;
extern NSString * const CSAPICurrencyGreatBritainPounds;
extern NSString * const CSAPICurrencyEuros;
extern NSString * const CSAPICurrencyCanadianDollars;
extern NSString * const CSAPICurrencyAustralianDollars;
extern NSString * const CSAPICurrencyNewZealandDollars;

enum {
    CSAPIErrorInvalidEmailAddress = 1,
    CSAPIErrorInvalidClient = 102,
    CSAPIErrorSubscriberImportHadSomeFailures = 210,
    CSAPIErrorListTitleEmpty = 251,
    CSAPIErrorInvalidKey = 253,
    CSAPIErrorFieldKeyExists = 255,
    CSAPIErrorInvalidSegmentRules = 277,
    CSAPIErrorNotFound = 404,
    CSAPIErrorInvalidWebhookURL = 601,
    CSAPIErrorWebhookRequestFailed = 610,
    CSAPIErrorEmptySegmentSubject = 2700,
    CSAPIErrorInvalidSegmentSubject = 2701,
    CSAPIErrorEmptySegmentClauses = 2702,
    CSAPIErrorInvalidSegmentClauses = 2703
};

/**
 A convenient blocks-based interface to the Campaign Monitor API. APIs are
 grouped into categories as follows:
 
 * [Accounts](CSAPI(Account))
 * [Campaigns](CSAPI(Campaigns))
 * [Lists](CSAPI(Lists))
 * [Subscribers](CSAPI(Subscribers))
 * [Clients](CSAPI(Clients))
 * [Segments](CSAPI(Segments))
 * [Templates](CSAPI(Templates))
 
 */
@interface CSAPI : NSObject
@property (strong) CSRestClient *restClient;
@property (strong) CSOAuthConfig *authConfig;
@property (copy) NSString *APIKey;
@property (readonly) BOOL isAuthorized;

@property (copy) NSURL *baseURL;
@property (readonly) NSString *userAgent;

+ (NSDateFormatter *)sharedDateFormatter;

+ (NSDictionary *)paginationParametersWithPage:(NSUInteger)page pageSize:(NSUInteger)pageSize orderField:(NSString *)orderField ascending:(BOOL)ascending;

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress;

/**
 Creates and returns a CSAPI instance for interacting with the Campaign Monitor API.
 
 @param clientID The integration client ID provided during registration.
 @param clientSecret This must be the integration secret provided during registration.
 @param scope The permission level requested by the integration.
 @return A `CSAPI` instance.
 */
- (id)initWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret scope:(NSArray *)scope;

/**
 Creates and returns a CSAPI instance for interacting with the Campaign Monitor API.
 
 @param APIKey The APIKey used for authentication.
 @return A `CSAPI` instance.
 */
- (id)initWithAPIKey:(NSString *)APIKey;

- (void)logout;
@end

#import "CSAPI+OAuth.h"
#import "CSAPI+Account.h"
#import "CSAPI+Campaigns.h"
#import "CSAPI+Clients.h"
#import "CSAPI+Lists.h"
#import "CSAPI+Segments.h"
#import "CSAPI+Subscribers.h"
#import "CSAPI+Templates.h"

#if TARGET_OS_IPHONE
#import "CSAPI+iOS.h"
#endif
