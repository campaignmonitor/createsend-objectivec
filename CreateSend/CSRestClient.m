//
//  CSRestClient.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSRestClient.h"
#import "NSData+Base64.h"
#import "NSString+URLEncoding.h"

struct {
    unsigned int userAgent:1;
    unsigned int getAuthorizationHeader:1;
} kDelegateFlags;

@interface CSRestClient ()

@end

@interface CSRestClient (Private)
- (NSString *)delegateUserAgent;
- (void)getAuthorizationHeader:(void (^)(NSString *authorizationHeader))handler;
@end

@implementation CSRestClient
@synthesize delegate = _delegate;

- (id)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        _baseURL = baseURL;
    }
    return self;
}

- (id <CSRestClientDelegate>)delegate
{
    @synchronized(self) {
        return _delegate;
    }
}

- (void)setDelegate:(id<CSRestClientDelegate>)delegate
{
    @synchronized(self) {
        if (_delegate != delegate) {
            _delegate = delegate;
            
            kDelegateFlags.userAgent = [delegate respondsToSelector:@selector(userAgent)];
            kDelegateFlags.getAuthorizationHeader = [delegate respondsToSelector:@selector(getAuthorizationHeader:)];
        }
    }
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers
{
    NSURL *url = [NSURL URLWithString:path relativeToURL:[self baseURL]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *headerFields = [[NSMutableDictionary alloc] init];
    NSString *userAgent = [self delegateUserAgent];
    if (userAgent) [headerFields setValue:userAgent forKey:@"User-Agent"];
    [headerFields addEntriesFromDictionary:headers];
    
    if (parameters) {
        if ([method isEqualToString:@"GET"]) {
            NSMutableArray *mutableParameterComponents = [NSMutableArray array];
            for (id key in [parameters allKeys]) {
                NSString *component = [NSString stringWithFormat:@"%@=%@", [[key description] cs_urlEncodedString], [[[parameters valueForKey:key] description] cs_urlEncodedString]];
                [mutableParameterComponents addObject:component];
            }
            NSString *queryString = [mutableParameterComponents componentsJoinedByString:@"&"];
            
            url = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:[path rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@", queryString]];
        } else {
            NSData *postBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
            [request setHTTPBody:postBody];
        }
    }
    
	[request setURL:url];
	[request setHTTPMethod:method];
	[request setHTTPShouldHandleCookies:NO];
	[request setAllHTTPHeaderFields:headerFields];
    
    return request;
}

- (void)sendAsynchronousRequest:(NSURLRequest *)request success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data) {
            NSString *stringResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([stringResult hasPrefix:@"\""]) {
                if (success) success([stringResult substringWithRange:NSMakeRange(1, [stringResult length] - 2)]);
                return;
            } else {
                id jsonResult = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if ([jsonResult isKindOfClass:[NSDictionary class]]) {
                    NSNumber *code = [jsonResult objectForKey:@"Code"];
                    NSString *message = [jsonResult objectForKey:@"Message"];
                    if (code && message) {
                        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:@{NSLocalizedDescriptionKey: message}];
                        NSDictionary *resultData = [jsonResult objectForKey:@"ResultData"];
                        if (resultData) [userInfo setObject:resultData forKey:CSAPIErrorResultDataKey];

                        error = [[NSError alloc] initWithDomain:CSAPIErrorDomain code:[code integerValue] userInfo:[[NSDictionary alloc] initWithDictionary:userInfo]];
                    }
                }
                
                if (!error) {
                    if (success) success(jsonResult);
                    return;
                }
            }
        }
        
        if (error && failure) {
            failure(error);
        }
    }];
}

- (void)sendAsynchronousRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    __weak CSRestClient *blockSelf = self;
    [self getAuthorizationHeader:^(NSString *authorizationHeader) {
        CSRestClient *strongSelf = blockSelf; if (!strongSelf) return;
        
        NSMutableURLRequest *request = [strongSelf requestWithMethod:method path:path parameters:parameters headers:headers];
        if (authorizationHeader) [request setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
        
        [strongSelf sendAsynchronousRequest:request success:success failure:failure];
    }];
}

- (void)get:(NSString *)path withParameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    [self sendAsynchronousRequestWithMethod:@"GET" path:path parameters:parameters headers:nil success:success failure:failure];
}

- (void)get:(NSString *)path success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    [self get:path withParameters:nil success:success failure:failure];
}

- (void)post:(NSString *)path withParameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    [self sendAsynchronousRequestWithMethod:@"POST" path:path parameters:parameters headers:nil success:success failure:failure];
}

- (void)put:(NSString *)path withParameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    [self sendAsynchronousRequestWithMethod:@"PUT" path:path parameters:parameters headers:nil success:success failure:failure];
}

- (void)delete:(NSString *)path withParameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    [self sendAsynchronousRequestWithMethod:@"DELETE" path:path parameters:parameters headers:nil success:success failure:failure];
}
@end

@implementation CSRestClient (Private)
#pragma mark - Delegate Methods
- (NSString *)delegateUserAgent
{
    if (kDelegateFlags.userAgent) {
        return [self.delegate userAgent];
    }
    return nil;
}

- (void)getAuthorizationHeader:(void (^)(NSString *authorizationHeader))handler
{
    if (!handler) return;
    
    if (kDelegateFlags.getAuthorizationHeader) {
        [self.delegate getAuthorizationHeader:handler];
    } else {
        handler(nil);
    }
}
@end
