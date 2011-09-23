//
//  CSAPI+Clients.m
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI+Clients.h"

@implementation CSAPI (Clients)

- (void)createClientWithCompanyName:(NSString *)companyName
                        contactName:(NSString *)contactName
                       emailAddress:(NSString *)emailAddress
                            country:(NSString *)country
                           timezone:(NSString *)timezone
                  completionHandler:(void (^)(NSString* clientID))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient postPath:@"clients.json"
                 parameters:nil
                 bodyObject:[NSDictionary dictionaryWithObjectsAndKeys:
                             companyName, @"CompanyName",
                             contactName, @"ContactName",
                             emailAddress, @"EmailAddress",
                             country, @"Country",
                             timezone, @"TimeZone", nil]
                    success:completionHandler
                    failure:errorHandler];
}

- (void)updateClientWithClientID:(NSString *)clientID
                     companyName:(NSString *)companyName
                     contactName:(NSString *)contactName
                    emailAddress:(NSString *)emailAddress
                         country:(NSString *)country
                        timezone:(NSString *)timezone
               completionHandler:(void (^)(void))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient putPath:[NSString stringWithFormat:@"clients/%@/setbasics.json", clientID]
                parameters:nil
                bodyObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            companyName, @"CompanyName",
                            contactName, @"ContactName",
                            emailAddress, @"EmailAddress",
                            country, @"Country",
                            timezone, @"TimeZone", nil]
                   success:^(id response) { completionHandler(); }
                   failure:errorHandler];
}

- (void)deleteClientWithID:(NSString *)clientID
           completionHandler:(void (^)(void))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient deletePath:[NSString stringWithFormat:@"clients/%@.json", clientID]
                   parameters:nil
                      success:^(id response) { completionHandler(); }
                      failure:errorHandler];
}

- (void)setClientAccessWithClientID:(NSString *)clientID
                           username:(NSString *)username
                           password:(NSString *)password
                        accessLevel:(NSUInteger)accessLevel
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient putPath:[NSString stringWithFormat:@"clients/%@/setaccess.json", clientID]
                parameters:nil
                bodyObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"Username",
                            password, @"Password",
                            [NSString stringWithFormat:@"%d", accessLevel], @"AccessLevel", nil]
                   success:^(id response) { completionHandler(); }
                   failure:errorHandler];
}

- (void)setClientAccessWithClientID:(NSString *)clientID
                        accessLevel:(NSUInteger)accessLevel
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient putPath:[NSString stringWithFormat:@"clients/%@/setaccess.json", clientID]
                parameters:nil
                bodyObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", accessLevel]
                                                       forKey:@"AccessLevel"]
                   success:^(id response) { completionHandler(); }
                   failure:errorHandler];
}

- (void)setClientPAYGBillingSettingsWithClientID:(NSString *)clientID
                                        currency:(NSString *)currency
                              canPurchaseCredits:(BOOL)canPurchaseCredits
                                      clientPays:(BOOL)clientPays
                                markupPercentage:(float)markupPercentage
                                markupOnDelivery:(float)markupOnDelivery
                              markupPerRecipient:(float)markupPerRecipient
                          markupOnDesignSpamTest:(float)markupOnDesignSpamTest
                               completionHandler:(void (^)(void))completionHandler
                                    errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient putPath:[NSString stringWithFormat:@"clients/%@/setpaygbilling.json", clientID]
                parameters:nil
                bodyObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            currency, @"Currency",
                            [NSNumber numberWithBool:canPurchaseCredits], @"CanPurchaseCredits",
                            [NSNumber numberWithBool:clientPays], @"ClientPays",
                            [NSNumber numberWithFloat:markupPercentage], @"MarkupPercentage",
                            [NSNumber numberWithFloat:markupOnDelivery], @"MarkupOnDelivery",
                            [NSNumber numberWithFloat:markupPerRecipient], @"MarkupPerRecipient",
                            [NSNumber numberWithFloat:markupOnDesignSpamTest], @"MarkupOnDesignSpamTest", nil]
                   success:^(id response) { completionHandler(); }
                   failure:errorHandler];
}

- (void)setClientMonthlyBillingWithClientID:(NSString *)clientID
                                   currency:(NSString *)currency
                                 clientPays:(BOOL)clientPays
                           markupPercentage:(float)markupPercentage
                          completionHandler:(void (^)(void))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient putPath:[NSString stringWithFormat:@"clients/%@/setmonthlybilling.json", clientID]
                parameters:nil
                bodyObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            currency, @"Currency",
                            [NSNumber numberWithBool:clientPays], @"ClientPays",
                            [NSNumber numberWithFloat:markupPercentage], @"MarkupPercentage", nil]
                   success:^(id response) { completionHandler(); }
                   failure:errorHandler];
}

- (void)getClients:(void (^)(NSArray* clients))completionHandler
      errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:@"clients.json"
                parameters:nil
                   success:^(id response) {
                     NSMutableArray* clients = [NSMutableArray array];
                     
                     for (NSDictionary* clientDict in response) {
                       [clients addObject:[CSClient clientWithDictionary:clientDict]];
                     }
                     
                     completionHandler([NSArray arrayWithArray:clients]);
                   }
                   failure:errorHandler];
}

- (void)getClientDetailsWithClientID:(NSString *)clientID
                   completionHandler:(void (^)(NSDictionary* clientData))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"clients/%@.json", clientID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)getSentCampaignsWithClientID:(NSString *)clientID
                   completionHandler:(void (^)(NSArray* campaigns))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"clients/%@/campaigns.json", clientID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)getScheduledCampaignsWithClientID:(NSString *)clientID
                        completionHandler:(void (^)(NSArray* campaigns))completionHandler
                             errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"clients/%@/scheduled.json", clientID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)getDraftCampaignsWithClientID:(NSString *)clientID
                    completionHandler:(void (^)(NSArray* campaigns))completionHandler
                         errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"clients/%@/drafts.json", clientID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)getSubscriberListsWithClientID:(NSString *)clientID
                     completionHandler:(void (^)(NSArray* subscriberLists))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"clients/%@/lists.json", clientID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)getSegmentsWithClientID:(NSString *)clientID
              completionHandler:(void (^)(NSArray* segments))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"clients/%@/segments.json", clientID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)getSuppressionListWithClientID:(NSString *)clientID
                                  page:(NSUInteger)page
                              pageSize:(NSUInteger)pageSize
                            orderField:(NSString *)orderField
                             ascending:(BOOL)ascending
                     completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSDictionary* queryParameters = [CSAPI paginationParametersWithPage:page
                                                                    pageSize:pageSize
                                                                  orderField:orderField
                                                                   ascending:ascending];
  
  [self.restClient getPath:[NSString stringWithFormat:@"clients/%@/suppressionlist.json", clientID]
                parameters:queryParameters
                   success:^(id response) {
                     CSPaginatedResult* result = [CSPaginatedResult resultWithDictionary:response];
                     completionHandler(result);
                   }
                   failure:errorHandler];
}

- (void)getTemplatesWithClientID:(NSString *)clientID
               completionHandler:(void (^)(NSArray* templates))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"clients/%@/templates.json", clientID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

@end
