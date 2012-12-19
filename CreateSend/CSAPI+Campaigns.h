//
//  CSAPI+Campaigns.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSAPI.h"
#import "CSPaginatedResult.h"
#import "CSCampaign.h"
#import "CSCampaignBouncedRecipient.h"
#import "CSCampaignRecipient.h"
#import "CSCampaignRecipientClicked.h"
#import "CSCampaignSummary.h"
#import "CSCampaignEmailClient.h"
#import "CSList.h"
#import "CSSegment.h"

extern NSString * const CSAPICampaignPreviewPersonalizeFallback;
extern NSString * const CSAPICampaignPreviewPersonalizeRandom;

/**
 Campaign-related APIs. See CSAPI for documentation of the other API categories.
 */
@interface CSAPI (Campaigns)

/**
 Create a draft campaign ready to be tested as a preview or sent.
 
 http://www.campaignmonitor.com/api/campaigns/#creating_a_draft_campaign
 
 @param clientID The ID of the client for whom the campaign should be created.
 @param name Name of the campaign
 @param subject Subject of the email
 @param fromName Senders name
 @param fromEmail Senders email address
 @param replyTo Email address to use in the Reply-To field
 @param htmlURL URL for the HTML content
 @param textURL URL for the plain text content
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
                           htmlURL:(NSString *)htmlURL
                           textURL:(NSString *)textURL
                           listIDs:(NSArray *)listIDs
                        segmentIDs:(NSArray *)segmentIDs
                 completionHandler:(void (^)(NSString *campaignID))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Delete a campaign from your account
 
 http://www.campaignmonitor.com/api/campaigns/#deleting_a_campaign
 
 @param campaignID The ID of the campaign to delete
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)deleteCampaignWithID:(NSString *)campaignID completionHandler:(void (^)(void))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Schedule a draft campaign to be sent immediately
 
 http://www.campaignmonitor.com/api/campaigns/#sending_a_draft_campaign
 
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
 
 http://www.campaignmonitor.com/api/campaigns/#sending_a_draft_campaign
 
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
 Send a preview of any draft campaign to a number of email addresses you specify.
 You can also set how we should treat any personalization tags in your draft campaign.
 
 http://www.campaignmonitor.com/api/campaigns/#sending_a_campaign_preview
 
 @param campaignID The ID of the campaign to send
 @param recipients A collection of intended recipients of the campaign preview.
 @param personalize Option to control personalization of the campaign preview. Only relevant when the campaign actually includes personalization tags. Valid variations are:
 
 - Fallback (Use the fallback terms.)
 - Random (Choose a random recipient from the lists and segments allocated to the campaign.)
 - A specific email address (Use the personalisation details attached to the email address. Only valid if the subscriber is a recipient of the campaign. The address will not be sent a copy of the email.)
 
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)sendCampaignPreviewWithCampaignID:(NSString *)campaignID
                               recipients:(NSArray *)recipients
                              personalize:(NSString *)personalize
                        completionHandler:(void (^)(void))completionHandler
                             errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Cancels the sending of the campaign and moves it back into the drafts. If the campaign is already sent or in the process of sending, this operation will fail.
 
 http://www.campaignmonitor.com/api/campaigns/#unscheduling_a_campaign
 
 @param campaignID The ID of the campaign to be unscheduled.
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)unscheduleCampaignWithID:(NSString *)campaignID completionHandler:(void (^)(void))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a basic summary of the results of a sent campaign
 
 http://www.campaignmonitor.com/api/campaigns/#campaign_summary
 
 @param campaignID The ID of the campaign you want data for
 @param completionHandler Completion callback, with a `CSCampaignSummary` object as the only argument
 @param errorHandler Error callback
 */
- (void)getCampaignSummaryWithCampaignID:(NSString *)campaignID
                       completionHandler:(void (^)(CSCampaignSummary *campaignSummary))completionHandler
                            errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Gets the list of email clients used by subscribers to open the campaign.
 
 http://www.campaignmonitor.com/api/campaigns/#campaign_email_client_usage
 
 @param campaignID The ID of the campaign for which email client usage should be found.
 @param completionHandler Completion callback, with an array of `CSCampaignEmailClient` objects as the first and only argument
 @param errorHandler Error callback
 */
- (void)getCampaignEmailClientUsageWithCampaignID:(NSString *)campaignID
                                completionHandler:(void (^)(NSArray *campaignEmailClientUsage))completionHandler
                                     errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get the lists and segments a campaign was sent to
 
 http://www.campaignmonitor.com/api/campaigns/#campaign_lists_and_segments
 
 @param campaignID The ID of the campaign you want data for
 @param completionHandler Completion callback, with an array of `CSList` objects as the first argument and an array of `CSSegment` objects as the second argument
 @param errorHandler Error callback
 */
- (void)getCampaignListsAndSegmentsWithCampaignID:(NSString *)campaignID
                                completionHandler:(void (^)(NSArray *lists, NSArray *segments))completionHandler
                                     errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all the subscribers that a given campaign was sent to
 
 http://www.campaignmonitor.com/api/campaigns/#campaign_recipients
 
 @param campaignID The ID of the campaign you want data for. You can get the ID by calling getSentCampaignsWithClientID:completionHandler:errorHandler:.
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are `CSCampaignRecipient`
 @param errorHandler Error callback
 */
- (void)getCampaignRecipientsWithCampaignID:(NSString *)campaignID
                                       page:(NSUInteger)page
                                   pageSize:(NSUInteger)pageSize
                                 orderField:(NSString *)orderField
                                  ascending:(BOOL)ascending
                          completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all the subscribers who bounced for a given campaign
 
 http://www.campaignmonitor.com/api/campaigns/#campaign_bounces
 
 @param campaignID The ID of the campaign you want data for. You can get the ID by calling getSentCampaignsWithClientID:completionHandler:errorHandler:.
 @param date Bounces after the specified date will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are `CSCampaignBouncedRecipient`
 @param errorHandler Error callback
 */
- (void)getCampaignBouncesWithCampaignID:(NSString *)campaignID
                                    date:(NSDate *)date
                                    page:(NSUInteger)page
                                pageSize:(NSUInteger)pageSize
                              orderField:(NSString *)orderField
                               ascending:(BOOL)ascending
                       completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                            errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all subscribers who opened the email for a given campaign
 
 http://www.campaignmonitor.com/api/campaigns/#campaign_opens
 
 @param campaignID The ID of the campaign you want data for. You can get the ID by calling getSentCampaignsWithClientID:completionHandler:errorHandler:.
 @param date Opens after the specified date will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are `CSCampaignRecipient`
 @param errorHandler Error callback
 */
- (void)getCampaignOpensWithCampaignID:(NSString *)campaignID
                                  date:(NSDate *)date
                                  page:(NSUInteger)page
                              pageSize:(NSUInteger)pageSize
                            orderField:(NSString *)orderField
                             ascending:(BOOL)ascending
                     completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all subscribers who clicked a link in the email for a given campaign
 
 http://www.campaignmonitor.com/api/campaigns/#campaign_clicks
 
 @param campaignID The ID of the campaign you want data for. You can get the ID by calling getSentCampaignsWithClientID:completionHandler:errorHandler:.
 @param date Clicks after the specified date will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are `CSCampaignRecipientClicked`:
 @param errorHandler Error callback
 */
- (void)getCampaignClicksWithCampaignID:(NSString *)campaignID
                                   date:(NSDate *)date
                                   page:(NSUInteger)page
                               pageSize:(NSUInteger)pageSize
                             orderField:(NSString *)orderField
                              ascending:(BOOL)ascending
                      completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all subscribers who unsubscribed from the email for a given campaign
 
 http://www.campaignmonitor.com/api/campaigns/#campaign_unsubscribes
 
 @param campaignID The ID of the campaign you want data for. You can get the ID by calling getSentCampaignsWithClientID:completionHandler:errorHandler:.
 @param date Unsubscribes after the specified date will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are `CSCampaignRecipient`:
 @param errorHandler Error callback
 */
- (void)getCampaignUnsubscribesWithCampaignID:(NSString *)campaignID
                                         date:(NSDate *)date
                                         page:(NSUInteger)page
                                     pageSize:(NSUInteger)pageSize
                                   orderField:(NSString *)orderField
                                    ascending:(BOOL)ascending
                            completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                                 errorHandler:(CSAPIErrorHandler)errorHandler;

@end
