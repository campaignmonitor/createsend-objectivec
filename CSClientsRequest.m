//
//  CSClientsRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSClientsRequest.h"


@implementation CSClientsRequest


@synthesize clients=_clients;


+ (id)request {
  return [self requestWithAPISlug:@"clients"];
}


+ (id)requestWithAPIKey:(NSString *)APIKey {
  CSClientsRequest* request = [self request];
  request.username = APIKey;
  return request;
}


- (void)handleParsedResponse {
  NSMutableArray* clients = [NSMutableArray array];

  for (NSDictionary* clientDict in self.parsedResponse) {
    [clients addObject:[CSClient clientWithDictionary:clientDict]];
  }

  self.clients = clients;
}


- (void)dealloc {
  [_clients release];

  [super dealloc];
}


@end
