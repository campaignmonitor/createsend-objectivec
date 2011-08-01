//
//  CSAPIRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 16/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "ASIHTTPRequest.h"

extern NSString* const kCSAPIRequestErrorDomain;

typedef enum _CSAPIRequestErrorType {
  CSAPIRequestInvalidContentTypeErrorType = 1,
  CSAPIRequestFailedToParseResponseErrorType = 2
} CSAPIRequestErrorType;

@interface CSAPIRequest : ASIHTTPRequest

@property (retain) id requestObject;
@property (retain) id parsedResponse;

+ (id)requestWithAPIKey:(NSString *)APIKey slug:(NSString *)slug;
+ (id)requestWithAPIKey:(NSString *)APIKey slug:(NSString *)slug queryParameters:(NSDictionary *)queryParameters;

+ (id)requestWithAPISlug:(NSString *)APISlug;
+ (id)requestWithAPISlug:(NSString *)APISlug queryParameters:(NSDictionary *)queryParameters;

+ (NSDictionary *)paginationParametersWithPage:(NSUInteger)page
                                      pageSize:(NSUInteger)pageSize
                                    orderField:(NSString *)orderField
                                     ascending:(BOOL)ascending;

+ (NSDateFormatter *)sharedDateFormatter;

// Prepare the requestObject, which is converted to JSON and set as the request body
- (void)prepareRequestObject;


// Pull the relevant values out of the parsed response dictionary
- (void)handleParsedResponse;


@end
