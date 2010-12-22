//
//  CSCampaignTests.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CreateSend.h"
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
  BOOL listShouldConfirmOptIn = NO;

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


  // Get the list stats

  CSListStatsRequest* statsRequest = [CSListStatsRequest requestWithListID:createRequest.listID];
  [self performRequestAndWaitForResponse:statsRequest];

  GHAssertNil(statsRequest.error, nil);
  GHAssertNotNil(statsRequest.listStatistics, nil);


  // Create a custom field for the list

  CSCustomField* customField = [CSCustomField customFieldWithName:@"Test Field"
                                                         dataType:CSCustomFieldMultiSelectManyDataType
                                                          options:[NSArray arrayWithObjects:@"First Option", @"Second Option", nil]];

  CSListCustomFieldCreateRequest* customFieldCreateRequest;
  customFieldCreateRequest = [CSListCustomFieldCreateRequest requestWithListID:createRequest.listID
                                                                   customField:customField];
  [self performRequestAndWaitForResponse:customFieldCreateRequest];

  GHAssertNil(customFieldCreateRequest.error, nil);
  GHAssertNotNil(customFieldCreateRequest.customFieldKey, nil);


  // Ensure the custom field was created properly

  CSListCustomFieldsRequest* customFieldsRequest;
  customFieldsRequest = [CSListCustomFieldsRequest requestWithListID:createRequest.listID];
  [self performRequestAndWaitForResponse:customFieldsRequest];

  GHAssertNil(customFieldsRequest.error, nil);
  GHAssertNotNil(customFieldsRequest.customFields, nil);
  GHAssertTrue([customFieldsRequest.customFields count] == 1, nil);


  // Subscribe to the list, supplying a value for the custom field

  NSString* subscriberEmailAddress = @"john.doe@example.com";
  NSArray* subscriberCustomFields = [NSArray arrayWithObjects:
                                     [CSCustomField dictionaryWithValue:@"First Option" forFieldKey:customFieldCreateRequest.customFieldKey],
                                     [CSCustomField dictionaryWithValue:@"Second Option" forFieldKey:customFieldCreateRequest.customFieldKey],
                                     nil];

  CSSubscriberSubscribeRequest* subscribeRequest;
  subscribeRequest = [CSSubscriberSubscribeRequest requestWithListID:createRequest.listID
                                                     emailAddress:@"john.doe@example.com"
                                                             name:@"John Doe"
                                                shouldResubscribe:YES
                                                customFieldValues:subscriberCustomFields];
  [self performRequestAndWaitForResponse:subscribeRequest];

  GHAssertNil(subscribeRequest.error, nil);
  GHAssertNotNil(subscribeRequest.subscribedEmailAddress, nil);


  // Get the subscriber details and ensure they're correct

  CSSubscriberDetailsRequest* subscriberRequest;
  subscriberRequest = [CSSubscriberDetailsRequest requestWithListID:createRequest.listID
                                                       emailAddress:subscriberEmailAddress];
  [self performRequestAndWaitForResponse:subscriberRequest];

  GHAssertNil(subscriberRequest.error, nil);
  GHAssertNotNil(subscriberRequest.subscriber, nil);


  // Delete the new subscriber

  CSSubscriberUnsubscribeRequest* unsubscribeRequest;
  unsubscribeRequest = [CSSubscriberUnsubscribeRequest requestWithListID:createRequest.listID
                                                       emailAddress:subscriberEmailAddress];
  [self performRequestAndWaitForResponse:unsubscribeRequest];

  GHAssertNil(unsubscribeRequest.error, nil);


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
