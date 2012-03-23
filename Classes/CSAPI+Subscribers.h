//
//  CSAPI+Subscribers.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"
#import "CSSubscriber.h"

/**
 Subscriber-related APIs.
 */
@interface CSAPI (Subscribers)

/**
 Adds a subscriber to an existing subscriber list, including custom field data 
 if provided. If the subscriber (email address) already exists, their name and
 any custom field values are updated.
 
     http://www.campaignmonitor.com/api/subscribers/#adding_a_subscriber
 
 @param listID The ID of the subscriber list to which the subscriber should be added
 @param emailAddress Email address of the subscriber
 @param name Name of the subscriber
 @param shouldResubscribe Whether to resubscribe subscribers in the inactive or unsubscribed state
 @param customFieldValues An array of custom field values
 @param completionHandler Completion callback, with the email address of the new subscriber as the first and only argument
 @param errorHandler Error callback
 */
- (void)subscribeToListWithID:(NSString *)listID
                 emailAddress:(NSString *)emailAddress
                         name:(NSString *)name
            shouldResubscribe:(BOOL)shouldResubscribe
            customFieldValues:(NSArray *)customFieldValues
            completionHandler:(void (^)(NSString* subscribedAddress))completionHandler
                 errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Update an existing subscriber, including email address, name, and custom field data if supplied.
 
     http://www.campaignmonitor.com/api/subscribers/#updating_a_subscriber
 
 @param listID The ID of the subscriber list containing the subscriber you'd like to update
 @param currentEmailAddress Existing email address of the subscriber
 @param newEmailAddress New email address of the subscriber
 @param name New name of the subscriber
 @param shouldResubscribe Whether or not to resubscribe inactive subscribers
 @param customFieldValues Custom field values to update
 @param completionHandler Coompletion callback
 @param errorHandler Error callback
 */
- (void)updateSubscriptionWithListID:(NSString *)listID
                currentEmailAddress:(NSString *)currentEmailAddress
                     newEmailAddress:(NSString *)newEmailAddress
                                name:(NSString *)name
                   shouldResubscribe:(BOOL)shouldResubscribe
                   customFieldValues:(NSArray *)customFieldValues
                   completionHandler:(void (^)(void))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Change the status of a subscriber from `Active` to `Unsubscribed`.
 
     http://www.campaignmonitor.com/api/subscribers/#unsubscribing_a_subscriber
 
 @param listID The ID of the subscriber list from which the subscriber should be unsubscribed
 @param emailAddress Email address of the subscriber you'd like to unsubscribe
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)unsubscribeFromListWithID:(NSString *)listID
                     emailAddress:(NSString *)emailAddress
                completionHandler:(void (^)(void))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a subscribers details including their email address, name, active/inactive
 state and any custom field data.
 
     http://www.campaignmonitor.com/api/subscribers/#getting_subscriber_details
 
 @param emailAddress The ID of the subscriber whose details should be retrieved
 @param listID The ID of the subscriber list to which the subscriber belongs
 @param completionHandler Completion callback, with a `CSSubscriber` instance as the first and only argument.
 @param errorHandler Error callback
 */
- (void)getSubscriberDetailsWithEmailAddress:(NSString *)emailAddress
                                      listID:(NSString *)listID
                           completionHandler:(void (^)(CSSubscriber* subscriber))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of all campaigns or autoresponder emails, to which a subscriber has
 made some trackable action. For each campaign or autoresponder email, all
 actions are provided, including the event type, date and IP address from which
 the event occurred.
 
     http://www.campaignmonitor.com/api/subscribers/#getting_subscriber_history
 
 @param emailAddress The email address of the subscriber whose history should be retrieved
 @param listID The ID of the subscriber list to which the subscriber belongs
 @param completionHandler Completion callback, with an array of campaigns and autoresponder email dictionaries. Dictionaries are in the following format:
 
     {
       "ID": "fc0ce7105baeaf97f47c99be31d02a91",
       "Type": "Campaign",
       "Name": "Campaign One",
       "Actions": [
         {
           "Event": "Open",
           "Date": "2010-10-12 13:18:00",
           "IPAddress": "192.168.126.87",
           "Detail": ""
         },
         {
           "Event": "Click",
           "Date": "2010-10-12 13:16:00",
           "IPAddress": "192.168.126.87",
           "Detail": "http://example.com/post/12323/"
         }
       ]
     }
 
 @param errorHandler Error callback
 */
- (void)getSubscriberHistoryWithEmailAddress:(NSString *)emailAddress
                                      listID:(NSString *)listID
                           completionHandler:(void (^)(NSDictionary* historyData))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler;
/**
 Import many subscribers into a subscriber list, including any custom field data if provided.
 
     http://www.campaignmonitor.com/api/subscribers/#importing_subscribers
 
 @param listID The ID of the subscriber list to which the subscribers should be added
 @param subscriberData An array of subscriber dictionaries. Dictionaries should be in the following format:
 
     {
       "EmailAddress": "subscriber1@example.com",
       "Name": "New Subscriber One",
       "CustomFields": [
         {
           "Key": "website",
           "Value": "http://example.com"
         },
         {
           "Key": "interests",
           "Value": "",
           "Clear": true
         }
       ]
     }
 
 @param shouldResubscribe Whether or not to resubscribe inactive subscribers
 @param completionHandler Completion callback, with a dictionary containing information about the import. If the import was successful, the dictionary is in the following format:
 
     {
       "FailureDetails": [],
       "TotalUniqueEmailsSubmitted": 3,
       "TotalExistingSubscribers": 0,
       "TotalNewSubscribers": 3,
       "DuplicateEmailsInSubmission": []
     }
 
 If the import was unsuccessful, the dictionary is in the following format:
 
     {
       "ResultData": {
         "TotalUniqueEmailsSubmitted": 3,
         "TotalExistingSubscribers": 2,
         "TotalNewSubscribers": 0,
         "DuplicateEmailsInSubmission": [],
         "FailureDetails": [
           {
             "EmailAddress": "example+1@example",
             "Code": 1,
             "Message": "Invalid Email Address"
           }
         ]
       },
       "Code": 210,
       "Message": "Subscriber Import had some failures"
     }
 
 @param errorHandler Error callback
 */
- (void)importSubscribersToListWithID:(NSString *)listID
                       subscriberData:(NSArray *)subscriberData
                    shouldResubscribe:(BOOL)shouldResubscribe
                    completionHandler:(void (^)(NSDictionary* responseObject))completionHandler
                         errorHandler:(CSAPIErrorHandler)errorHandler;

@end
