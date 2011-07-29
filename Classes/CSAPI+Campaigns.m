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

- (void)sendCampaignWithCampaignID:(NSString *)campaignID
          confirmationEmailAddress:(NSString *)emailAddress
                    sendDateString:(NSString *)sendDateString
                 completionHandler:(void (^)(void))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler {
    
    __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                               slug:[NSString stringWithFormat:@"campaigns/%@/send", campaignID]];
    
    request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                             emailAddress, @"ConfirmationEmail",
                             sendDateString, @"SendDate", nil];
    
    [request setCompletionBlock:completionHandler];
    [request setFailedBlock:^{ errorHandler(request.error); }];
    [request startAsynchronous];
}

- (void)sendCampaignImmediatelyWithCampaignID:(NSString *)campaignID
                     confirmationEmailAddress:(NSString *)emailAddress
                            completionHandler:(void (^)(void))completionHandler
                                 errorHandler:(CSAPIErrorHandler)errorHandler {
    
    [self sendCampaignWithCampaignID:campaignID
            confirmationEmailAddress:emailAddress
                      sendDateString:@"Immediately"
                   completionHandler:completionHandler
                        errorHandler:errorHandler];
}

- (void)sendCampaignWithCampaignID:(NSString *)campaignID
          confirmationEmailAddress:(NSString *)emailAddress
                          sendDate:(NSDate *)sendDate
                 completionHandler:(void (^)(void))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler {
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    [self sendCampaignWithCampaignID:campaignID
            confirmationEmailAddress:emailAddress
                      sendDateString:[formatter stringFromDate:sendDate]
                   completionHandler:completionHandler
                        errorHandler:errorHandler];
    
}

@end
