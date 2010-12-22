//
//  CSSubscriberSubscribeRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 22/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSSubscriberSubscribeRequest.h"


@implementation CSSubscriberSubscribeRequest


@synthesize subscribedEmailAddress=_subscribedEmailAddress;


+ (id)requestWithListID:(NSString *)listID
           emailAddress:(NSString *)emailAddress
                   name:(NSString *)name
      shouldResubscribe:(BOOL)shouldResubscribe {

  return [self requestWithListID:listID
                    emailAddress:emailAddress
                            name:name
               shouldResubscribe:shouldResubscribe
               customFieldValues:nil];
}


+ (id)requestWithListID:(NSString *)listID
           emailAddress:(NSString *)emailAddress
                   name:(NSString *)name
      shouldResubscribe:(BOOL)shouldResubscribe
      customFieldValues:(NSArray *)customFieldValues {

  CSSubscriberSubscribeRequest* request = [self requestWithAPISlug:[NSString stringWithFormat:@"subscribers/%@", listID]];

  NSDictionary* requestObject = [[[CSSubscriber dictionaryWithEmailAddress:emailAddress
                                                                      name:name
                                                         customFieldValues:customFieldValues] mutableCopy] autorelease];

  [requestObject setValue:[NSNumber numberWithBool:shouldResubscribe]
                   forKey:@"Resubscribe"];

  request.requestObject = requestObject;

  return request;
}


- (void)handleParsedResponse {
  self.subscribedEmailAddress = self.parsedResponse;
}


- (void)dealloc {
  [_subscribedEmailAddress release];

  [super dealloc];
}


@end
