//
//  CSListCustomFieldCreateRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 20/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSListCustomFieldCreateRequest.h"


@implementation CSListCustomFieldCreateRequest


@synthesize customFieldKey=_customFieldKey;


+ (id)requestWithListID:(NSString *)listID
            customField:(CSCustomField *)customField {

  CSListCustomFieldCreateRequest* request = [self requestWithAPISlug:[NSString stringWithFormat:@"lists/%@/customfields", listID]];

  NSMutableDictionary* requestObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        customField.name, @"FieldName",
                                        [customField dataTypeString], @"DataType", nil];

  if (customField.options) {
    [requestObject setObject:customField.options
                      forKey:@"Options"];
  }

  request.requestObject = requestObject;

  return request;
}


- (void)handleParsedResponse {
  self.customFieldKey = self.parsedResponse;
}


- (void)dealloc {
  [_customFieldKey release];

  [super dealloc];
}


@end
