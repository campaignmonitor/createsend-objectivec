//
//  CSListDetailsRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 20/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSListDetailsRequest.h"


@implementation CSListDetailsRequest


@synthesize list=_list;


+ (id)requestWithListID:(NSString *)listID {
  return [self requestWithAPISlug:[NSString stringWithFormat:@"lists/%@", listID]];
}


- (void)handleParsedResponse {
  self.list = [CSList listWithDictionary:self.parsedResponse];
}


- (void)dealloc {
  [_list release];

  [super dealloc];
}


@end
