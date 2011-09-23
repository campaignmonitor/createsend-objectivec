//
//  CSRestClient.h
//  CreateSend
//
//  Created by Nathan de Vries on 22/09/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "AFRestClient.h"

@interface AFRestClient()

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters;

@end


@interface CSRestClient : AFRestClient

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
      bodyObject:(id)bodyObject
         success:(void (^)(id response))success
         failure:(void (^)(NSError *error))failure;

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
     bodyObject:(id)bodyObject
        success:(void (^)(id response))success
        failure:(void (^)(NSError *error))failure;

@end
