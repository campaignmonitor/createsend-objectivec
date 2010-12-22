//
//  CSSubscriberUnsubscribeRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 22/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSSubscriberUnsubscribeRequest.h"


@implementation CSSubscriberUnsubscribeRequest


+ (id)requestWithListID:(NSString *)listID
           emailAddress:(NSString *)emailAddress {

  CSSubscriberUnsubscribeRequest* request = [self requestWithAPISlug:[NSString stringWithFormat:@"subscribers/%@/unsubscribe", listID]];
  request.requestObject = [NSDictionary dictionaryWithObject:emailAddress
                                                      forKey:@"EmailAddress"];

  return request;
}


@end
