//
//  CSAPI+Lists.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"

#import "CSList.h"
#import "CSCustomField.h"
#import "CSPaginatedResult.h"

@interface CSAPI (Lists)

/**
 Create a new list into which subscribers can be added or imported
 
     http://www.campaignmonitor.com/api/lists/#creating_a_list
 
 @param clientID The ID of the client for whom the list should be created
 @param title The title of the new list. Must be unique.
 @param unsubscribePage URL for the unsubscribe page
 @param confirmationSuccessPage URL for the subscription confirmation page
 @param shouldConfirmOptIn Whether or not subscriptions need to be confirmed
 @param completionHandler Completion callback, with the ID of the successfully created list
 @param errorHandler Error callback
 */
- (void)createListWithClientID:(NSString *)clientID
                         title:(NSString *)title
               unsubscribePage:(NSString *)unsubscribePage
       confirmationSuccessPage:(NSString *)confirmationSuccessPage
            shouldConfirmOptIn:(BOOL)shouldConfirmOptIn
             completionHandler:(void (^)(NSString* listID))completionHandler
                  errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Update the basic settings for any list in your account
 
     http://www.campaignmonitor.com/api/lists/#updating_a_list
 
 @param listID The ID of the list you want to update
 @param title The title of the new list. Must be unique.
 @param unsubscribePage URL for the unsubscribe page
 @param confirmationSuccessPage URL for the subscription confirmation page
 @param shouldConfirmOptIn Whether or not subscriptions need to be confirmed
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)updateListWithListID:(NSString *)listID
                       title:(NSString *)title
             unsubscribePage:(NSString *)unsubscribePage
     confirmationSuccessPage:(NSString *)confirmationSuccessPage
          shouldConfirmOptIn:(BOOL)shouldConfirmOptIn
           completionHandler:(void (^)(void))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get all the subscriber lists that belong to the given client
 
     http://www.campaignmonitor.com/api/clients/#getting_client_lists
 
 @param clientID The ID of the client for which the lists should be retrieved
 @param completionHandler Completion callback, with an array of lists as the only argument. Lists are in the following format:
 
     {
       "ListID": "a58ee1d3039b8bec838e6d1482a8a965",
       "Name":   "List One"
     }
 
 @param errorHandler Error callback
 */
- (void)getListsWithClientID:(NSString *)clientID
           completionHandler:(void (^)(NSArray* lists))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Deletes a subscriber list from your account
 
     http://www.campaignmonitor.com/api/lists/#deleting_a_list
 
 @param listID The ID of the list you want to delete
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)deleteListWithID:(NSString *)listID
       completionHandler:(void (^)(void))completionHandler
            errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a basic summary for a list in your accout
 
     http://www.campaignmonitor.com/api/lists/#getting_list_details
 
 @param listID The ID of the list you want the details for
 @param completionHandler Completion callback, with a `CSList` as the only argument.
 @param errorHandler Error callback
 */
- (void)getListDetailsWithListID:(NSString *)listID
               completionHandler:(void (^)(CSList* list))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get comprehensive summary statistics for a list in your account
 
     http://www.campaignmonitor.com/api/lists/#getting_list_stats
 
 @param listID The ID of the list you want the statistics for
 @param completionHandler Completion callback, with a dictionary of statistics as the only argument. The statistics dictionary is in the following format:
 
     {
       "TotalActiveSubscribers": 6,
       "NewActiveSubscribersToday": 0,
       "NewActiveSubscribersYesterday": 8,
       "NewActiveSubscribersThisWeek": 8,
       "NewActiveSubscribersThisMonth": 8,
       "NewActiveSubscribersThisYear": 8,
       "TotalUnsubscribes": 2,
       "UnsubscribesToday": 0,
       "UnsubscribesYesterday": 2,
       "UnsubscribesThisWeek": 2,
       "UnsubscribesThisMonth": 2,
       "UnsubscribesThisYear": 2,
       "TotalDeleted": 0,
       "DeletedToday": 0,
       "DeletedYesterday": 0,
       "DeletedThisWeek": 0,
       "DeletedThisMonth": 0,
       "DeletedThisYear": 0,
       "TotalBounces": 0,
       "BouncesToday": 0,
       "BouncesYesterday": 0,
       "BouncesThisWeek": 0,
       "BouncesThisMonth": 0,
       "BouncesThisYear": 0
     }
 
 @param errorHandler Error callback
 */
- (void)getListStatisticsWithListID:(NSString *)listID
                  completionHandler:(void (^)(NSDictionary* listStatisticsData))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get all list segments for a list in your account
 
     http://www.campaignmonitor.com/api/lists/#getting_list_segments
 
 @param listID The ID of the list you want the segments for
 @param completionHandler Completion callback, with an array of segments as the only argument. Segments are dictionaries in the following format:
 
     {
       "ListID": "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1",
       "SegmentID": "b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1",
       "Title": "Segment One"
     }
 
 @param errorHandler Error callback
 */
- (void)getListSegmentsWithListID:(NSString *)listID
                completionHandler:(void (^)(NSArray* listSegments))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all the active subscribers for a given list
 
     http://www.campaignmonitor.com/api/lists/#getting_active_subscribers
 
 @param listID The ID of the list you want the active subscribers for
 @param date Subscribers which became active on or after the date specified will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are in the following format:
 
     {
       "EmailAddress": "subs+7t8787Y@example.com",
       "Name": "Person One",
       "Date": "2010-10-25 10:28:00",
       "State": "Active",
       "CustomFields": [
         {
           "Key": "website",
           "Value": "http://example.com"
         },
         {
           "Key": "age",
           "Value": "24"
         },
         {
           "Key": "subscription date",
           "Value": "2010-03-09"
         }
       ]
     }
 
 @param errorHandler Error callback
 */
- (void)getActiveSubscribersWithListID:(NSString *)listID
                                  date:(NSDate *)date
                                  page:(NSUInteger)page
                              pageSize:(NSUInteger)pageSize
                            orderField:(NSString *)orderField
                             ascending:(BOOL)ascending
                     completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all the unsubscribed subscribers for a given list
 
     http://www.campaignmonitor.com/api/lists/#getting_unsubscribed_subscribers
 
 @param listID The ID of the list you want the unsubscribed subscribers for
 @param date Subscribers which unsubscribed on or after the date specified will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are in the following format:
 
     {
       "EmailAddress": "subscriber@example.com",
       "Name": "Unsub One",
       "Date": "2010-10-25 13:11:00",
       "State": "Unsubscribed",
       "CustomFields": []
     }
 
 @param errorHandler Error callback
 */
- (void)getUnsubscribedSubscribersWithListID:(NSString *)listID
                                        date:(NSDate *)date
                                        page:(NSUInteger)page
                                    pageSize:(NSUInteger)pageSize
                                  orderField:(NSString *)orderField
                                   ascending:(BOOL)ascending
                           completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all the bounced subscribers for a given list
 
     http://www.campaignmonitor.com/api/lists/#getting_bounced_subscribers
 
 @param listID The ID of the list you want the bounced subscribers for
 @param date Subscribers which bounced on or after the date specified will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are in the following format:
 
     {
       "EmailAddress": "bouncedsubscriber@example.com",
       "Name": "Bounced One",
       "Date": "2010-10-25 13:11:00",
       "State": "Bounced",
       "CustomFields": []
     }
 
 @param errorHandler Error callback
 */
- (void)getBouncedSubscribersWithListID:(NSString *)listID
                                   date:(NSDate *)date
                                   page:(NSUInteger)page
                               pageSize:(NSUInteger)pageSize
                             orderField:(NSString *)orderField
                              ascending:(BOOL)ascending
                      completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler;

# pragma mark - Custom Fields

/** @name Custom Fields */

/**
 Get all the custom fields for a given list in your account
 
     http://www.campaignmonitor.com/api/lists/#getting_list_custom_fields
 
 @param listID The ID of the list you want the custom fields for
 @param completionHandler Completion callback, with an array of custom field dictionaries as the first and only argument. Custom fields dictionaries are in the following format:
 
     {
       "FieldName":    "newsletterformat",
       "Key":          "[newsletterformat]",
       "DataType":     "MultiSelectOne",
       "FieldOptions": [
         "HTML",
         "Text"
       ]
     }
 
 @param errorHandler Error callback
 */
- (void)getCustomFieldsWithListID:(NSString *)listID
                completionHandler:(void (^)(NSArray* customFields))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Create a new custom field for a given list into which custom subscriber data can be added
 
     http://www.campaignmonitor.com/api/lists/#creating_a_custom_field
 
 @param listID The ID of the list you want to create the custom field on
 @param customField A `CSCustomField` representing the field you'd like to create. See [CSCustomField customFieldWithName:dataType:options:] and [CSCustomField customFieldWithName:dataType:].
 @param completionHandler Completion callback, with the key of the newly created custom field as the first and only argument
 @param errorHandler Error callback
 */
- (void)createCustomFieldWithListID:(NSString *)listID
                        customField:(CSCustomField *)customField
                  completionHandler:(void (^)(NSString* customFieldKey))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Update the available options for existing multi-select fields in a given list
 
     http://www.campaignmonitor.com/api/lists/#updating_custom_field_options
 
 @param listID The ID of the list containing the custom key you'd like to update
 @param fieldKey The custom field key. You can get the key of a custom field by calling getCustomFieldsWithListID:completionHandler:errorHandler:.
 @param options An array of strings enumerating the available options
 @param keepExisting Whether or not to keep the existing options. If `NO`, existing options are replaced
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)updateCustomFieldWithListID:(NSString *)listID
                     customFieldKey:(NSString *)fieldKey
                            options:(NSArray *)options
                       keepExisting:(BOOL)keepExisting
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;
/**
 Deletes a specific custom field from a list
 
     http://www.campaignmonitor.com/api/lists/#deleting_a_custom_field
 
 @param listID The ID of the list containing the custom field you'd like to delete
 @param fieldKey The custom field key. You can get the key of a custom field by calling getCustomFieldsWithListID:completionHandler:errorHandler:.
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)deleteCustomFieldWithListID:(NSString *)listID
                     customFieldKey:(NSString *)fieldKey
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

# pragma mark - Webhooks

/** @name Web Hooks */

/**
 Create a new webhook for the provided list
 
     http://www.campaignmonitor.com/api/lists/#creating_a_webhook
 
 @param listID The ID of the list for which the webhook should be created
 @param events The events you would like to trigger a call to your webhook. Valid events are `Subscribe`, `Deactivate` and `Update`.
 @param URLString The URL endpoint you'd like called when an event occurs
 @param payloadFormat The payload format you'd like to receive at the `URLString` endpoint. Valid payload formats are `json` and `xml`.
 @param completionHandler Completion callback, with the ID of the newly created webhook as the first and only argument
 @param errorHandler Error callback
 */
- (void)createWebhookWithListID:(NSString *)listID
                         events:(NSArray *)events
                      URLString:(NSString *)URLString
                  payloadFormat:(NSString *)payloadFormat
              completionHandler:(void (^)(NSString* webhookID))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get all the webhooks that have been created for a given list
 
     http://www.campaignmonitor.com/api/lists/#getting_list_webhooks
 
 @param listID The ID of the subscriber list for which webhooks should be retrieved
 @param completionHandler Completion callback, with an array of webhook dictionaries in the following format:
 
     {
       "WebhookID":     "ee1b3864e5ca61618q98su98qsu9q",
       "Url":           "http://example.com/subscribe",
       "Status":        "Active",
       "PayloadFormat": "json"
       "Events":        [
         "Subscribe"
       ]
     }
 
 @param errorHandler Error callback
 */
- (void)getWebhooksWithListID:(NSString *)listID
            completionHandler:(void (^)(NSArray* webhooks))completionHandler
                 errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Attempt to post a webhook payload to the endpoint specified by a webhook
 
     http://www.campaignmonitor.com/api/lists/#testing_a_webhook
 
 @param listID The ID of the subscriber list to which the webhook belongs
 @param webhookID The ID of the webhook for which the test should be sent
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)testWebhookWithListID:(NSString *)listID
                    webhookID:(NSString *)webhookID
            completionHandler:(void (^)(void))completionHandler
                 errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Delete a specific webhook associated with a list
 
     http://www.campaignmonitor.com/api/lists/#deleting_a_webhook
 
 @param listID The ID of the list from which the webhook should be deleted
 @param webhookID The ID of the webhook you'd like to delete
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)deleteWebhookWithListID:(NSString *)listID
                      webhookID:(NSString *)webhookID
              completionHandler:(void (^)(void))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Activate a webhook associated with a list
 
     http://www.campaignmonitor.com/api/lists/#activating_a_webhook
 
 @param listID The ID of the list with which the webhook you want to activate is associated
 @param webhookID The ID of the webhook to be activated
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)activateWebhookWithListID:(NSString *)listID
                        webhookID:(NSString *)webhookID
                completionHandler:(void (^)(void))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Deactivate a webhook associated with a list
 
     http://www.campaignmonitor.com/api/lists/#deactivating_a_webhook
 
 @param listID The ID of the list with which the webhook you want to deactivate is associated
 @param webhookID The ID of the webhook to be deactivated
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)deactivateWebhookWithListID:(NSString *)listID
                          webhookID:(NSString *)webhookID
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

@end
