//
//  CSClientListsRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSClientListsRequest.h"


@implementation CSClientListsRequest


@synthesize lists=_lists;


+ (id)requestWithClientID:(NSString *)clientID {
  CSClientListsRequest* request = [self requestWithAPISlug:[NSString stringWithFormat:@"clients/%@/lists", clientID]];
  return request;
}


- (void)handleParsedResponse {
  NSMutableArray* lists = [NSMutableArray array];

  for (NSDictionary* listDict in self.parsedResponse) {
    [lists addObject:[CSList listWithDictionary:listDict]];
  }

  self.lists = lists;
}


- (void)dealloc {
  [_lists release];

  [super dealloc];
}


@end
