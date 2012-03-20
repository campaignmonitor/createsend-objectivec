//
//  CSAPI+Campaigns.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"
#import "CSPaginatedResult.h"

@interface CSAPI (Campaigns)

/**
 Create a draft campaign ready to be tested as a preview or sent.
 
     http://www.campaignmonitor.com/api/campaigns/#creating_a_campaign
 
 @param clientID The ID of the client for whom the campaign should be created.
 @param name Name of the campaign
 @param subject Subject of the email
 @param fromName Senders name
 @param fromEmail Senders email address
 @param replyTo Email address to use in the Reply-To field
 @param HTMLURLString URL for the HTML content
 @param textURLString URL for the plain text content
 @param listIDs Array of list IDs
 @param segmentIDs Array of segment IDs
 @param completionHandler Completion callback, with ID of the successfully created campaign as the only argument
 @param errorHandler Error callback
 */
- (void)createCampaignWithClientID:(NSString *)clientID
                              name:(NSString *)name
                           subject:(NSString *)subject
                          fromName:(NSString *)fromName
                         fromEmail:(NSString *)fromEmail
                           replyTo:(NSString *)replyTo
                     HTMLURLString:(NSString *)HTMLURLString
                     textURLString:(NSString *)textURLString
                           listIDs:(NSArray *)listIDs
                        segmentIDs:(NSArray *)segmentIDs
                 completionHandler:(void (^)(NSString* campaignID))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Delete a campaign from your account
 
     http://www.campaignmonitor.com/api/campaigns/#deleting_a_campaign
 
 @param campaignID The ID of the campaign to delete
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)deleteCampaignWithID:(NSString *)campaignID
           completionHandler:(void (^)(void))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Schedule a draft campaign to be sent immediately
 
     http://www.campaignmonitor.com/api/campaigns/#sending_a_campaign
 
 @param campaignID The ID of the campaign to send
 @param emailAddress The email address that the confirmation email will be sent to
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)sendCampaignImmediatelyWithCampaignID:(NSString *)campaignID
                     confirmationEmailAddress:(NSString *)emailAddress
                            completionHandler:(void (^)(void))completionHandler
                                 errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Schedule a draft campaign to be sent at a custom date and time in the future
 
     http://www.campaignmonitor.com/api/campaigns/#sending_a_campaign
 
 @param campaignID The ID of the campaign to send
 @param emailAddress The email address that the confirmation email will be sent to
 @param sendDate The date and time the campaign should be scheduled to be sent
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)sendCampaignWithCampaignID:(NSString *)campaignID
          confirmationEmailAddress:(NSString *)emailAddress
                          sendDate:(NSDate *)sendDate
                 completionHandler:(void (^)(void))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a basic summary of the results of a sent campaign
 
     http://www.campaignmonitor.com/api/campaigns/#campaign_summary
 
 @param campaignID The ID of the campaign you want data for
 @param completionHandler Completion callback, with a dictionary of campaign summary data as the only argument
 @param errorHandler Error callback
 */
- (void)getCampaignSummaryWithCampaignID:(NSString *)campaignID
               completionHandler:(void (^)(NSDictionary* summaryData))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get the lists and segments a campaign was sent to
 
     http://www.campaignmonitor.com/api/campaigns/#campaign_listsandsegments
 
 @param campaignID The ID of the campaign you want data for
 @param completionHandler Completion callback.
 
 The first argument is an array of lists. Each list is a dictionary with the following format:
 
     {
       "ListID": "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1",
       "Name:" : "The List Name"
     }
 
 The second argument is an array of segments. Each segment is a dictionary with the following format:
     
     {
       "ListID:    "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1",
       "SegmentID: "c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3",
       "Title:     "The Segment Title"
     }
 
 @param errorHandler Error callback
 */
- (void)getCampaignListsAndSegmentsWithCampaignID:(NSString *)campaignID
                                completionHandler:(void (^)(NSArray* lists, NSArray* segments))completionHandler
                                     errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all the subscribers that a given campaign was sent to
 
     http://www.campaignmonitor.com/api/campaigns/#campaign_recipients
 
 @param campaignID The ID of the campaign you want data for. You can get the ID by calling getSentCampaignsWithClientID:completionHandler:errorHandler:.
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are in the following format:
 
     {
       "EmailAddress": "example+1@example.com",
       "ListID":       "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1"
     }
 
 @param errorHandler Error callback
 */
- (void)getCampaignRecipientsWithCampaignID:(NSString *)campaignID
                                       page:(NSUInteger)page
                                   pageSize:(NSUInteger)pageSize
                                 orderField:(NSString *)orderField
                                  ascending:(BOOL)ascending
                          completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all the subscribers who bounced for a given campaign
 
     http://www.campaignmonitor.com/api/campaigns/#campaign_bouncelist
 
 @param campaignID The ID of the campaign you want data for. You can get the ID by calling getSentCampaignsWithClientID:completionHandler:errorHandler:.
 @param date Bounces after the specified date will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are in the following format:
 
     {
       "EmailAddress": "example+1@example.com",
       "ListID":       "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1",
       "BounceType":   "Hard",
       "Date":         "2009-05-18 16:45:00",
       "Reason":       "Invalid Email Address"
     }
 
 `BounceType` can be either `Hard` or `Soft`.
 
 @param errorHandler Error callback
 */
- (void)getCampaignBouncesWithCampaignID:(NSString *)campaignID
                                    date:(NSDate *)date
                                    page:(NSUInteger)page
                                pageSize:(NSUInteger)pageSize
                              orderField:(NSString *)orderField
                               ascending:(BOOL)ascending
                       completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                            errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all subscribers who opened the email for a given campaign
 
     http://www.campaignmonitor.com/api/campaigns/#campaign_openslist
 
 @param campaignID The ID of the campaign you want data for. You can get the ID by calling getSentCampaignsWithClientID:completionHandler:errorHandler:.
 @param date Opens after the specified date will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are in the following format:
 
     {
       "EmailAddress": "example+1@example.com",
       "ListID":       "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1",
       "Date":         "2009-05-18 16:45:00",
       "IPAddress":    "192.168.0.1"
     }
 
 @param errorHandler Error callback
 */
- (void)getCampaignOpensWithCampaignID:(NSString *)campaignID
                                  date:(NSDate *)date
                                  page:(NSUInteger)page
                              pageSize:(NSUInteger)pageSize
                            orderField:(NSString *)orderField
                             ascending:(BOOL)ascending
                     completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all subscribers who clicked a link in the email for a given campaign
 
     http://www.campaignmonitor.com/api/campaigns/#campaign_clickslist
 
 @param campaignID The ID of the campaign you want data for. You can get the ID by calling getSentCampaignsWithClientID:completionHandler:errorHandler:.
 @param date Clicks after the specified date will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are in the following format:
 
     {
       "EmailAddress": "example+1@example.com",
       "URL":          "http://www.myexammple.com/index.html",
       "ListID":       "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1",
       "Date":         "2009-05-18 16:45:00",
       "IPAddress":    "192.168.0.1"
     }
 
 @param errorHandler Error callback
 */
- (void)getCampaignClicksWithCampaignID:(NSString *)campaignID
                                   date:(NSDate *)date
                                   page:(NSUInteger)page
                               pageSize:(NSUInteger)pageSize
                             orderField:(NSString *)orderField
                              ascending:(BOOL)ascending
                      completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all subscribers who unsubscribed from the email for a given campaign
 
     http://www.campaignmonitor.com/api/campaigns/#campaign_unsubscribeslist
 
 @param campaignID The ID of the campaign you want data for. You can get the ID by calling getSentCampaignsWithClientID:completionHandler:errorHandler:.
 @param date Unsubscribes after the specified date will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are in the following format:
 
     {
       "EmailAddress": "example+1@example.com",
       "ListID":       "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1",
       "Date":         "2009-05-18 16:45:00",
       "IPAddress":    "192.168.0.1"
     }
 
 @param errorHandler Error callback
 */
- (void)getCampaignUnsubscribesWithCampaignID:(NSString *)campaignID
                                         date:(NSDate *)date
                                         page:(NSUInteger)page
                                     pageSize:(NSUInteger)pageSize
                                   orderField:(NSString *)orderField
                                    ascending:(BOOL)ascending
                            completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                                 errorHandler:(CSAPIErrorHandler)errorHandler;

@end
