//
//  CSAPI.m
//  CSAPI
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSAPI.h"
#import "NSData+Base64.h"

NSString * const CSAPIErrorDomain = @"com.createsend.api.error";
NSString * const CSAPIErrorResultDataKey = @"CSAPIErrorResultDataKey";

NSString * const CSAPIClientScopeViewReports = @"ViewReports";
NSString * const CSAPIClientScopeManageLists = @"ManageLists";
NSString * const CSAPIClientScopeCreateCampaigns = @"CreateCampaigns";
NSString * const CSAPIClientScopeImportSubscribers = @"ImportSubscribers";
NSString * const CSAPIClientScopeSendCampaigns = @"SendCampaigns";
NSString * const CSAPIClientScopeViewSubscribersInReports = @"ViewSubscribersInReports";
NSString * const CSAPIClientScopeManageTemplates = @"ManageTemplates";
NSString * const CSAPIClientScopeAdministerPersons = @"AdministerPersons";
NSString * const CSAPIClientScopeAdministerAccount = @"AdministerAccount";

NSString * const CSAPICurrencyUSDollars = @"USD";
NSString * const CSAPICurrencyGreatBritainPounds = @"GBP";
NSString * const CSAPICurrencyEuros = @"EUR";
NSString * const CSAPICurrencyCanadianDollars = @"CAD";
NSString * const CSAPICurrencyAustralianDollars = @"AUD";
NSString * const CSAPICurrencyNewZealandDollars = @"NZD";

@interface CSAPI () <CSRestClientDelegate>

@end

@implementation CSAPI
@synthesize baseURL;
@dynamic userAgent;
@dynamic isAuthorized;

+ (NSDateFormatter *)sharedDateFormatter
{
    static dispatch_once_t pred;
    static NSDateFormatter *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [shared setLocale:locale];
        [shared setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    return shared;
}

+ (NSDictionary *)paginationParametersWithPage:(NSUInteger)page pageSize:(NSUInteger)pageSize orderField:(NSString *)orderField ascending:(BOOL)ascending
{
    return @{
        @"page": [NSString stringWithFormat:@"%d", page],
        @"pagesize": [NSString stringWithFormat:@"%d", pageSize],
        @"orderfield": orderField,
        @"orderdirection": (ascending ? @"asc" : @"desc")
    };
}

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress
{
    static NSString * kCampaignMonitorEmailRegexPattern = @"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Z0-9-_]+\\.)+[A-Z]{2,6}$";
    if (!emailAddress || emailAddress.length < 3) return NO;
    
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", kCampaignMonitorEmailRegexPattern];
    return [regexPredicate evaluateWithObject:emailAddress];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.baseURL = [NSURL URLWithString:@"https://api.createsend.com/api/v3/"];
        _restClient = [[CSRestClient alloc] initWithBaseURL:self.baseURL];
        _restClient.delegate = self;
    }
    return self;
}

- (id)initWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret scope:(NSArray *)scope
{
    self = [self init];
    if (self) {
        _authConfig = [[CSOAuthConfig alloc] initWithClientID:clientID clientSecret:clientSecret scope:scope];
		_authConfig.redirectURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://authorize", self.appScheme]];
		_authConfig.tokenURL = [NSURL URLWithString:@"https://api.createsend.com/oauth/token"];
    }
    return self;
}

- (id)initWithAPIKey:(NSString *)APIKey
{
    self = [self init];
    if (self) {
        _APIKey = APIKey;
    }
    return self;
}

- (NSString *)userAgent
{
    return [NSString stringWithFormat:@"createsend-objc-%@", CSCreateSendVersion];
}

- (BOOL)isAuthorized
{
    return (self.APIKey || self.authConfig.isAuthorized);
}

- (void)getAuthorizationHeader:(void (^)(NSString *authorizationHeader))handler
{
    if (!handler) return;
    
    if (self.APIKey) {
        NSString *authorizationString = [NSString stringWithFormat:@"%@:magic", self.APIKey];
        NSData *authorizationData = [authorizationString dataUsingEncoding:NSUTF8StringEncoding];
        handler([NSString stringWithFormat:@"Basic %@", [authorizationData cs_base64EncodedString]]);
    } else {
        [self getOAuthAuthorizationHeader:handler];
    }
}

- (void)logout
{
    self.APIKey = nil;
    [self.authConfig deleteConfig];
}
@end
