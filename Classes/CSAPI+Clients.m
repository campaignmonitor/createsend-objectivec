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

@end
