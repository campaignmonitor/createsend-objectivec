//
//  CSAPI+Campaigns.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSAPI+Campaigns.h"

NSString * const CSAPICampaignPreviewPersonalizeFallback = @"Fallback";
NSString * const CSAPICampaignPreviewPersonalizeRandom = @"Random";

@implementation CSAPI (Campaigns)

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
                      errorHandler:(CSAPIErrorHandler)errorHandler
{
    
    NSDictionary *parameters = @{
        @"Name": name,
        @"Subject": subject,
        @"FromName": fromName,
        @"FromEmail": fromEmail,
        @"ReplyTo": replyTo,
        @"HtmlUrl": htmlURL,
        @"TextUrl": textURL,
        @"ListIDs": listIDs,
        @"SegmentIDs": segmentIDs
    };
    
    [self.restClient post:[NSString stringWithFormat:@"campaigns/%@.json", clientID] withParameters:parameters success:completionHandler failure:errorHandler];
}

- (void)createCampaignFromTemplateWithClientID:(NSString *)clientID
                                          name:(NSString *)name
                                       subject:(NSString *)subject
                                      fromName:(NSString *)fromName
                                     fromEmail:(NSString *)fromEmail
                                       replyTo:(NSString *)replyTo
                                       listIDs:(NSArray *)listIDs
                                    segmentIDs:(NSArray *)segmentIDs
                                    templateID:(NSString *) templateID
                               templateContent:(NSDictionary *) templateContent
                             completionHandler:(void (^)(NSString *campaignID))completionHandler
                                  errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{
        @"Name": name,
        @"Subject": subject,
        @"FromName": fromName,
        @"FromEmail": fromEmail,
        @"ReplyTo": replyTo,
        @"ListIDs": listIDs,
        @"SegmentIDs": segmentIDs,
        @"TemplateID": templateID,
        @"TemplateContent": templateContent
    };

    [self.restClient post:[NSString stringWithFormat:@"campaigns/%@/fromtemplate.json", clientID] withParameters:parameters success:completionHandler failure:errorHandler];
}

- (void)deleteCampaignWithID:(NSString *)campaignID completionHandler:(void (^)(void))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient delete:[NSString stringWithFormat:@"campaigns/%@.json", campaignID] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)sendCampaignWithCampaignID:(NSString *)campaignID
          confirmationEmailAddress:(NSString *)emailAddress
                    sendDateString:(NSString *)sendDateString
                 completionHandler:(void (^)(void))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient post:[NSString stringWithFormat:@"campaigns/%@/send.json", campaignID] withParameters:@{@"ConfirmationEmail": emailAddress, @"SendDate": sendDateString} success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)sendCampaignImmediatelyWithCampaignID:(NSString *)campaignID
                     confirmationEmailAddress:(NSString *)emailAddress
                            completionHandler:(void (^)(void))completionHandler
                                 errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self sendCampaignWithCampaignID:campaignID confirmationEmailAddress:emailAddress sendDateString:@"Immediately" completionHandler:completionHandler errorHandler:errorHandler];
}

- (void)sendCampaignWithCampaignID:(NSString *)campaignID
          confirmationEmailAddress:(NSString *)emailAddress
                          sendDate:(NSDate *)sendDate
                 completionHandler:(void (^)(void))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self sendCampaignWithCampaignID:campaignID confirmationEmailAddress:emailAddress sendDateString:[[CSAPI sharedDateFormatter] stringFromDate:sendDate] completionHandler:completionHandler errorHandler:errorHandler];
}

- (void)sendCampaignPreviewWithCampaignID:(NSString *)campaignID
                               recipients:(NSArray *)recipients
                              personalize:(NSString *)personalize
                        completionHandler:(void (^)(void))completionHandler
                             errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient post:[NSString stringWithFormat:@"campaigns/%@/sendpreview.json", campaignID] withParameters:@{@"PreviewRecipients": recipients, @"Personalize": personalize} success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)unscheduleCampaignWithID:(NSString *)campaignID completionHandler:(void (^)(void))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient post:[NSString stringWithFormat:@"campaigns/%@/unschedule.json", campaignID] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)getCampaignSummaryWithCampaignID:(NSString *)campaignID
                       completionHandler:(void (^)(CSCampaignSummary *campaignSummary))completionHandler
                            errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"campaigns/%@/summary.json", campaignID] success:^(NSDictionary *response) {
        CSCampaignSummary *campaignSummary = [CSCampaignSummary campaignSummaryWithDictionary:response];
        if (completionHandler) completionHandler(campaignSummary);
    } failure:errorHandler];
}

- (void)getCampaignEmailClientUsageWithCampaignID:(NSString *)campaignID
                                completionHandler:(void (^)(NSArray *campaignEmailClientUsage))completionHandler
                                     errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"campaigns/%@/emailclientusage.json", campaignID] success:^(NSArray *response) {
        __block NSMutableArray *emailClientUsage = [[NSMutableArray alloc] initWithCapacity:response.count];
        [response enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *emailClientDictionary = (NSDictionary *)obj;
            CSCampaignEmailClient *ec = [CSCampaignEmailClient campaignEmailClientWithDictionary:emailClientDictionary];
            [emailClientUsage addObject:ec];
        }];
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:emailClientUsage]);
    } failure:errorHandler];
}

- (void)getCampaignListsAndSegmentsWithCampaignID:(NSString *)campaignID
                                completionHandler:(void (^)(NSArray *lists, NSArray *segments))completionHandler
                                     errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"campaigns/%@/listsandsegments.json", campaignID] success:^(NSDictionary *response) {
        __block NSMutableArray *lists = [[NSMutableArray alloc] init];
        [[response valueForKey:@"Lists"] enumerateObjectsUsingBlock:^(NSDictionary *listDictionary, NSUInteger idx, BOOL *stop) {
            CSList *list = [CSList listWithDictionary:listDictionary];
            [lists addObject:list];
        }];
        
        __block NSMutableArray *segments = [[NSMutableArray alloc] init];
        [[response valueForKey:@"Segments"] enumerateObjectsUsingBlock:^(NSDictionary *segmentDictionary, NSUInteger idx, BOOL *stop) {
            CSSegment *segment = [CSSegment segmentWithDictionary:segmentDictionary];
            [segments addObject:segment];
        }];
        
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:lists], [[NSArray alloc] initWithArray:segments]);
    } failure:errorHandler];
}

- (void)getCampaignRecipientsWithCampaignID:(NSString *)campaignID
                                       slug:(NSString *)slug
                                resultClass:(Class)resultClass
                                       date:(NSDate *)date
                                       page:(NSUInteger)page
                                   pageSize:(NSUInteger)pageSize
                                 orderField:(NSString *)orderField
                                  ascending:(BOOL)ascending
                          completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSMutableDictionary *parameters = [[CSAPI paginationParametersWithPage:page pageSize:pageSize orderField:orderField ascending:ascending] mutableCopy];
    
    if (date) {
        NSString *dateString = [[CSAPI sharedDateFormatter] stringFromDate:date];
        [parameters setObject:dateString forKey:@"date"];
    }
    
    [self.restClient get:[NSString stringWithFormat:@"campaigns/%@/%@.json", campaignID, slug] withParameters:parameters success:^(NSDictionary *response) {
        CSPaginatedResult *paginatedResult = [CSPaginatedResult paginatedResultOfClass:resultClass withDictionary:response];
        if (completionHandler) completionHandler(paginatedResult);
    } failure:errorHandler];
}

- (void)getCampaignRecipientsWithCampaignID:(NSString *)campaignID
                                       page:(NSUInteger)page
                                   pageSize:(NSUInteger)pageSize
                                 orderField:(NSString *)orderField
                                  ascending:(BOOL)ascending
                          completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self getCampaignRecipientsWithCampaignID:campaignID
                                         slug:@"recipients"
                                  resultClass:[CSCampaignRecipient class]
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
                       completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                            errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self getCampaignRecipientsWithCampaignID:campaignID
                                         slug:@"bounces"
                                  resultClass:[CSCampaignBouncedRecipient class]
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
                     completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self getCampaignRecipientsWithCampaignID:campaignID
                                         slug:@"opens"
                                  resultClass:[CSCampaignRecipient class]
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
                      completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self getCampaignRecipientsWithCampaignID:campaignID
                                         slug:@"clicks"
                                  resultClass:[CSCampaignRecipientClicked class]
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
                            completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                                 errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self getCampaignRecipientsWithCampaignID:campaignID
                                         slug:@"unsubscribes"
                                  resultClass:[CSCampaignRecipient class]
                                         date:nil
                                         page:page
                                     pageSize:pageSize
                                   orderField:orderField
                                    ascending:ascending
                            completionHandler:completionHandler
                                 errorHandler:errorHandler];
}

- (void)getCampaignSpamComplaintsWithCampaignID:(NSString *)campaignID
                                           date:(NSDate *)date
                                           page:(NSUInteger)page
                                       pageSize:(NSUInteger)pageSize
                                     orderField:(NSString *)orderField
                                      ascending:(BOOL)ascending
                              completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                                   errorHandler:(CSAPIErrorHandler)errorHandler;
{
    [self getCampaignRecipientsWithCampaignID:campaignID
                                         slug:@"spam"
                                  resultClass:[CSCampaignRecipient class]
                                         date:nil
                                         page:page
                                     pageSize:pageSize
                                   orderField:orderField
                                    ascending:ascending
                            completionHandler:completionHandler
                                 errorHandler:errorHandler];
}

@end
