//
//  CSListCustomFieldsRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 20/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSListCustomFieldsRequest.h"


@implementation CSListCustomFieldsRequest


@synthesize customFields=_customFields;


+ (id)requestWithListID:(NSString *)listID {
  return [self requestWithAPISlug:[NSString stringWithFormat:@"lists/%@/customfields", listID]];
}


- (void)handleParsedResponse {
  NSMutableArray* customFields = [NSMutableArray array];

  for (NSDictionary* customFieldDict in self.parsedResponse) {
    [customFields addObject:[CSCustomField customFieldWithDictionary:customFieldDict]];
  }

  self.customFields = customFields;
}


- (void)dealloc {
  [_customFields release];

  [super dealloc];
}


@end
