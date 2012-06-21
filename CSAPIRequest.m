//
//  CSAPIRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 16/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"
#import <YAJL/YAJL.h>
#import "NSString+URLEncoding.h"


NSString* const kCSAPIRequestErrorDomain = @"kCSAPIRequestErrorDomain";

static NSString* defaultAPIKey = nil;


@implementation CSAPIRequest


@synthesize requestObject;
@synthesize parsedResponse;


- (id)initWithURL:(NSURL *)newURL {
  self = [super initWithURL:newURL];

  if (self) {
    self.shouldRedirect = NO;
    self.shouldPresentAuthenticationDialog = NO;
    self.shouldPresentProxyAuthenticationDialog = NO;
    self.useSessionPersistence = NO;
  }

  return self;
}


+ (id)requestWithAPISlug:(NSString *)APISlug {
  return [self requestWithAPISlug:APISlug queryParameters:nil];
}

+ (id)requestWithAPISlug:(NSString *)APISlug
         queryParameters:(NSDictionary *)queryParameters {

  NSString* URLString = [NSString stringWithFormat:@"http://api.createsend.com/api/v3/%@.json", APISlug];

  if (queryParameters) {
    NSMutableString* queryString = [NSMutableString string];

    for (NSString* key in [queryParameters allKeys]) {
      NSString* value = [queryParameters valueForKey:key];
      NSString* queryPair = [NSString stringWithFormat:@"%@=%@", key, [value stringByPercentEncodingForURLs]];

      [queryString appendString:queryPair];
    }

    URLString = [URLString stringByAppendingFormat:@"?%@", queryString];
  }

  NSURL* URL = [NSURL URLWithString:URLString];

  return [[[self alloc] initWithURL:URL] autorelease];
}


+ (NSString *)defaultAPIKey {
  return defaultAPIKey;
}


+ (void)setDefaultAPIKey:(NSString *)newDefaultAPIKey {
  [defaultAPIKey release];
  defaultAPIKey = [newDefaultAPIKey retain];
}


- (void)main {
  [self prepareRequestObject];

  if (self.requestObject) {
    NSData* JSONRequestBody = [[self.requestObject yajl_JSONString] dataUsingEncoding:NSUTF8StringEncoding];
    [self appendPostData:JSONRequestBody];
  }

  self.username = self.username ?: [[self class] defaultAPIKey];

  if (self.username != nil && self.password == nil) {
    self.password = @"";
  }

  [super main];
}


- (void)prepareRequestObject {

}


- (void)parseJSONResponse {
  @try {
    self.parsedResponse = [[self responseData] yajl_JSON];

    CSDLog(@"parsedResponse = %@", self.parsedResponse);

    if (self.responseStatusCode != 200 && self.responseStatusCode != 201) {
      [self failWithError:[NSError errorWithDomain:kCSAPIRequestErrorDomain
                                              code:[[self.parsedResponse valueForKey:@"Code"] integerValue]
                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [self.parsedResponse valueForKey:@"Message"], NSLocalizedDescriptionKey,
                                                    nil]]];
    }
  }
  @catch (NSException * e) {
    [self failWithError:[NSError errorWithDomain:kCSAPIRequestErrorDomain
                                            code:CSAPIRequestFailedToParseResponseErrorType
                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"Unable to parse JSON response", NSLocalizedDescriptionKey,
                                                  nil]]];
  }
}


- (void)handleParsedResponse {}


- (void)requestFinished {
  CSDLog(@"%@", self);

  NSString* contentType = [[self responseHeaders] objectForKey:@"Content-Type"];

	if ([contentType isEqualToString:@"application/json; charset=utf-8"]) {
    [self parseJSONResponse];

	} else {
    [self failWithError:[NSError errorWithDomain:kCSAPIRequestErrorDomain
                                            code:CSAPIRequestInvalidContentTypeErrorType
                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"Invalid Content-Type", NSLocalizedDescriptionKey,
                                                  nil]]];
  }

	if (![self error]) {
    [self handleParsedResponse];
		[super requestFinished];
	}
}


- (void)failWithError:(NSError*)theError {
  CSDLog(@"%@, error = %@", self, theError);
  [super failWithError:theError];
}


- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ url='%@' responseStatusCode=%i"
          " totalBytesSent=%llu totalBytesRead=%llu>",
          [self class], self.url, self.responseStatusCode,
          self.totalBytesSent, self.totalBytesRead];
}


- (void)dealloc {
  [requestObject release];
  [parsedResponse release];

  [super dealloc];
}

@end
