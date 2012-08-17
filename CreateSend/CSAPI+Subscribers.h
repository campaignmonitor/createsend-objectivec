//
//  CSAPI+Subscribers.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSAPI.h"
#import "CSSubscriber.h"
#import "CSSubscriberHistoryItem.h"
#import "CSSubscriberImportResult.h"

extern NSString * const CSAPIErrorSubscriberImportResultKey;

/**
 Subscriber-related APIs. See CSAPI for documentation of the other API categories.
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
 @param customFields An array of `CSCustomField` objects
 @param completionHandler Completion callback, with the email address of the new subscriber as the first and only argument
 @param errorHandler Error callback
 */
- (void)subscribeToListWithID:(NSString *)listID
                 emailAddress:(NSString *)emailAddress
                         name:(NSString *)name
            shouldResubscribe:(BOOL)shouldResubscribe
                 customFields:(NSArray *)customFields
            completionHandler:(void (^)(NSString *subscribedAddress))completionHandler
                 errorHandler:(CSAPIErrorHandler)errorHandler;
/**
 Update an existing subscriber, including email address, name, and custom field data if supplied.
 
 http://www.campaignmonitor.com/api/subscribers/#updating_a_subscriber
 
 @param listID The ID of the subscriber list containing the subscriber you'd like to update
 @param currentEmailAddress Existing email address of the subscriber
 @param newEmailAddress New email address of the subscriber
 @param name New name of the subscriber
 @param shouldResubscribe Whether or not to resubscribe inactive subscribers
 @param customFields An array of `CSCustomField` objects to update
 @param completionHandler Coompletion callback
 @param errorHandler Error callback
 */
- (void)updateSubscriptionWithListID:(NSString *)listID
                 currentEmailAddress:(NSString *)currentEmailAddress
                     newEmailAddress:(NSString *)newEmailAddress
                                name:(NSString *)name
                   shouldResubscribe:(BOOL)shouldResubscribe
                        customFields:(NSArray *)customFields
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
 
 http://www.campaignmonitor.com/api/subscribers/#getting_a_subscribers_details
 
 @param listID The ID of the subscriber list to which the subscriber belongs
 @param emailAddress The ID of the subscriber whose details should be retrieved
 @param completionHandler Completion callback, with a `CSSubscriber` instance as the first and only argument.
 @param errorHandler Error callback
 */
- (void)getSubscriberDetailsWithListID:(NSString *)listID
                          emailAddress:(NSString *)emailAddress
                     completionHandler:(void (^)(CSSubscriber *subscriber))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of all campaigns or autoresponder emails, to which a subscriber has
 made some trackable action. For each campaign or autoresponder email, all
 actions are provided, including the event type, date and IP address from which
 the event occurred.
 
 http://www.campaignmonitor.com/api/subscribers/#getting_a_subscribers_history
 
 @param emailAddress The email address of the subscriber whose history should be retrieved
 @param listID The ID of the subscriber list to which the subscriber belongs
 @param completionHandler Completion callback, with an array of `CSSubscriberHistoryItem` objects
 @param errorHandler Error callback
 */
- (void)getSubscriberHistoryWithListID:(NSString *)listID
                          emailAddress:(NSString *)emailAddress
                     completionHandler:(void (^)(NSArray *historyItems))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Import many subscribers into a subscriber list, including any custom field data if provided.
 
 http://www.campaignmonitor.com/api/subscribers/#importing_many_subscribers
 
 @param listID The ID of the subscriber list to which the subscribers should be added
 @param subscribers An array of `CSSubscriber` objects
 @param shouldResubscribe Whether or not to resubscribe inactive subscribers
 @param shouldQueueSubscriptionBasedAutoresponders By default, Autoresponder emails that are based on the subscription date will not be sent for subscribers imported with this method. This can be overridden by setting the shouldQueueSubscriptionBasedAutoResponders parameter to true.
 @param shouldRestartSubscriptionBasedAutoresponders By default, resubscribed subscribers will not restart any subscription-based autoresponder sequences, but they will receive any remaining emails. However, if you specify the shouldRestartSubscriptionBasedAutoresponders input value as true, any sequences will be restarted.
 @param completionHandler Completion callback, with a `CSSubscriberImportResult` object containing information about the import.
 @param errorHandler Error callback
 */
- (void)importSubscribersToListWithID:(NSString *)listID
                          subscribers:(NSArray *)subscribers
                    shouldResubscribe:(BOOL)shouldResubscribe
shouldQueueSubscriptionBasedAutoresponders:(BOOL)shouldQueueSubscriptionBasedAutoresponders
shouldRestartSubscriptionBasedAutoresponders:(BOOL)shouldRestartSubscriptionBasedAutoresponders
                    completionHandler:(void (^)(CSSubscriberImportResult *subscriberImportResult))completionHandler
                         errorHandler:(CSAPIErrorHandler)errorHandler;
@end
