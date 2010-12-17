//
//  CSListCreateRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSListCreateRequest.h"


@implementation CSListCreateRequest


@synthesize listID=_listID;


+ (id)requestWithClientID:(NSString *)clientID
                    title:(NSString *)title
          unsubscribePage:(NSString *)unsubscribePage
  confirmationSuccessPage:(NSString *)confirmationSuccessPage
       shouldConfirmOptIn:(BOOL)shouldConfirmOptIn {

  CSListCreateRequest* request = [self requestWithAPISlug:[NSString stringWithFormat:@"lists/%@", clientID]];
  request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                           title, @"Title",
                           unsubscribePage, @"UnsubscribePage",
                           confirmationSuccessPage, @"ConfirmationSuccessPage",
                           [NSNumber numberWithBool:shouldConfirmOptIn], @"ConfirmedOptIn",
                           nil];
  return request;
}


- (void)handleParsedResponse {
  self.listID = self.parsedResponse;
}


- (void)dealloc {
  [_listID release];

  [super dealloc];
}


@end
