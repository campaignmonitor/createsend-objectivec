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
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey slug:@"clients"];
  
  request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                           companyName, @"CompanyName",
                           contactName, @"ContactName",
                           emailAddress, @"EmailAddress",
                           country, @"Country",
                           timezone, @"TimeZone", nil];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous]; 
}

- (void)updateClientWithClientID:(NSString *)clientID
                     companyName:(NSString *)companyName
                     contactName:(NSString *)contactName
                    emailAddress:(NSString *)emailAddress
                         country:(NSString *)country
                        timezone:(NSString *)timezone
               completionHandler:(void (^)(void))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey 
                                                             slug:[NSString stringWithFormat:@"clients/%@/setbasics", clientID]];
  
  request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                           companyName, @"CompanyName",
                           contactName, @"ContactName",
                           emailAddress, @"EmailAddress",
                           country, @"Country",
                           timezone, @"TimeZone", nil];
  
  [request setCompletionBlock:completionHandler];
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)deleteClientWithID:(NSString *)clientID
           completionHandler:(void (^)(void))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"clients/%@", clientID]];
  request.requestMethod = @"DELETE";
  
  [request setCompletionBlock:completionHandler];
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)setClientAccessWithClientID:(NSString *)clientID
                           username:(NSString *)username
                           password:(NSString *)password
                        accessLevel:(NSUInteger)accessLevel
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey 
                                                             slug:[NSString stringWithFormat:@"clients/%@/setaccess", clientID]];
  
  request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                           username, @"Username",
                           password, @"Password",
                           [NSString stringWithFormat:@"%d", accessLevel], @"AccessLevel", nil];
  
  [request setCompletionBlock:completionHandler];
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)setClientAccessWithClientID:(NSString *)clientID
                        accessLevel:(NSUInteger)accessLevel
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey 
                                                             slug:[NSString stringWithFormat:@"clients/%@/setaccess", clientID]];
  
  request.requestObject = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", accessLevel]
                                                      forKey:@"AccessLevel"];
  
  [request setCompletionBlock:completionHandler];
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
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
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey 
                                                             slug:[NSString stringWithFormat:@"clients/%@/setpaygbilling", clientID]];
  
  request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                           currency, @"Currency",
                           [NSNumber numberWithBool:canPurchaseCredits], @"CanPurchaseCredits",
                           [NSNumber numberWithBool:clientPays], @"ClientPays",
                           [NSNumber numberWithFloat:markupPercentage], @"MarkupPercentage",
                           [NSNumber numberWithFloat:markupOnDelivery], @"MarkupOnDelivery",
                           [NSNumber numberWithFloat:markupPerRecipient], @"MarkupPerRecipient",
                           [NSNumber numberWithFloat:markupOnDesignSpamTest], @"MarkupOnDesignSpamTest", nil];
  
  [request setCompletionBlock:completionHandler];
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)setClientMonthlyBillingWithClientID:(NSString *)clientID
                                   currency:(NSString *)currency
                                 clientPays:(BOOL)clientPays
                           markupPercentage:(float)markupPercentage
                          completionHandler:(void (^)(void))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey 
                                                             slug:[NSString stringWithFormat:@"clients/%@/setmonthlybilling", clientID]];
  
  request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                           currency, @"Currency",
                           [NSNumber numberWithBool:clientPays], @"ClientPays",
                           [NSNumber numberWithFloat:markupPercentage], @"MarkupPercentage", nil];
  
  [request setCompletionBlock:completionHandler];
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getClients:(void (^)(NSArray* clients))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler {
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey slug:@"clients"];
  
  [request setCompletionBlock:^{
    NSMutableArray* clients = [NSMutableArray array];
    for (NSDictionary* clientDict in request.parsedResponse) {
      [clients addObject:[CSClient clientWithDictionary:clientDict]];
    }
    completionHandler([NSArray arrayWithArray:clients]);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getClientDetailsWithClientID:(NSString *)clientID
                   completionHandler:(void (^)(NSDictionary* clientData))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"clients/%@", clientID]];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getSentCampaignsWithClientID:(NSString *)clientID
                   completionHandler:(void (^)(NSArray* campaigns))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"clients/%@/campaigns", clientID]];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getScheduledCampaignsWithClientID:(NSString *)clientID
                        completionHandler:(void (^)(NSArray* campaigns))completionHandler
                             errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"clients/%@/scheduled", clientID]];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getDraftCampaignsWithClientID:(NSString *)clientID
                    completionHandler:(void (^)(NSArray* campaigns))completionHandler
                         errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"clients/%@/drafts", clientID]];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getSubscriberListsWithClientID:(NSString *)clientID
                     completionHandler:(void (^)(NSArray* subscriberLists))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"clients/%@/lists", clientID]];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getSegmentsWithClientID:(NSString *)clientID
              completionHandler:(void (^)(NSArray* segments))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"clients/%@/segments", clientID]];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getSuppressionListWithClientID:(NSString *)clientID
                                  page:(NSUInteger)page
                              pageSize:(NSUInteger)pageSize
                            orderField:(NSString *)orderField
                             ascending:(BOOL)ascending
                     completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSDictionary* queryParameters = [CSAPIRequest paginationParametersWithPage:page
                                                                    pageSize:pageSize
                                                                  orderField:orderField
                                                                   ascending:ascending];
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"clients/%@/suppressionlist", clientID]
                                                  queryParameters:queryParameters];
  
  
  [request setCompletionBlock:^{
    CSPaginatedResult* result = [CSPaginatedResult resultWithDictionary:request.parsedResponse];
    completionHandler(result);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getTemplatesWithClientID:(NSString *)clientID
               completionHandler:(void (^)(NSArray* templates))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"clients/%@/templates", clientID]];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

@end
