//
//  CSCampaignTests.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSListCreateRequest.h"
#import "CSListDeleteRequest.h"

#import "NSString+UUIDAdditions.h"


@interface CSListTests : GHAsyncTestCase
@end


@implementation CSListTests


- (void)setUpClass { [CSAPIRequest setDefaultAPIKey:kCSTestsValidAPIKey]; }
- (void)tearDownClass { [CSAPIRequest setDefaultAPIKey:nil]; }


# pragma mark -
# pragma mark CSListCreateRequest


- (void)testListCreationAndDeletion {
  // Create the list

  CSListCreateRequest* createRequest = [CSListCreateRequest requestWithClientID:kCSTestsValidClientID
                                                                          title:[NSString UUIDString]
                                                                unsubscribePage:@"http://example.com/unsubscribe"
                                                        confirmationSuccessPage:@"http://example.com/success"
                                                             shouldConfirmOptIn:YES];

  [self performRequest:createRequest forTestWithSelector:_cmd];

  GHAssertNil(createRequest.error, nil);
  GHAssertNotNil(createRequest.listID, nil);


  // Delete the list

  CSListDeleteRequest* deleteRequest = [CSListDeleteRequest requestWithListID:createRequest.listID];

  [self performRequest:deleteRequest forTestWithSelector:_cmd];

  GHAssertNil(deleteRequest.error, nil);
}



@end
