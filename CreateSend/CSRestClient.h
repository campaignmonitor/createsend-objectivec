//
//  CSRestClient.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSRestClientDelegate;

@interface CSRestClient : NSObject
@property (weak) id <CSRestClientDelegate> delegate;
@property (strong) NSURL *baseURL;

- (id)initWithBaseURL:(NSURL *)url;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers;
- (void)sendAsynchronousRequest:(NSURLRequest *)request success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
- (void)sendAsynchronousRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

- (void)get:(NSString *)path withParameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
- (void)get:(NSString *)path success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

- (void)post:(NSString *)path withParameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
- (void)put:(NSString *)path withParameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
- (void)delete:(NSString *)path withParameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
@end

@protocol CSRestClientDelegate <NSObject>
@optional
- (NSString *)userAgent;
- (void)getAuthorizationHeader:(void (^)(NSString *authorizationHeader))handler;
@end
