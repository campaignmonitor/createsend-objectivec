//
//  CSAPI+Campaigns.m
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI+Campaigns.h"

@implementation CSAPI (Campaigns)

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
                      errorHandler:(CSAPIErrorHandler)errorHandler {
    
    __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                               slug:[NSString stringWithFormat:@"campaigns/%@",
                                                                     clientID]];
    
    request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                             name, @"Name",
                             subject, @"Subject",
                             fromName, @"FromName",
                             fromEmail, @"FromEmail",
                             replyTo, @"ReplyTo",
                             HTMLURLString, @"HtmlUrl",
                             textURLString, @"TextUrl",
                             listIDs, @"ListIDs",
                             segmentIDs, @"SegmentIDs",
                             nil];
    
    [request setCompletionBlock:^{
        completionHandler(request.parsedResponse);
    }];
    
    [request setFailedBlock:^{ errorHandler(request.error); }];
    [request startAsynchronous];
}

@end
