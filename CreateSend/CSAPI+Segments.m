//
//  CSAPI+Segments.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSAPI+Segments.h"

@implementation CSAPI (Segments)

- (void)createSegmentWithListID:(NSString *)listID
                          title:(NSString *)title
                          rules:(NSArray *)rules
              completionHandler:(void (^)(NSString *segmentID))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient post:[NSString stringWithFormat:@"segments/%@.json", listID] withParameters:@{@"Title": title, @"Rules": [rules valueForKey:@"dictionaryValue"]} success:completionHandler failure:errorHandler];
}

- (void)updateSegmentWithSegmentID:(NSString *)segmentID
                             title:(NSString *)title
                             rules:(NSArray *)rules
                 completionHandler:(void (^)(void))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient put:[NSString stringWithFormat:@"segments/%@.json", segmentID] withParameters:@{@"Title": title, @"Rules": [rules valueForKey:@"dictionaryValue"]} success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)addRuleToSegmentWithID:(NSString *)segmentID
                          rule:(CSSegmentRule *)rule
             completionHandler:(void (^)(void))completionHandler
                  errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient post:[NSString stringWithFormat:@"segments/%@/rules.json", segmentID] withParameters:[rule dictionaryValue] success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)removeAllRulesFromSegmentWithID:(NSString *)segmentID
                      completionHandler:(void (^)(void))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient delete:[NSString stringWithFormat:@"segments/%@/rules.json", segmentID] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)getSegmentDetailsWithSegmentID:(NSString *)segmentID
                     completionHandler:(void (^)(CSSegment *segment))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"segments/%@.json", segmentID] success:^(NSDictionary *response) {
        CSSegment *segment = [CSSegment segmentWithDictionary:response];
        if (completionHandler) completionHandler(segment);
    } failure:errorHandler];
}

- (void)getActiveSubscribersWithSegmentID:(NSString *)segmentID
                                     date:(NSDate *)date
                                     page:(NSUInteger)page
                                 pageSize:(NSUInteger)pageSize
                               orderField:(NSString *)orderField
                                ascending:(BOOL)ascending
                        completionHandler:(void (^)(CSPaginatedResult *))completionHandler
                             errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSMutableDictionary *parameters = [[CSAPI paginationParametersWithPage:page pageSize:pageSize orderField:orderField ascending:ascending] mutableCopy];
    
    NSString *dateString = [[CSAPI sharedDateFormatter] stringFromDate:date];
    [parameters setObject:dateString forKey:@"date"];
    
    [self.restClient get:[NSString stringWithFormat:@"segments/%@/active.json", segmentID] withParameters:parameters success:^(NSDictionary *response) {
        CSPaginatedResult *paginatedResult = [CSPaginatedResult paginatedResultOfClass:[CSSubscriber class] withDictionary:response];
        if (completionHandler) completionHandler(paginatedResult);
    } failure:errorHandler];
}

- (void)deleteSegmentWithID:(NSString *)segmentID
          completionHandler:(void (^)(void))completionHandler
               errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient delete:[NSString stringWithFormat:@"segments/%@.json", segmentID] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}
@end
