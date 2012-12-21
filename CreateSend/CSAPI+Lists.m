//
//  CSAPI+Lists.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSAPI+Lists.h"

NSString * const CSAPIListStatisticTotalActiveSubscribersKey = @"TotalActiveSubscribers";
NSString * const CSAPIListStatisticNewActiveSubscribersTodayKey = @"NewActiveSubscribersToday";
NSString * const CSAPIListStatisticNewActiveSubscribersYesterdayKey = @"NewActiveSubscribersYesterday";
NSString * const CSAPIListStatisticNewActiveSubscribersThisWeekKey = @"NewActiveSubscribersThisWeek";
NSString * const CSAPIListStatisticNewActiveSubscribersThisMonthKey = @"NewActiveSubscribersThisMonth";
NSString * const CSAPIListStatisticNewActiveSubscribersThisYearKey = @"NewActiveSubscribersThisYear";
NSString * const CSAPIListStatisticTotalUnsubscribesKey = @"TotalUnsubscribes";
NSString * const CSAPIListStatisticUnsubscribesTodayKey = @"UnsubscribesToday";
NSString * const CSAPIListStatisticUnsubscribesYesterdayKey = @"UnsubscribesYesterday";
NSString * const CSAPIListStatisticUnsubscribesThisWeekKey = @"UnsubscribesThisWeek";
NSString * const CSAPIListStatisticUnsubscribesThisMonthKey = @"UnsubscribesThisMonth";
NSString * const CSAPIListStatisticUnsubscribesThisYearKey = @"UnsubscribesThisYear";
NSString * const CSAPIListStatisticTotalDeletedKey = @"TotalDeleted";
NSString * const CSAPIListStatisticDeletedTodayKey = @"DeletedToday";
NSString * const CSAPIListStatisticDeletedYesterdayKey = @"DeletedYesterday";
NSString * const CSAPIListStatisticDeletedThisWeekKey = @"DeletedThisWeek";
NSString * const CSAPIListStatisticDeletedThisMonthKey = @"DeletedThisMonth";
NSString * const CSAPIListStatisticDeletedThisYearKey = @"DeletedThisYear";
NSString * const CSAPIListStatisticTotalBouncesKey = @"TotalBounces";
NSString * const CSAPIListStatisticBouncesTodayKey = @"BouncesToday";
NSString * const CSAPIListStatisticBouncesYesterdayKey = @"BouncesYesterday";
NSString * const CSAPIListStatisticBouncesThisWeekKey = @"BouncesThisWeek";
NSString * const CSAPIListStatisticBouncesThisMonthKey = @"BouncesThisMonth";
NSString * const CSAPIListStatisticBouncesThisYearKey = @"BouncesThisYear";

NSString * const CSAPIOrderByEmail = @"email";
NSString * const CSAPIOrderByName = @"name";
NSString * const CSAPIOrderByDate = @"date";

NSString * const CSAPIWebhookPayloadFormatJSON = @"json";
NSString * const CSAPIWebhookPayloadFormatXML = @"xml";

@implementation CSAPI (Lists)

- (void)createListWithClientID:(NSString *)clientID
                         title:(NSString *)title
               unsubscribePage:(NSString *)unsubscribePage
       confirmationSuccessPage:(NSString *)confirmationSuccessPage
            shouldConfirmOptIn:(BOOL)shouldConfirmOptIn
             completionHandler:(void (^)(NSString *listID))completionHandler
                  errorHandler:(CSAPIErrorHandler)errorHandler
{
    
    NSDictionary *parameters = @{@"Title": (title ?: @""), @"UnsubscribePage": (unsubscribePage ?: @""), @"ConfirmationSuccessPage": (confirmationSuccessPage ?: @""), @"ConfirmedOptIn": @(shouldConfirmOptIn)};
    [self.restClient post:[NSString stringWithFormat:@"lists/%@.json", clientID] withParameters:parameters success:completionHandler failure:errorHandler];
}

- (void)updateListWithListID:(NSString *)listID
                       title:(NSString *)title
             unsubscribePage:(NSString *)unsubscribePage
     confirmationSuccessPage:(NSString *)confirmationSuccessPage
          shouldConfirmOptIn:(BOOL)shouldConfirmOptIn
           completionHandler:(void (^)(void))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{@"Title": (title ?: @""), @"UnsubscribePage": (unsubscribePage ?: @""), @"ConfirmationSuccessPage": (confirmationSuccessPage ?: @""), @"ConfirmedOptIn": @(shouldConfirmOptIn)};
    [self.restClient put:[NSString stringWithFormat:@"lists/%@.json", listID] withParameters:parameters success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)deleteListWithID:(NSString *)listID completionHandler:(void (^)(void))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient delete:[NSString stringWithFormat:@"lists/%@.json", listID] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)getListDetailsWithListID:(NSString *)listID completionHandler:(void (^)(CSList *list))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"lists/%@.json", listID] success:^(NSDictionary *response) {
        CSList *list = [CSList listWithDictionary:response];
        if (completionHandler) completionHandler(list);
    } failure:errorHandler];
}

- (void)getListStatisticsWithListID:(NSString *)listID completionHandler:(void (^)(NSDictionary *listStatistics))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"lists/%@/stats.json", listID] success:completionHandler failure:errorHandler];
}

- (void)getListSegmentsWithListID:(NSString *)listID completionHandler:(void (^)(NSArray *listSegments))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"lists/%@/segments.json", listID] success:^(NSArray *response) {
        __block NSMutableArray *segments = [[NSMutableArray alloc] initWithCapacity:response.count];
        [response enumerateObjectsUsingBlock:^(NSDictionary *segmentDictionary, NSUInteger idx, BOOL *stop) {
            CSSegment *segment = [CSSegment segmentWithDictionary:segmentDictionary];
            [segments addObject:segment];
        }];
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:segments]);
    } failure:errorHandler];
}

- (void)getSubscribersWithListID:(NSString *)listID
                            slug:(NSString *)slug
                            date:(NSDate *)date
                            page:(NSUInteger)page
                        pageSize:(NSUInteger)pageSize
                      orderField:(NSString *)orderField
                       ascending:(BOOL)ascending
               completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSMutableDictionary *parameters = [[CSAPI paginationParametersWithPage:page pageSize:pageSize orderField:orderField ascending:ascending] mutableCopy];
    
    NSString *dateString = [[CSAPI sharedDateFormatter] stringFromDate:date];
    [parameters setObject:dateString forKey:@"date"];

    [self.restClient get:[NSString stringWithFormat:@"lists/%@/%@.json", listID, slug] withParameters:parameters success:^(NSDictionary *response) {
        CSPaginatedResult *paginatedResult = [CSPaginatedResult paginatedResultOfClass:[CSSubscriber class] withDictionary:response];
        if (completionHandler) completionHandler(paginatedResult);
    } failure:errorHandler];
}

- (void)getActiveSubscribersWithListID:(NSString *)listID
                                  date:(NSDate *)date
                                  page:(NSUInteger)page
                              pageSize:(NSUInteger)pageSize
                            orderField:(NSString *)orderField
                             ascending:(BOOL)ascending
                     completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self getSubscribersWithListID:listID
                              slug:@"active"
                              date:date
                              page:page
                          pageSize:pageSize
                        orderField:orderField
                         ascending:ascending
                 completionHandler:completionHandler
                      errorHandler:errorHandler];
}

- (void)getUnconfirmedSubscribersWithListID:(NSString *)listID
                                       date:(NSDate *)date
                                       page:(NSUInteger)page
                                   pageSize:(NSUInteger)pageSize
                                 orderField:(NSString *)orderField
                                  ascending:(BOOL)ascending
                          completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler;
{
    [self getSubscribersWithListID:listID
                              slug:@"unconfirmed"
                              date:date
                              page:page
                          pageSize:pageSize
                        orderField:orderField
                         ascending:ascending
                 completionHandler:completionHandler
                      errorHandler:errorHandler];
}

- (void)getUnsubscribedSubscribersWithListID:(NSString *)listID
                                        date:(NSDate *)date
                                        page:(NSUInteger)page
                                    pageSize:(NSUInteger)pageSize
                                  orderField:(NSString *)orderField
                                   ascending:(BOOL)ascending
                           completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler {
    
    [self getSubscribersWithListID:listID
                              slug:@"unsubscribed"
                              date:date
                              page:page
                          pageSize:pageSize
                        orderField:orderField
                         ascending:ascending
                 completionHandler:completionHandler
                      errorHandler:errorHandler];
}

- (void)getDeletedSubscribersWithListID:(NSString *)listID
                                   date:(NSDate *)date
                                   page:(NSUInteger)page
                               pageSize:(NSUInteger)pageSize
                             orderField:(NSString *)orderField
                              ascending:(BOOL)ascending
                      completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self getSubscribersWithListID:listID
                              slug:@"deleted"
                              date:date
                              page:page
                          pageSize:pageSize
                        orderField:orderField
                         ascending:ascending
                 completionHandler:completionHandler
                      errorHandler:errorHandler];
}

- (void)getBouncedSubscribersWithListID:(NSString *)listID
                                   date:(NSDate *)date
                                   page:(NSUInteger)page
                               pageSize:(NSUInteger)pageSize
                             orderField:(NSString *)orderField
                              ascending:(BOOL)ascending
                      completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler {
    
    [self getSubscribersWithListID:listID
                              slug:@"bounced"
                              date:date
                              page:page
                          pageSize:pageSize
                        orderField:orderField
                         ascending:ascending
                 completionHandler:completionHandler
                      errorHandler:errorHandler];
}

- (void)getCustomFieldsWithListID:(NSString *)listID completionHandler:(void (^)(NSArray *customFields))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;
{
    [self.restClient get:[NSString stringWithFormat:@"lists/%@/customfields.json", listID] success:^(NSArray *response) {
        __block NSMutableArray *customFields = [[NSMutableArray alloc] initWithCapacity:response.count];
        [response enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *customFieldDictionary = (NSDictionary *)obj;
            CSCustomField *customField = [CSCustomField customFieldWithDictionary:customFieldDictionary];
            [customFields addObject:customField];
        }];
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:customFields]);
    } failure:errorHandler];
}

- (void)createCustomFieldWithListID:(NSString *)listID
                        customField:(CSCustomField *)customField
                  completionHandler:(void (^)(NSString *customFieldKey))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"FieldName": customField.name, @"DataType": [customField dataTypeString], @"VisibleInPreferenceCenter": @(customField.visibleInPreferenceCenter)}];
    if (customField.options) [parameters setObject:customField.options forKey:@"Options"];
    [self.restClient post:[NSString stringWithFormat:@"lists/%@/customfields.json", listID] withParameters:parameters success:completionHandler failure:errorHandler];
}

- (void)updateCustomFieldWithListID:(NSString *)listID
                        customField:(CSCustomField *)customField
                  completionHandler:(void (^)(NSString *customFieldKey))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{@"FieldName": customField.name, @"VisibleInPreferenceCenter": @(customField.visibleInPreferenceCenter)};
    [self.restClient put:[NSString stringWithFormat:@"lists/%@/customfields/%@.json", listID, customField.key] withParameters:parameters success:completionHandler failure:errorHandler];
}

- (void)updateCustomFieldOptionsWithListID:(NSString *)listID
                            customFieldKey:(NSString *)customFieldKey
                                   options:(NSArray *)options
                              keepExisting:(BOOL)keepExisting
                         completionHandler:(void (^)(void))completionHandler
                              errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{@"Options": options, @"KeepExistingOptions": @(keepExisting)};
    [self.restClient put:[NSString stringWithFormat:@"lists/%@/customfields/%@/options.json", listID, customFieldKey] withParameters:parameters success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)deleteCustomFieldWithListID:(NSString *)listID
                     customFieldKey:(NSString *)customFieldKey
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient delete:[NSString stringWithFormat:@"lists/%@/customfields/%@.json", listID, customFieldKey] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)createWebhookWithListID:(NSString *)listID
                         events:(NSArray *)events
                      URLString:(NSString *)URLString
                  payloadFormat:(NSString *)payloadFormat
              completionHandler:(void (^)(NSString *webhookID))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{@"Events": events, @"Url": URLString, @"PayloadFormat": payloadFormat};
    [self.restClient post:[NSString stringWithFormat:@"lists/%@/webhooks.json", listID] withParameters:parameters success:completionHandler failure:errorHandler];
}

- (void)getWebhooksWithListID:(NSString *)listID completionHandler:(void (^)(NSArray *webhooks))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"lists/%@/webhooks.json", listID] success:^(NSArray *response) {
        __block NSMutableArray *webhooks = [[NSMutableArray alloc] initWithCapacity:response.count];
        [response enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *webhookDictionary = (NSDictionary *)obj;
            CSWebhook *webhook = [CSWebhook webhookWithDictionary:webhookDictionary];
            [webhooks addObject:webhook];
        }];
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:webhooks]);
    } failure:errorHandler];
}

- (void)testWebhookWithListID:(NSString *)listID
                    webhookID:(NSString *)webhookID
            completionHandler:(void (^)(void))completionHandler
                 errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"lists/%@/webhooks/%@/test.json", listID, webhookID] success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)deleteWebhookWithListID:(NSString *)listID
                      webhookID:(NSString *)webhookID
              completionHandler:(void (^)(void))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient delete:[NSString stringWithFormat:@"lists/%@/webhooks/%@.json", listID, webhookID] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)activateWebhookWithListID:(NSString *)listID
                        webhookID:(NSString *)webhookID
                completionHandler:(void (^)(void))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient put:[NSString stringWithFormat:@"lists/%@/webhooks/%@/activate.json", listID, webhookID] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)deactivateWebhookWithListID:(NSString *)listID
                          webhookID:(NSString *)webhookID
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient put:[NSString stringWithFormat:@"lists/%@/webhooks/%@/deactivate.json", listID, webhookID] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}
@end
