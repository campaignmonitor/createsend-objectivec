//
//  CSAPI+Clients.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"
#import "CSClient.h"

@interface CSAPI (Clients)

- (void)createClientWithCompanyName:(NSString *)companyName
                        contactName:(NSString *)contactName
                       emailAddress:(NSString *)emailAddress
                            country:(NSString *)country
                           timezone:(NSString *)timezone
                  completionHandler:(void (^)(NSString* clientID))completionHandler
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

@end
