//
//  CSAPI+OAuth.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSAPI.h"

extern NSString * const CSAPIDidReceiveAuthorizationNotification;
extern NSString * const CSAPIDidCancelAuthorizationNotification;

/**
 Authorization-related APIs. See CSAPI for documentation of the other API categories.
 */
@interface CSAPI (OAuth)
@property (readonly) NSString *appScheme;
@property (readonly) NSURL *authorizationURL;

- (BOOL)appConformsToScheme;

- (BOOL)canOpenURL:(NSURL *)url;
- (BOOL)handleOpenURL:(NSURL *)url;

- (void)authorize;

- (void)getAuthorizationInfoWithParameters:(NSDictionary *)parameters completionHandler:(void (^)(NSDictionary *authorizationInfo))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;
- (void)getAuthorizationInfoWithCode:(NSString *)code completionHandler:(void (^)(NSDictionary *authorizationInfo))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;
- (void)refreshAuthorizationInfo:(void (^)(NSDictionary *authorizationInfo))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getOAuthAuthorizationHeader:(void (^)(NSString *authorizationHeader))handler;
@end
