//
//  CSAPI+Segments.m
//  CreateSend
//
//  Created by Nathan de Vries on 30/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI+Segments.h"

@implementation CSAPI (Segments)

- (void)getSegmentsWithClientID:(NSString *)clientID
              completionHandler:(void (^)(NSArray* segments))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"clients/%@/segments.json", clientID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)createSegmentWithListID:(NSString *)listID
                          title:(NSString *)title
                          rules:(NSDictionary *)rules
              completionHandler:(void (^)(NSString* segmentID))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient postPath:[NSString stringWithFormat:@"segments/%@.json", listID]
                 parameters:nil
                 bodyObject:[NSDictionary dictionaryWithObjectsAndKeys:
                             title, @"Title",
                             rules, @"Rules", nil]
                    success:completionHandler
                    failure:errorHandler];
}

- (void)updateSegmentWithSegmentID:(NSString *)segmentID
                             title:(NSString *)title
                             rules:(NSDictionary *)rules
                 completionHandler:(void (^)(void))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient putPath:[NSString stringWithFormat:@"segments/%@.json", segmentID]
                parameters:nil
                bodyObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            title, @"Title",
                            rules, @"Rules", nil]
                   success:^(id response) { completionHandler(); }
                   failure:errorHandler];
}

- (void)addRuleToSegmentWithID:(NSString *)segmentID
                          rule:(NSDictionary *)rule
             completionHandler:(void (^)(void))completionHandler
                  errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient postPath:[NSString stringWithFormat:@"segments/%@/rules.json", segmentID]
                 parameters:nil
                 bodyObject:rule
                    success:^(id response) { completionHandler(); }
                    failure:errorHandler];
}

- (void)removeAllRulesFromSegmentWithID:(NSString *)segmentID
                      completionHandler:(void (^)(void))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient deletePath:[NSString stringWithFormat:@"segments/%@/rules.json", segmentID]
                   parameters:nil
                      success:^(id response) { completionHandler(); }
                      failure:errorHandler];
}

- (void)getSegmentDetailsWithSegmentID:(NSString *)segmentID
                     completionHandler:(void (^)(NSDictionary* segmentDetails))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"segments/%@.json", segmentID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)getActiveSubscribersWithSegmentID:(NSString *)segmentID
                                     date:(NSDate *)date
                                     page:(NSUInteger)page
                                 pageSize:(NSUInteger)pageSize
                               orderField:(NSString *)orderField
                                ascending:(BOOL)ascending
                        completionHandler:(void (^)(CSPaginatedResult *))completionHandler
                             errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSMutableDictionary* queryParameters;
  queryParameters = [[[CSAPI paginationParametersWithPage:page
                                                 pageSize:pageSize
                                               orderField:orderField
                                                ascending:ascending] mutableCopy] autorelease];
  
  NSString* dateString = [[CSAPI sharedDateFormatter] stringFromDate:date];
  [queryParameters setObject:dateString forKey:@"Date"];
  
  
  [self.restClient getPath:[NSString stringWithFormat:@"segments/%@/active.json", segmentID]
                parameters:queryParameters
                   success:^(id response) {
                     CSPaginatedResult* result = [CSPaginatedResult resultWithDictionary:response];
                     completionHandler(result);
                   }
                   failure:errorHandler];
}

- (void)deleteSegmentWithID:(NSString *)segmentID
          completionHandler:(void (^)(void))completionHandler
               errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient deletePath:[NSString stringWithFormat:@"segments/%@.json", segmentID]
                   parameters:nil
                      success:^(id response) { completionHandler(); }
                      failure:errorHandler];
}

@end
