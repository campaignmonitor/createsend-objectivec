//
//  CSSubscriberDetailsRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 22/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSSubscriberDetailsRequest.h"


@implementation CSSubscriberDetailsRequest


@synthesize subscriber=_subscriber;


+ (id)requestWithListID:(NSString *)listID
           emailAddress:(NSString *)emailAddress {

  return [self requestWithAPISlug:[NSString stringWithFormat:@"subscribers/%@", listID]
                  queryParameters:[NSDictionary dictionaryWithObject:emailAddress
                                                              forKey:@"email"]];
}


- (void)handleParsedResponse {
  self.subscriber = [CSSubscriber subscriberWithDictionary:self.parsedResponse];
}


- (void)dealloc {
  [_subscriber release];

  [super dealloc];
}


@end
