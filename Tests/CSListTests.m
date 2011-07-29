//
//  CSCampaignTests.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSTestCase.h"
#import "NSString+UUIDAdditions.h"

@interface CSListTests : CSTestCase
@end

@implementation CSListTests

- (void)testLists {
  // Create a list
  
  NSString* listTitle = [NSString UUIDString];
  NSString* listUnsubscribePage = @"example.com/unsubscribe";
  NSString* listConfirmationSuccessPage = @"example.com/success";
  BOOL listShouldConfirmOptIn = NO;
  
  __block NSString* listID = nil;
  
  [self testAsync:^{
    [self.testAPI createListWithClientID:kCSTestsValidClientID
                                   title:listTitle
                         unsubscribePage:listUnsubscribePage
                 confirmationSuccessPage:listConfirmationSuccessPage
                      shouldConfirmOptIn:listShouldConfirmOptIn
                       completionHandler:^(NSString* theListID) {
                         [self notifyTestFinished];
                         GHAssertNotNil(theListID, nil);
                         
                         listID = [theListID copy];
                         
                       } errorHandler:[self assertNoError]];
  }];
  
  [listID autorelease];
  
  
  // Get the details of the list
  
  [self testAsync:^{
    [self.testAPI getListDetailsWithListID:listID
                         completionHandler:^(CSList *list) {
                           [self notifyTestFinished];
                           
                           GHAssertNotNil(list, nil);
                           GHAssertEqualObjects(list.listID, listID, nil);
                           GHAssertEqualObjects(list.title, listTitle, nil);
                           GHAssertEqualObjects(list.unsubscribePage, listUnsubscribePage, nil);
                           GHAssertEqualObjects(list.confirmationSuccessPage, listConfirmationSuccessPage, nil);
                           GHAssertTrue(list.confirmOptIn == listShouldConfirmOptIn, nil);
                           
                         } errorHandler:[self assertNoError]];
  }];
  
  
  // Get the list stats
  
  [self testAsync:^{
    [self.testAPI getListStatisticsWithListID:listID
                            completionHandler:^(NSDictionary *listStatisticsData) {
                              [self notifyTestFinished];
                              
                              GHAssertNotNil(listStatisticsData, nil);
                              
                            } errorHandler:[self assertNoError]];
  }];
  
  
  // Create a custom field for the list
  
  CSCustomField* customField = [CSCustomField customFieldWithName:@"Test Field"
                                                         dataType:CSCustomFieldMultiSelectManyDataType
                                                          options:[NSArray arrayWithObjects:@"First Option", @"Second Option", nil]];
  
  __block NSString* customFieldKey = nil;
  
  [self testAsync:^{
    [self.testAPI createCustomFieldWithListID:listID
                                  customField:customField
                            completionHandler:^(NSString* theCustomFieldKey) {
                              [self notifyTestFinished];
                              
                              GHAssertNotNil(theCustomFieldKey, nil);
                              customFieldKey = [theCustomFieldKey copy];
                              
                            } errorHandler:[self assertNoError]];
  }];
  
  [customFieldKey autorelease];
  
  // Ensure the custom field was created properly
  
  [self testAsync:^{
    [self.testAPI getCustomFieldsWithListID:listID
                          completionHandler:^(NSArray* customFields) {
                            [self notifyTestFinished];
                            
                            GHAssertNotNil(customFields, nil);
                            GHAssertTrue([customFields count] > 0, nil);
                            
                          } errorHandler:[self assertNoError]];
  }];
  
  
  // Subscribe to the list, supplying a value for the custom field
  
  NSString* subscriberEmailAddress = @"john.doe@example.com";
  NSArray* subscriberCustomFields = [NSArray arrayWithObjects:
                                     [CSCustomField dictionaryWithValue:@"First Option"
                                                            forFieldKey:customFieldKey],
                                     [CSCustomField dictionaryWithValue:@"Second Option"
                                                            forFieldKey:customFieldKey],
                                     nil];
  
  [self testAsync:^{
    [self.testAPI subscribeToListWithID:listID
                           emailAddress:@"john.doe@example.com"
                                   name:@"John Doe"
                      shouldResubscribe:YES
                      customFieldValues:subscriberCustomFields
                      completionHandler:^(NSString* subscribedAddress) {
                        [self notifyTestFinished];
                        
                        GHAssertNotNil(subscribedAddress, nil);
                        
                      } errorHandler:[self assertNoError]];
  }];
  
  
  // Get the subscriber details and ensure they're correct
  
  [self testAsync:^{
    [self.testAPI getSubscriberDetailsWithEmailAddress:subscriberEmailAddress
                                                listID:listID
                                     completionHandler:^(CSSubscriber* subscriber) {
                                       [self notifyTestFinished];
                                       
                                       GHAssertNotNil(subscriber, nil);
                                       
                                     } errorHandler:[self assertNoError]];
  }];
  
  
  // Delete the new subscriber
  
  [self testAsync:^{
    [self.testAPI unsubscribeFromListWithID:listID
                               emailAddress:subscriberEmailAddress
                          completionHandler:^{ [self notifyTestFinished]; }
                               errorHandler:[self assertNoError]];
  }];
  
  
  // Get a list of all the lists
  
  __block NSArray* lists = nil;
  
  [self testAsync:^{
    [self.testAPI getListsWithClientID:kCSTestsValidClientID
                     completionHandler:^(NSArray* theLists) {
                       [self notifyTestFinished];
                       
                       GHAssertTrue([theLists count] > 0, nil);
                       lists = [theLists copy];
                       
                     } errorHandler:[self assertNoError]];
  }];
  
  [lists autorelease];
  
  
  // Delete the lists
  
  for (CSList* list in lists) {
    [self testAsync:^{
      [self.testAPI deleteListWithID:list.listID
                   completionHandler:^(void) { [self notifyTestFinished]; }
                        errorHandler:[self assertNoError]];
    }];
  }
}

@end
