//
//  CSRestClient.m
//  CreateSend
//
//  Created by Nathan de Vries on 22/09/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSRestClient.h"
#import "CSJSONRequestOperation.h"
#import "JSONKit.h"
@implementation CSRestClient

- (void)enqueueHTTPOperationWithRequest:(NSURLRequest *)request
                                success:(void (^)(id response))success
                                failure:(void (^)(NSError *error))failure {
  
  if ([request URL] == nil || [[request URL] isEqual:[NSNull null]]) {
    return;
  }
  
  AFHTTPRequestOperation *operation = [CSJSONRequestOperation operationWithRequest:request
                                                                           success:success
                                                                           failure:failure];
  [self enqueueHTTPOperation:operation];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
      bodyObject:(id)bodyObject
         success:(void (^)(id response))success
         failure:(void (^)(NSError *error))failure {
  
  NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
  [request setHTTPBody:[(NSDictionary *)bodyObject JSONData]];
  [self enqueueHTTPOperationWithRequest:request success:success failure:failure];
}

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
     bodyObject:(id)bodyObject
        success:(void (^)(id response))success
        failure:(void (^)(NSError *error))failure {
  
  NSMutableURLRequest *request = [self requestWithMethod:@"PUT" path:path parameters:parameters];
  [request setHTTPBody:[(NSDictionary *)bodyObject JSONData]];
  [self enqueueHTTPOperationWithRequest:request success:success failure:failure];
}

@end
