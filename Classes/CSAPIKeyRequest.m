//
//  CSAPIKeyRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 16/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIKeyRequest.h"


@implementation CSAPIKeyRequest


@synthesize APIKey=_APIKey;



+ (id)requestWithSiteURL:(NSString *)siteURL
                username:(NSString *)username
                password:(NSString *)password {

  CSAPIKeyRequest* request = [self requestWithAPISlug:@"apikey"
                                      queryParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       siteURL, @"siteurl",
                                                       nil]];

  request.username = username;
  request.password = password;

  return request;
}


- (void)handleParsedResponse {
  self.APIKey = [self.parsedResponse valueForKey:@"ApiKey"];
}


- (void)dealloc {
  [_APIKey release];

  [super release];
}


@end
