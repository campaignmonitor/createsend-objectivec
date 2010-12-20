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
#import "CSListDetailsRequest.h"


#import "NSString+UUIDAdditions.h"


@interface CSListTests : GHAsyncTestCase
@end


@implementation CSListTests


- (void)setUpClass { [CSAPIRequest setDefaultAPIKey:kCSTestsValidAPIKey]; }
- (void)tearDownClass { [CSAPIRequest setDefaultAPIKey:nil]; }


- (void)testLists {
  // Create a list

  NSString* listTitle = [NSString UUIDString];
  NSString* listUnsubscribePage = @"example.com/unsubscribe";
  NSString* listConfirmationSuccessPage = @"example.com/success";
  BOOL listShouldConfirmOptIn = YES;

  CSListCreateRequest* createRequest = [CSListCreateRequest requestWithClientID:kCSTestsValidClientID
                                                                          title:listTitle
                                                                unsubscribePage:listUnsubscribePage
                                                        confirmationSuccessPage:listConfirmationSuccessPage
                                                             shouldConfirmOptIn:listShouldConfirmOptIn];
  [self performRequestAndWaitForResponse:createRequest];

  GHAssertNil(createRequest.error, nil);
  GHAssertNotNil(createRequest.listID, nil);


  // Get the details of the list

  CSListDetailsRequest* detailsRequest = [CSListDetailsRequest requestWithListID:createRequest.listID];
  [self performRequestAndWaitForResponse:detailsRequest];

  GHAssertNil(detailsRequest.error, nil);
  GHAssertNotNil(detailsRequest.list, nil);

  GHAssertEqualObjects(detailsRequest.list.listID, createRequest.listID, nil);
  GHAssertEqualObjects(detailsRequest.list.title, listTitle, nil);
  GHAssertEqualObjects(detailsRequest.list.unsubscribePage, listUnsubscribePage, nil);
  GHAssertEqualObjects(detailsRequest.list.confirmationSuccessPage, listConfirmationSuccessPage, nil);
  GHAssertTrue(detailsRequest.list.confirmOptIn == listShouldConfirmOptIn, nil);


  // Get a list of all the lists

  CSClientListsRequest* listRequest = [CSClientListsRequest requestWithClientID:kCSTestsValidClientID];
  [self performRequestAndWaitForResponse:listRequest];

  GHAssertNil(listRequest.error, nil);
  GHAssertTrue([listRequest.lists count] > 0, nil);


  // Delete the lists

  for (CSList* list in listRequest.lists) {
    CSListDeleteRequest* deleteRequest = [CSListDeleteRequest requestWithListID:list.listID];
    [self performRequestAndWaitForResponse:deleteRequest];

    GHAssertNil(deleteRequest.error, nil);
  }
}



@end
