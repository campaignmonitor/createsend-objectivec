//
//  CSOAuthConfig.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSOAuthConfig : NSObject
@property (copy) NSString *clientID;
@property (copy) NSString *clientSecret;
@property (strong) NSArray *scope;
@property (strong) NSURL *redirectURL;
@property (strong) NSURL *tokenURL;

@property (copy) NSString *accessToken;
@property (strong) NSDate *accessTokenExpiresAt;
@property (copy) NSString *refreshToken;

@property (readonly) BOOL isAuthorized;
@property (readonly) BOOL isAccessTokenExpired;

- (id)initWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret scope:(NSArray *)scope;

- (void)deleteConfig;
@end
