//
//  CSCampaignTests.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSListCreateRequest.h"
#import "NSString+UUIDAdditions.h"


@interface CSListTests : GHAsyncTestCase
@end


@implementation CSListTests


- (void)setUp { [CSAPIRequest setDefaultAPIKey:kCSTestsValidAPIKey]; }
- (void)tearDown { [CSAPIRequest setDefaultAPIKey:nil]; }


# pragma mark -
# pragma mark CSListCreateRequest


- (void)testCSListCreateRequest {
  CSListCreateRequest* request = [CSListCreateRequest requestWithClientID:kCSTestsValidClientID
                                                                    title:[NSString UUIDString]
                                                          unsubscribePage:@"http://example.com/unsubscribe"
                                                  confirmationSuccessPage:@"http://example.com/success"
                                                       shouldConfirmOptIn:YES];

  [self performRequest:request forTestWithSelector:_cmd];

  GHAssertNil(request.error, @"");
  GHAssertNotNil(request.listID, @"");
}



@end
