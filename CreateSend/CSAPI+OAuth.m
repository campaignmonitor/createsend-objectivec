//
//  CSAPI+Authorization.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSAPI+OAuth.h"
#import "CSSSKeychain.h"
#import "NSString+URLEncoding.h"
#import "NSURL+CSAPI.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

NSString * const CSAPIDidReceiveAuthorizationNotification = @"CSAPIDidReceiveAuthorization";
NSString * const CSAPIDidCancelAuthorizationNotification = @"CSAPIDidCancelAuthorization";

#define kServiceName [NSString stringWithFormat:@"%@.campaignmonitor.auth", [[NSBundle mainBundle] bundleIdentifier]]

@implementation CSAPI (OAuth)
@dynamic appScheme;
@dynamic authorizationURL;

- (NSString *)appScheme
{
    return [NSString stringWithFormat:@"csapi%@", self.authConfig.clientID];
}

- (NSURL *)authorizationURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://api.createsend.com/oauth?type=web_server&client_id=%@&redirect_uri=%@&scope=%@", self.authConfig.clientID, [self.authConfig.redirectURL.absoluteString cs_urlEncodedString], [self.authConfig.scope componentsJoinedByString:@","]]];
}

- (BOOL)appConformsToScheme
{
    NSString *appScheme = self.appScheme;
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSArray *urlTypes = [info objectForKey:@"CFBundleURLTypes"];
    for (NSDictionary *urlType in urlTypes) {
        NSArray *schemes = [urlType objectForKey:@"CFBundleURLSchemes"];
        for (NSString *scheme in schemes) {
            if ([scheme isEqual:appScheme]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)canOpenURL:(NSURL *)url
{
    if (![[url scheme] isEqualToString:self.appScheme]) {
        return NO;
    }
    
    NSString *methodName = [url host];
    if ([methodName isEqualToString:@"authorize"]) {
        return YES;
    }
    
    return NO;
}

- (void)authorize
{
    if (![self appConformsToScheme]) {
        NSLog(@"CSAPI: Unable to authorize; app isn't registered for correct URL scheme (%@)", self.appScheme);
        return;
    }
    
#if TARGET_OS_IPHONE
    [[UIApplication sharedApplication] openURL:self.authorizationURL];
#endif
}

- (void)updateConfigWithAuthorizationInfo:(NSDictionary *)authorizationInfo
{
    self.authConfig.accessToken = [authorizationInfo objectForKey:@"access_token"];
    self.authConfig.refreshToken = [authorizationInfo objectForKey:@"refresh_token"];
    self.authConfig.accessTokenExpiresAt = [NSDate dateWithTimeIntervalSinceNow:[[authorizationInfo objectForKey:@"expires_in"] integerValue]];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    if (![self canOpenURL:url]) return NO;
    
    NSString *methodName = [url host];
    if ([methodName isEqualToString:@"authorize"]) {
        NSString *code = [url cs_queryValueForKey:@"code"];
        if (code) {
            __weak CSAPI *blockSelf = self;
            [self getAuthorizationInfoWithCode:code completionHandler:^(NSDictionary *authorizationInfo) {
                CSAPI *strongSelf = blockSelf; if (!strongSelf) return;
                [strongSelf updateConfigWithAuthorizationInfo:authorizationInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:CSAPIDidReceiveAuthorizationNotification object:strongSelf];
            } errorHandler:^(NSError *error) {
            }];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:CSAPIDidCancelAuthorizationNotification object:self];
        }
    }
    
    return YES;
}

- (void)getAuthorizationInfoWithParameters:(NSDictionary *)parameters completionHandler:(void (^)(NSDictionary *authorizationInfo))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.authConfig.tokenURL];
    if (self.userAgent) [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];

    NSMutableArray *queryParameters = [[NSMutableArray alloc] init];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [queryParameters addObject:[NSString stringWithFormat:@"%@=%@", [key cs_urlEncodedString], [value cs_urlEncodedString]]];
    }];
    NSData *postBody = [[queryParameters componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
	
    [request setHTTPBody:postBody];
	[request setHTTPMethod:@"POST"];
	[request setHTTPShouldHandleCookies:NO];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data) {
            NSDictionary *authorizationInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (completionHandler) completionHandler(authorizationInfo);
            return;
        } else if (error && errorHandler) {
            errorHandler(error);
        }
    }];
}

- (void)getAuthorizationInfoWithCode:(NSString *)code completionHandler:(void (^)(NSDictionary *authorizationInfo))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{@"grant_type": @"authorization_code", @"client_id": self.authConfig.clientID, @"client_secret": self.authConfig.clientSecret, @"code": code, @"redirect_uri": self.authConfig.redirectURL.absoluteString};
    [self getAuthorizationInfoWithParameters:parameters completionHandler:completionHandler errorHandler:errorHandler];
}

- (void)refreshAuthorizationInfo:(void (^)(NSDictionary *authorizationInfo))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{@"grant_type": @"refresh_token", @"refresh_token": self.authConfig.refreshToken};
    [self getAuthorizationInfoWithParameters:parameters completionHandler:completionHandler errorHandler:errorHandler];
}

- (NSString *)OAuthAuthorizationHeader
{
    return [NSString stringWithFormat:@"Bearer %@", self.authConfig.accessToken];
}

- (void)getOAuthAuthorizationHeader:(void (^)(NSString *authorizationHeader))handler
{
    if (!handler) return;
    
    if (self.isAuthorized && !self.authConfig.isAccessTokenExpired) {
        handler([self OAuthAuthorizationHeader]);
    } else if (self.authConfig.isAccessTokenExpired && self.authConfig.refreshToken) {
        __weak CSAPI *blockSelf = self;
        [self refreshAuthorizationInfo:^(NSDictionary *authorizationInfo) {
            CSAPI *strongSelf = blockSelf; if (!strongSelf) return;
            [strongSelf updateConfigWithAuthorizationInfo:authorizationInfo];
            handler([strongSelf OAuthAuthorizationHeader]);
        } errorHandler:^(NSError *error) {
            handler(nil);
        }];
    } else {
        handler(nil);
    }
}

@end
