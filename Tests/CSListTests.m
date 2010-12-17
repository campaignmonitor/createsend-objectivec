//
//  CSCampaignTests.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSListCreateRequest.h"
#import "CSListDeleteRequest.h"
#import "CSClientListsRequest.h"

#import "NSString+UUIDAdditions.h"


@interface CSListTests : GHAsyncTestCase
@end


@implementation CSListTests


- (void)setUpClass { [CSAPIRequest setDefaultAPIKey:kCSTestsValidAPIKey]; }
- (void)tearDownClass { [CSAPIRequest setDefaultAPIKey:nil]; }


- (void)testLists {
  // Create a list

  CSListCreateRequest* createRequest = [CSListCreateRequest requestWithClientID:kCSTestsValidClientID
                                                                          title:[NSString UUIDString]
                                                                unsubscribePage:@"http://example.com/unsubscribe"
                                                        confirmationSuccessPage:@"http://example.com/success"
                                                             shouldConfirmOptIn:YES];
  [self performRequest:createRequest forTestWithSelector:_cmd];

  GHAssertNil(createRequest.error, nil);
  GHAssertNotNil(createRequest.listID, nil);


  // Get a list of all the lists

  CSClientListsRequest* listRequest = [CSClientListsRequest requestWithClientID:kCSTestsValidClientID];
  [self performRequest:listRequest forTestWithSelector:_cmd];

  GHAssertNil(listRequest.error, nil);
  GHAssertTrue([listRequest.lists count] > 0, nil);


  // Delete the lists

  for (CSList* list in listRequest.lists) {
    CSListDeleteRequest* deleteRequest = [CSListDeleteRequest requestWithListID:list.listID];
    [self performRequest:deleteRequest forTestWithSelector:_cmd];

    GHAssertNil(deleteRequest.error, nil);
  }
}



@end
