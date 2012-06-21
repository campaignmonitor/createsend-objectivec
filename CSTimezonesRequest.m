//
//  CSTimezonesRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSTimezonesRequest.h"


@implementation CSTimezonesRequest


@synthesize timezones=_timezones;


+ (id)request {
  return [self requestWithAPISlug:@"timezones"];
}


+ (id)requestWithAPIKey:(NSString *)APIKey {
  CSTimezonesRequest* request = [self request];
  request.username = APIKey;
  return request;
}


- (void)handleParsedResponse {
  self.timezones = self.parsedResponse;
}


- (void)dealloc {
  [_timezones release];

  [super dealloc];
}


@end
