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

- (void)deleteCampaignWithID:(NSString *)campaignID
           completionHandler:(void (^)(void))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"campaigns/%@", campaignID]];
  request.requestMethod = @"DELETE";
  
  [request setCompletionBlock:completionHandler];
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

- (void)getCampaignSummaryWithCampaignID:(NSString *)campaignID
                       completionHandler:(void (^)(NSDictionary* summaryData))completionHandler
                            errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"campaigns/%@/summary", campaignID]];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getCampaignListsAndSegmentsWithCampaignID:(NSString *)campaignID
                                completionHandler:(void (^)(NSArray* lists, NSArray* segments))completionHandler
                                     errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"campaigns/%@/listsandsegments", campaignID]];
  
  [request setCompletionBlock:^{
    NSArray* lists = [request.parsedResponse valueForKey:@"Lists"];
    NSArray* segments = [request.parsedResponse valueForKey:@"Segments"];
    
    completionHandler(lists, segments);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getCampaignRecipientsWithCampaignID:(NSString *)campaignID
                                       slug:(NSString *)slug
                                       date:(NSDate *)date
                                       page:(NSUInteger)page
                                   pageSize:(NSUInteger)pageSize
                                 orderField:(NSString *)orderField
                                  ascending:(BOOL)ascending
                          completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSMutableDictionary* queryParameters;
  queryParameters = [[[CSAPIRequest paginationParametersWithPage:page
                                                        pageSize:pageSize
                                                      orderField:orderField
                                                       ascending:ascending] mutableCopy] autorelease];
  
  if (date) {
    NSString* dateString = [[CSAPIRequest sharedDateFormatter] stringFromDate:date];
    [queryParameters setObject:dateString forKey:@"Date"];
  }
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"campaigns/%@/%@", campaignID, slug]
                                                  queryParameters:queryParameters];
  
  [request setCompletionBlock:^{
    CSPaginatedResult* result = [CSPaginatedResult resultWithDictionary:request.parsedResponse];
    completionHandler(result);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getCampaignRecipientsWithCampaignID:(NSString *)campaignID
                                       page:(NSUInteger)page
                                   pageSize:(NSUInteger)pageSize
                                 orderField:(NSString *)orderField
                                  ascending:(BOOL)ascending
                          completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self getCampaignRecipientsWithCampaignID:campaignID
                                       slug:@"recipients"
                                       date:nil
                                       page:page
                                   pageSize:pageSize
                                 orderField:orderField
                                  ascending:ascending
                          completionHandler:completionHandler
                               errorHandler:errorHandler];
}



- (void)getCampaignBouncesWithCampaignID:(NSString *)campaignID
                                    date:(NSDate *)date
                                    page:(NSUInteger)page
                                pageSize:(NSUInteger)pageSize
                              orderField:(NSString *)orderField
                               ascending:(BOOL)ascending
                       completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                            errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self getCampaignRecipientsWithCampaignID:campaignID
                                       slug:@"bounces"
                                       date:nil
                                       page:page
                                   pageSize:pageSize
                                 orderField:orderField
                                  ascending:ascending
                          completionHandler:completionHandler
                               errorHandler:errorHandler];
}

- (void)getCampaignOpensWithCampaignID:(NSString *)campaignID
                                  date:(NSDate *)date
                                  page:(NSUInteger)page
                              pageSize:(NSUInteger)pageSize
                            orderField:(NSString *)orderField
                             ascending:(BOOL)ascending
                     completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self getCampaignRecipientsWithCampaignID:campaignID
                                       slug:@"opens"
                                       date:nil
                                       page:page
                                   pageSize:pageSize
                                 orderField:orderField
                                  ascending:ascending
                          completionHandler:completionHandler
                               errorHandler:errorHandler];
}

- (void)getCampaignClicksWithCampaignID:(NSString *)campaignID
                                   date:(NSDate *)date
                                   page:(NSUInteger)page
                               pageSize:(NSUInteger)pageSize
                             orderField:(NSString *)orderField
                              ascending:(BOOL)ascending
                      completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self getCampaignRecipientsWithCampaignID:campaignID
                                       slug:@"clicks"
                                       date:nil
                                       page:page
                                   pageSize:pageSize
                                 orderField:orderField
                                  ascending:ascending
                          completionHandler:completionHandler
                               errorHandler:errorHandler];
}

- (void)getCampaignUnsubscribesWithCampaignID:(NSString *)campaignID
                                         date:(NSDate *)date
                                         page:(NSUInteger)page
                                     pageSize:(NSUInteger)pageSize
                                   orderField:(NSString *)orderField
                                    ascending:(BOOL)ascending
                            completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                                 errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self getCampaignRecipientsWithCampaignID:campaignID
                                       slug:@"unsubscribes"
                                       date:nil
                                       page:page
                                   pageSize:pageSize
                                 orderField:orderField
                                  ascending:ascending
                          completionHandler:completionHandler
                               errorHandler:errorHandler];
}

@end
