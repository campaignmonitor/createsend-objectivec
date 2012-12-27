//
//  CSAPI+Lists.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSAPI.h"
#import "CSList.h"
#import "CSCustomField.h"
#import "CSPaginatedResult.h"
#import "CSSubscriber.h"

extern NSString * const CSAPIListStatisticTotalActiveSubscribersKey;
extern NSString * const CSAPIListStatisticNewActiveSubscribersTodayKey;
extern NSString * const CSAPIListStatisticNewActiveSubscribersYesterdayKey;
extern NSString * const CSAPIListStatisticNewActiveSubscribersThisWeekKey;
extern NSString * const CSAPIListStatisticNewActiveSubscribersThisMonthKey;
extern NSString * const CSAPIListStatisticNewActiveSubscribersThisYearKey;
extern NSString * const CSAPIListStatisticTotalUnsubscribesKey;
extern NSString * const CSAPIListStatisticUnsubscribesTodayKey;
extern NSString * const CSAPIListStatisticUnsubscribesYesterdayKey;
extern NSString * const CSAPIListStatisticUnsubscribesThisWeekKey;
extern NSString * const CSAPIListStatisticUnsubscribesThisMonthKey;
extern NSString * const CSAPIListStatisticUnsubscribesThisYearKey;
extern NSString * const CSAPIListStatisticTotalDeletedKey;
extern NSString * const CSAPIListStatisticDeletedTodayKey;
extern NSString * const CSAPIListStatisticDeletedYesterdayKey;
extern NSString * const CSAPIListStatisticDeletedThisWeekKey;
extern NSString * const CSAPIListStatisticDeletedThisMonthKey;
extern NSString * const CSAPIListStatisticDeletedThisYearKey;
extern NSString * const CSAPIListStatisticTotalBouncesKey;
extern NSString * const CSAPIListStatisticBouncesTodayKey;
extern NSString * const CSAPIListStatisticBouncesYesterdayKey;
extern NSString * const CSAPIListStatisticBouncesThisWeekKey;
extern NSString * const CSAPIListStatisticBouncesThisMonthKey;
extern NSString * const CSAPIListStatisticBouncesThisYearKey;

extern NSString * const CSAPIOrderByEmail;
extern NSString * const CSAPIOrderByName;
extern NSString * const CSAPIOrderByDate;

extern NSString * const CSAPIWebhookPayloadFormatJSON;
extern NSString * const CSAPIWebhookPayloadFormatXML;

/**
 List-related APIs. See CSAPI for documentation of the other API categories.
 */
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
             completionHandler:(void (^)(NSString *listID))completionHandler
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
 Deletes a subscriber list from your account
 
 http://www.campaignmonitor.com/api/lists/#deleting_a_list
 
 @param listID The ID of the list you want to delete
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)deleteListWithID:(NSString *)listID completionHandler:(void (^)(void))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a basic summary for a list in your account
 
 http://www.campaignmonitor.com/api/lists/#list_details
 
 @param listID The ID of the list you want the details for
 @param completionHandler Completion callback, with a `CSList` as the only argument.
 @param errorHandler Error callback
 */
- (void)getListDetailsWithListID:(NSString *)listID completionHandler:(void (^)(CSList *list))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get comprehensive summary statistics for a list in your account
 
 http://www.campaignmonitor.com/api/lists/#list_stats
 
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
- (void)getListStatisticsWithListID:(NSString *)listID completionHandler:(void (^)(NSDictionary *listStatistics))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get all list segments for a list in your account
 
 http://www.campaignmonitor.com/api/lists/#list_segments
 
 @param listID The ID of the list you want the segments for
 @param completionHandler Completion callback, with an array of `CSSegment` objects as the only argument.
 @param errorHandler Error callback
 */
- (void)getListSegmentsWithListID:(NSString *)listID completionHandler:(void (^)(NSArray *listSegments))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all the active subscribers for a given list
 
 http://www.campaignmonitor.com/api/lists/#active_subscribers
 
 @param listID The ID of the list you want the active subscribers for
 @param date Subscribers which became active on or after the date specified will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are `CSSubscriber`.
 @param errorHandler Error callback
 */
- (void)getActiveSubscribersWithListID:(NSString *)listID
                                  date:(NSDate *)date
                                  page:(NSUInteger)page
                              pageSize:(NSUInteger)pageSize
                            orderField:(NSString *)orderField
                             ascending:(BOOL)ascending
                     completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all the unconfirmed subscribers for a given list
 (those subscribers who have subscribed to a confirmed-opt-in list, but have not
 confirmed their subscription).
 
 http://www.campaignmonitor.com/api/lists/#unconfirmed_subscribers
 
 @param listID The ID of the list you want the unconfirmed subscribers for
 @param date Subscribers who subscribed on or after the date specified will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are `CSSubscriber`.
 @param errorHandler Error callback
 */
- (void)getUnconfirmedSubscribersWithListID:(NSString *)listID
                                       date:(NSDate *)date
                                       page:(NSUInteger)page
                                   pageSize:(NSUInteger)pageSize
                                 orderField:(NSString *)orderField
                                  ascending:(BOOL)ascending
                          completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all the unsubscribed subscribers for a given list
 
 http://www.campaignmonitor.com/api/lists/#unsubscribed_subscribers
 
 @param listID The ID of the list you want the unsubscribed subscribers for
 @param date Subscribers which unsubscribed on or after the date specified will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are `CSSubscriber`.
 @param errorHandler Error callback
 */
- (void)getUnsubscribedSubscribersWithListID:(NSString *)listID
                                        date:(NSDate *)date
                                        page:(NSUInteger)page
                                    pageSize:(NSUInteger)pageSize
                                  orderField:(NSString *)orderField
                                   ascending:(BOOL)ascending
                           completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all the deleted subscribers for a given list
 
 http://www.campaignmonitor.com/api/lists/#deleted_subscribers
 
 @param listID The ID of the list you want the deleted subscribers for
 @param date Subscribers which were deleted on or after the date specified will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are `CSSubscriber`.
 @param errorHandler Error callback
 */
- (void)getDeletedSubscribersWithListID:(NSString *)listID
                                        date:(NSDate *)date
                                        page:(NSUInteger)page
                                    pageSize:(NSUInteger)pageSize
                                  orderField:(NSString *)orderField
                                   ascending:(BOOL)ascending
                           completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all the bounced subscribers for a given list
 
 http://www.campaignmonitor.com/api/lists/#bounced_subscribers
 
 @param listID The ID of the list you want the bounced subscribers for
 @param date Subscribers which bounced on or after the date specified will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are `CSSubscriber`.
 @param errorHandler Error callback
 */
- (void)getBouncedSubscribersWithListID:(NSString *)listID
                                   date:(NSDate *)date
                                   page:(NSUInteger)page
                               pageSize:(NSUInteger)pageSize
                             orderField:(NSString *)orderField
                              ascending:(BOOL)ascending
                      completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler;

/** @name Custom Fields */

/**
 Get all the custom fields for a given list in your account
 
 http://www.campaignmonitor.com/api/lists/#list_custom_fields
 
 @param listID The ID of the list you want the custom fields for
 @param completionHandler Completion callback, with an array of `CSCustomField` objects as the first and only argument
 @param errorHandler Error callback
 */
- (void)getCustomFieldsWithListID:(NSString *)listID completionHandler:(void (^)(NSArray *customFields))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

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
                  completionHandler:(void (^)(NSString *customFieldKey))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Update a custom field, setting the name and whether or not it is visible in
 the subscriber preference center. To update the options for the custom field
 you should use [CSAPI (Lists) updateCustomFieldOptionsWithListID:fieldKey:options:keepExisting:completionHandler:errorHandler:].

 http://www.campaignmonitor.com/api/lists/#updating_a_custom_field

 @param listID The ID of the list to which the custom field belongs
 @param customField A `CSCustomField` representing the field you'd like to update. See [CSCustomField customFieldWithName:dataType:options:] and [CSCustomField customFieldWithName:dataType:].
 @param completionHandler Completion callback, with the key of the updated custom field as the first and only argument
 @param errorHandler Error callback
 */
- (void)updateCustomFieldWithListID:(NSString *)listID
                        customField:(CSCustomField *)customField
                  completionHandler:(void (^)(NSString *customFieldKey))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Update the available options for a multi-select field in a given list
 
 http://www.campaignmonitor.com/api/lists/#updating_custom_field_options
 
 @param listID The ID of the list containing the custom key you'd like to update
 @param fieldKey The custom field key. You can get the key of a custom field by calling getCustomFieldsWithListID:completionHandler:errorHandler:.
 @param options An array of strings enumerating the available options
 @param keepExisting Whether or not to keep the existing options. If `NO`, existing options are replaced
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)updateCustomFieldOptionsWithListID:(NSString *)listID
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
              completionHandler:(void (^)(NSString *webhookID))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get all the webhooks that have been created for a given list
 
 http://www.campaignmonitor.com/api/lists/#list_webhooks
 
 @param listID The ID of the subscriber list for which webhooks should be retrieved
 @param completionHandler Completion callback, with an array of `CSWebhook` objects as the first and only argument
 @param errorHandler Error callback
 */
- (void)getWebhooksWithListID:(NSString *)listID completionHandler:(void (^)(NSArray *webhooks))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

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
