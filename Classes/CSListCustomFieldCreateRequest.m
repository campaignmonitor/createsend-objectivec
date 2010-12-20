//
//  CSListCustomFieldCreateRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 20/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSListCustomFieldCreateRequest.h"


@implementation CSListCustomFieldCreateRequest


+ (id)requestWithListID:(NSString *)listID
            customField:(CSCustomField *)customField {

  CSListCustomFieldCreateRequest* request = [self requestWithAPISlug:[NSString stringWithFormat:@"lists/%@/customfields", listID]];
  request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                           customField.name, @"FieldName",
                           [customField dataTypeString], @"DataType",
                           customField.options, @"Options",
                           nil];
  return request;
}


- (void)prepareRequestObject {

}


- (void)handleParsedResponse {
  self.listID = self.parsedResponse;
}


@end
