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
 Create a new client in your account.
 
     http://www.campaignmonitor.com/api/clients/#creating_a_client
 
 @param companyName Company name
 @param contactName Contact name
 @param emailAddress Email address
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

- (void)updateClientWithClientID:(NSString *)clientID
                     companyName:(NSString *)companyName
                     contactName:(NSString *)contactName
                    emailAddress:(NSString *)emailAddress
                         country:(NSString *)country
                        timezone:(NSString *)timezone
               completionHandler:(void (^)(void))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)deleteClientWithID:(NSString *)clientID
         completionHandler:(void (^)(void))completionHandler
              errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)setClientAccessWithClientID:(NSString *)clientID
                           username:(NSString *)username
                           password:(NSString *)password
                        accessLevel:(NSUInteger)accessLevel
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)setClientAccessWithClientID:(NSString *)clientID
                        accessLevel:(NSUInteger)accessLevel
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

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

- (void)setClientMonthlyBillingWithClientID:(NSString *)clientID
                                   currency:(NSString *)currency
                                 clientPays:(BOOL)clientPays
                           markupPercentage:(float)markupPercentage
                          completionHandler:(void (^)(void))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getClients:(void (^)(NSArray* clients))completionHandler
      errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getClientDetailsWithClientID:(NSString *)clientID
                   completionHandler:(void (^)(NSDictionary* clientData))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getSentCampaignsWithClientID:(NSString *)clientID
                   completionHandler:(void (^)(NSArray* campaigns))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getScheduledCampaignsWithClientID:(NSString *)clientID
                        completionHandler:(void (^)(NSArray* campaigns))completionHandler
                             errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getDraftCampaignsWithClientID:(NSString *)clientID
                    completionHandler:(void (^)(NSArray* campaigns))completionHandler
                         errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getSubscriberListsWithClientID:(NSString *)clientID
                     completionHandler:(void (^)(NSArray* subscriberLists))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getSegmentsWithClientID:(NSString *)clientID
              completionHandler:(void (^)(NSArray* segments))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getSuppressionListWithClientID:(NSString *)clientID
                                  page:(NSUInteger)page
                              pageSize:(NSUInteger)pageSize
                            orderField:(NSString *)orderField
                             ascending:(BOOL)ascending
                     completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getTemplatesWithClientID:(NSString *)clientID
               completionHandler:(void (^)(NSArray* templates))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler;

@end
