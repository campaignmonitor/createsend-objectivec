//
//  CSListDeleteRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSListDeleteRequest.h"


@implementation CSListDeleteRequest


+ (id)requestWithListID:(NSString *)listID {
  CSListDeleteRequest* request = [self requestWithAPISlug:[NSString stringWithFormat:@"lists/%@", listID]];
  request.requestMethod = @"DELETE";
  return request;
}


@end
