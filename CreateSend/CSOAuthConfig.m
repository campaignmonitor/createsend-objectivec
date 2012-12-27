//
//  CSOAuthConfig.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSOAuthConfig.h"
#import "CSSSKeychain.h"

#define kServiceName [NSString stringWithFormat:@"%@.campaignmonitor.auth", [[NSBundle mainBundle] bundleIdentifier]]
#define kKeychainAccessTokenService [kServiceName stringByAppendingString:@".accessToken"]
#define kKeychainRefreshTokenService [kServiceName stringByAppendingString:@".refreshToken"]

static NSString *kExpiresAtKey = @"CSOAuthExpiresAtKey";

@implementation CSOAuthConfig
@synthesize accessToken = _accessToken;
@synthesize refreshToken = _refreshToken;
@synthesize accessTokenExpiresAt = _accessTokenExpiresAt;
@dynamic isAuthorized;
@dynamic isAccessTokenExpired;

- (id)initWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret scope:(NSArray *)scope
{
    self = [super init];
    if (self) {
        _clientID = clientID;
        _clientSecret = clientSecret;
        _scope = scope;
        _accessTokenExpiresAt = [[NSUserDefaults standardUserDefaults] objectForKey:kExpiresAtKey];
        
        if (_accessTokenExpiresAt) {
			_accessToken = [CSSSKeychain passwordForService:kKeychainAccessTokenService account:_clientID];
			_refreshToken = [CSSSKeychain passwordForService:kKeychainRefreshTokenService account:_clientID];
		}
    }
    return self;
}

- (NSString *)accessToken
{
    @synchronized(self) {
        return _accessToken;
    }
}

- (void)setAccessToken:(NSString *)accessToken
{
    @synchronized(self) {
        _accessToken = accessToken;
        
        if (_accessToken) {
            [CSSSKeychain setPassword:_accessToken forService:kKeychainAccessTokenService account:self.clientID];
        } else {
            [CSSSKeychain deletePasswordForService:kKeychainAccessTokenService account:self.clientID];
        }
    }
}

- (NSString *)refreshToken
{
    @synchronized(self) {
        return _refreshToken;
    }
}

- (void)setRefreshToken:(NSString *)refreshToken
{
    @synchronized(self) {
        _refreshToken = refreshToken;
        
        if (_refreshToken) {
            [CSSSKeychain setPassword:_refreshToken forService:kKeychainRefreshTokenService account:self.clientID];
        } else {
            [CSSSKeychain deletePasswordForService:kKeychainRefreshTokenService account:self.clientID];
        }
    }
}

- (NSDate *)accessTokenExpiresAt
{
    @synchronized(self) {
        return _accessTokenExpiresAt;
    }
}

- (void)setAccessTokenExpiresAt:(NSDate *)accessTokenExpiresAt
{
    @synchronized(self) {
        _accessTokenExpiresAt = accessTokenExpiresAt;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (_accessTokenExpiresAt) {
            [defaults setObject:_accessTokenExpiresAt forKey:kExpiresAtKey];
        } else {
            [defaults removeObjectForKey:kExpiresAtKey];
        }
        [defaults synchronize];
    }
}

- (BOOL)isAuthorized
{
	return self.accessToken != nil;
}

- (BOOL)isAccessTokenExpired
{
    return [self.accessTokenExpiresAt compare:[NSDate date]] != NSOrderedDescending;
}

- (void)deleteConfig
{
	self.accessToken = nil;
	self.accessTokenExpiresAt = nil;
	self.refreshToken = nil;
}

@end
