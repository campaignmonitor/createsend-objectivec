//
//  CSJSONRequestOperation.m
//  CreateSend
//
//  Created by Nathan de Vries on 23/09/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSJSONRequestOperation.h"
#import "JSONKit.h"

@interface AFHTTPRequestOperation ()

- (id)initWithRequest:(NSURLRequest *)urlRequest;

@end


@interface CSJSONRequestOperation ()

@property (copy) void (^successHandler)(NSURLRequest*, NSHTTPURLResponse*, NSError*);
@property (copy) void (^failureHandler)(NSURLRequest*, NSHTTPURLResponse*, NSError*);

@end


@implementation CSJSONRequestOperation

@synthesize successHandler;
@synthesize failureHandler;

+ (id)operationWithRequest:(NSURLRequest *)urlRequest
     acceptableStatusCodes:(NSIndexSet *)acceptableStatusCodes
    acceptableContentTypes:(NSSet *)acceptableContentTypes
                   success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                   failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure {
  
  
  CSJSONRequestOperation* operation = [super operationWithRequest:urlRequest
                                            acceptableStatusCodes:acceptableStatusCodes
                                           acceptableContentTypes:acceptableContentTypes
                                                          success:success
                                                          failure:failure];
  
  operation.successHandler = Block_copy(success);
  operation.failureHandler = Block_copy(failure);
  
  return operation;
}

+ (id)operationWithRequest:(NSURLRequest *)urlRequest
                completion:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSData *data, NSError *error))completion {
  
  __block CSJSONRequestOperation* operation = [[[self alloc] initWithRequest:urlRequest] autorelease];
  
  void (^completionWrapper)(NSURLRequest*, NSHTTPURLResponse*, NSData*, NSError*);
  
  completionWrapper = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSData *data, NSError *error) {
    if (!error && [data length] > 0 &&
        ![[self defaultAcceptableStatusCodes] containsIndex:[response statusCode]] &&
        [[self defaultAcceptableContentTypes] containsObject:[response MIMEType]]) {
      
      if (!operation.failureHandler) return;
      
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        id JSON = nil;
        
        NSError *JSONError = nil;
        JSON = [[JSONDecoder decoder] objectWithData:data error:&JSONError];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
          if (JSONError) {
            operation.failureHandler(request, response, JSONError);
            
          } else {
            NSError* serverError = [NSError errorWithDomain:@"com.createsend.api.error"
                                                       code:[[JSON valueForKey:@"Code"] integerValue]
                                                   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [JSON valueForKey:@"Message"], NSLocalizedDescriptionKey, nil]];
            
            operation.failureHandler(request, response, serverError);
          }
        });
      });
    } else {
      completion(request, response, data, error);
    }
  };
  
  [operation setValue:completionWrapper forKey:@"completion"];
  
  return operation;
}

+ (void)processData:(NSData *)data
            request:(NSURLRequest *)request
           response:(NSHTTPURLResponse *)response
            success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
            failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure {
  
  NSString* quotedString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
  if ([quotedString hasPrefix:@"\""]) {
    NSString* string = [quotedString substringWithRange:NSMakeRange(1, [quotedString length] - 2)];
    if (success) success(request, response, string);
    
  } else {
    [super processData:data request:request response:response success:success failure:failure];
  }
}

- (void)dealloc {
  if (successHandler) Block_release(successHandler);
  if (failureHandler) Block_release(failureHandler);
  
  [super release];
}

@end
