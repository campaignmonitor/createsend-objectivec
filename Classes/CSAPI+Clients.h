//
//  CSAPI+Clients.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"
#import "CSClient.h"
#import "CSPaginatedResult.h"

/**
 Client-related APIs. See CSAPI for documentation of the other API categories.
 */
@interface CSAPI (Clients)

/**
 Create a new client in your account with basic information and no access to the application.
 
     http://www.campaignmonitor.com/api/clients/#creating_a_client
 
 @param companyName Company name of the new client
 @param contactName Contact name of the new client
 @param emailAddress Primary email address of the new client
 @param country Country (see getCountries:errorHandler:)
 @param timezone Timezone (see getTimezones:errorHandler:)
 @param completionHandler Completion callback, with ID of the successfully created client as the only argument
 @param errorHandler Error callback
 */
- (void)createClientWithCompanyName:(NSString *)companyName
                        contactName:(NSString *)contactName
                       emailAddress:(NSString *)emailAddress
                            country:(NSString *)country
                           timezone:(NSString *)timezone
                  completionHandler:(void (^)(NSString* clientID))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Update the basic account details for an existing client in your account.
 
     http://www.campaignmonitor.com/api/clients/#setting_basic_details
 
 @param clientID The ID of the client for which basic details should be set
 @param companyName Company name of the client
 @param contactName Contact name of the client
 @param emailAddress Primary email address of the client
 @param country Country (see getCountries:errorHandler:)
 @param timezone Timezone (see getTimezones:errorHandler:)
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)updateClientWithClientID:(NSString *)clientID
                     companyName:(NSString *)companyName
                     contactName:(NSString *)contactName
                    emailAddress:(NSString *)emailAddress
                         country:(NSString *)country
                        timezone:(NSString *)timezone
               completionHandler:(void (^)(void))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Delete an existing client from your account.
 
     http://www.campaignmonitor.com/api/clients/#deleting_a_client
 
 @param clientID The ID of the client to be deleted
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)deleteClientWithID:(NSString *)clientID
         completionHandler:(void (^)(void))completionHandler
              errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Set the username, password & level of access this client should have for their account.
 
     http://www.campaignmonitor.com/api/clients/#setting_access_details
 
 @param clientID The ID of the client for which access settings should be set
 @param username New username
 @param password  New password
 @param accessLevel Access level as per documentation listed in discussion
 @param completionHandler Completion callback
 @param errorHandler Error callback
 
 @see [CSAPI(Clients) setClientAccessWithClientID:accessLevel:completionHandler:errorHandler:]
 */
- (void)setClientAccessWithClientID:(NSString *)clientID
                           username:(NSString *)username
                           password:(NSString *)password
                        accessLevel:(NSUInteger)accessLevel
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Set the level of access this client should have for their account.
 
     http://www.campaignmonitor.com/api/clients/#setting_access_details
 
 @param clientID The ID of the client for which access settings should be set
 @param accessLevel Access level as per documentation listed in discussion
 @param completionHandler Completion callback
 @param errorHandler Error callback
 
 @see [CSAPI(Clients) setClientAccessWithClientID:username:password:accessLevel:completionHandler:errorHandler:]
 */
- (void)setClientAccessWithClientID:(NSString *)clientID
                        accessLevel:(NSUInteger)accessLevel
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Set if a client can pay for their own campaigns and design and spam tests using
 our PAYG billing. Set the mark-up percentage on each type of fee, and if the
 client can purchase their own email credits to access bulk discounts.
 
     http://www.campaignmonitor.com/api/clients/#setting_payg_billing
 
 @param clientID The ID of the client for which PAYG billing settings should be set
 @param currency The currency to bill in. Values accepted are:
 
 - `USD` (US Dollars)
 - `GBP` (Great Britain Pounds)
 - `EUR` (Euros)
 - `CAD` (Canadian Dollars)
 - `AUD` (Australian Dollars)
 - `NZD` (New Zealand Dollars)
 
 @param canPurchaseCredits Whether or not the client can purchase their own email credits to access bulk discounts
 @param clientPays Whether or not the client can pay for their own campaigns and design and spam tests
 @param markupPercentage Markup as a percentage
 @param markupOnDelivery Markup in the major unit for the specified currency (e.g. `6.5f` means $6.50)
 @param markupPerRecipient Markup in the minor unit for the specified currency (e.g. `6.5f` means 6.5 cents)
 @param markupOnDesignSpamTest Markup in the major unit for the specified currency (e.g. `6.5f` means $6.50)
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)setClientPAYGBillingSettingsWithClientID:(NSString *)clientID
                                        currency:(NSString *)currency
                              canPurchaseCredits:(BOOL)canPurchaseCredits
                                      clientPays:(BOOL)clientPays
                                markupPercentage:(float)markupPercentage
                                markupOnDelivery:(float)markupOnDelivery
                              markupPerRecipient:(float)markupPerRecipient
                          markupOnDesignSpamTest:(float)markupOnDesignSpamTest
                               completionHandler:(void (^)(void))completionHandler
                                    errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Set if a client can pay for their own campaigns and design and spam tests using
 our monthly billing. Set the currency they should pay in plus mark-up
 percentage that will apply to the base prices at each pricing tier.
 
     http://www.campaignmonitor.com/api/clients/#setting_monthly_billing
 
 @param clientID The ID of the client for which monthly billing settings should be set
 @param currency The currency to bill in. Values accepted are:
 
 - `USD` (US Dollars)
 - `GBP` (Great Britain Pounds)
 - `EUR` (Euros)
 - `CAD` (Canadian Dollars)
 - `AUD` (Australian Dollars)
 - `NZD` (New Zealand Dollars)
 
 @param clientPays Whether or not the client can pay for their own campaigns and design and spam tests
 @param markupPercentage Markup as a percentage
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)setClientMonthlyBillingWithClientID:(NSString *)clientID
                                   currency:(NSString *)currency
                                 clientPays:(BOOL)clientPays
                           markupPercentage:(float)markupPercentage
                          completionHandler:(void (^)(void))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of all the clients in your account, including their name & ID.
 
     http://www.campaignmonitor.com/api/account/#getting_your_clients
 
 @param completionHandler Completion callback, with an array of `CSClient` objects as the first and only argument
 @param errorHandler Error callback
 */
- (void)getClients:(void (^)(NSArray* clients))completionHandler
      errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get the complete details for a client including their API key, access level,
 contact details and billing settings.
 
     http://www.campaignmonitor.com/api/clients/#getting_a_client
 
 @param clientID The ID of the client to be retrieved
 @param completionHandler Completion callback, with a dictionary of client
 details as the first and only argument. The dictionary is in the following
 format:
 
     {
       "ApiKey": "639d8cc27198202f5fe6037a8b17a29a59984b86d3289bc9",
       "AccessDetails": {
         "Username": "clientone",
         "AccessLevel": 23
       },
       "BasicDetails": {
         "ClientID": "4a397ccaaa55eb4e6aa1221e1e2d7122",
         "CompanyName": "Client One",
         "ContactName": "Client One (contact)",
         "EmailAddress": "contact@example.com",
         "Country": "Australia",
         "TimeZone": "(GMT+10:00) Canberra, Melbourne, Sydney"
       },
       "BillingDetails": {
         "CanPurchaseCredits": true,
         "MarkupOnDesignSpamTest": 0.0,
         "ClientPays": true,
         "BaseRatePerRecipient": 1.0,
         "MarkupPerRecipient": 0.0,
         "MarkupOnDelivery": 0.0,
         "BaseDeliveryRate": 5.0,
         "Currency": "USD",
         "BaseDesignSpamTestRate": 5.0
       }
     }
 
 @param errorHandler Error callback
 */
- (void)getClientDetailsWithClientID:(NSString *)clientID
                   completionHandler:(void (^)(NSDictionary* clientData))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of all sent campaigns for a client.
 
     http://www.campaignmonitor.com/api/clients/#getting_client_campaigns
 
 @param clientID The ID of the client for which sent campaigns should be retrieved
 @param completionHandler Completion callback, with an array of campaign
 dictionaries as the first and only argument. Dictionaries are in the following
 format:
 
     {
       "WebVersionURL": "http://hello.createsend.com/t/r-765E86829575EE2C/",
       "CampaignID": "fc0ce7105baeaf97f47c99be31d02a91",
       "Subject": "Campaign One",
       "Name": "Campaign One",
       "SentDate": "2010-10-12 12:58:00",
       "TotalRecipients": 2245
     }
 
 @param errorHandler Error callback
 */
- (void)getSentCampaignsWithClientID:(NSString *)clientID
                   completionHandler:(void (^)(NSArray* campaigns))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of all currently scheduled campaigns for a client.
 
     http://www.campaignmonitor.com/api/clients/#getting_scheduled_campaigns
 
 @param clientID The ID of the client for which scheduled campaigns should be retrieved
 @param completionHandler Completion callback, with an array of campaign
 dictionaries as the first and only argument. Dictionaries are in the following
 format:
 
     {
       "DateScheduled": "2011-05-25 10:40:00",
       "ScheduledTimeZone": "(GMT+10:00) Canberra, Melbourne, Sydney",
       "CampaignID": "827dbbd2161ea9989fa11ad562c66937",
       "Name": "Magic Issue One",
       "Subject": "Magic Issue One",
       "DateCreated": "2011-05-24 10:37:00",
       "PreviewURL": "http://hello.createsend.com/t/r-DD543521A87C9B8B/"
     }
 
 @param errorHandler Error callback
 */
- (void)getScheduledCampaignsWithClientID:(NSString *)clientID
                        completionHandler:(void (^)(NSArray* campaigns))completionHandler
                             errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of all draft campaigns belonging to a client.
 
     http://www.campaignmonitor.com/api/clients/#getting_client_drafts
 
 @param clientID The ID of the client for which draft campaigns should be retrieved
 @param completionHandler Completion callback, with an array of campaign
 dictionaries as the first and only argument. Dictionaries are in the following
 format:
 
   {
     "CampaignID": "2e928e982065d92627139208c8c01db1",
     "Name": "Draft Two",
     "Subject": "Draft Two",
     "DateCreated": "2010-08-19 16:08:00",
     "PreviewURL": "http://hello.createsend.com/t/r-E97A7BB2E6983DA1/"
   }
 
 @param errorHandler Error callback
 */
- (void)getDraftCampaignsWithClientID:(NSString *)clientID
                    completionHandler:(void (^)(NSArray* campaigns))completionHandler
                         errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get all the subscriber lists that belong to a client.
 
     http://www.campaignmonitor.com/api/clients/#getting_client_lists
 
 @param clientID The ID of the client for which subscriber lists should be retrieved
 @param completionHandler Completion callback, with an array of list
 dictionaries as the first and only argument. Dictionaries are in the following
 format:
 
   {
     "ListID": "a58ee1d3039b8bec838e6d1482a8a965",
     "Name": "List One"
   }
 
 @param errorHandler Error callback
 */
- (void)getSubscriberListsWithClientID:(NSString *)clientID
                     completionHandler:(void (^)(NSArray* subscriberLists))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of all segments belonging to a particular client.
 
     http://www.campaignmonitor.com/api/clients/#getting_client_segments
 
 @param clientID The ID of the client for which segments should be retrieved
 @param completionHandler Completion callback, with an array of segment
 dictionaries as the first and only argument. Dictionaries are in the following
 format:
 
   {
     "ListID": "a58ee1d3039b8bec838e6d1482a8a965",
     "SegmentID": "46aa5e01fd43381863d4e42cf277d3a9",
     "Title": "Segment One"
   }
 
 @param errorHandler Error callback
 */ 
- (void)getSegmentsWithClientID:(NSString *)clientID
              completionHandler:(void (^)(NSArray* segments))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing the client's suppression list.
 
     http://www.campaignmonitor.com/api/clients/#getting_client_suppressionlist
 
 @param clientID The ID of the client for which the suppression list should be retrieved
 @param page The page to retrieve
 @param pageSize The number of records to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The field which should be used to order the result. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are in the following format:
 
   {
     "SuppressionReason": "Reason Unavailable",
     "EmailAddress": "subscriberone@example.com",
     "Date": "2010-10-25 13:04:15",
     "State": "Suppressed"
   }
 
 @param errorHandler Error callback
 */
- (void)getSuppressionListWithClientID:(NSString *)clientID
                                  page:(NSUInteger)page
                              pageSize:(NSUInteger)pageSize
                            orderField:(NSString *)orderField
                             ascending:(BOOL)ascending
                     completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of all templates belonging to a particular client.
 
     http://www.campaignmonitor.com/api/clients/#getting_client_templates
 
 @param clientID The ID of the client for which templates should be retrieved
 @param completionHandler Completion callback, with an array of segment
 dictionaries as the first and only argument. Dictionaries are in the following
 format:
 
   {
     "TemplateID": "5cac213cf061dd4e008de5a82b7a3621",
     "Name": "Template One",
     "PreviewURL": "http://preview.createsend.com/templates/publicpreview/01AF532CD8889B33?d=r",
     "ScreenshotURL": "http://preview.createsend.com/ts/r/14/833/263/14833263.jpg?0318092541"
   }
 
 @param errorHandler Error callback
 */
- (void)getTemplatesWithClientID:(NSString *)clientID
               completionHandler:(void (^)(NSArray* templates))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler;

@end
