//
//  CSAPI+Segments.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSAPI.h"
#import "CSSegment.h"
#import "CSSegmentRule.h"

/**
 Segment-related APIs. See CSAPI for documentation of the other API categories.
 */
@interface CSAPI (Segments)

/**
 Create a new segment for a specific list.
 
 http://www.campaignmonitor.com/api/segments/#creating_a_segment
 
 @param listID ID of the list on which the segment should be created
 @param title Title of the new segment
 @param rules An array of `CSSegmentRule` (or nil)
 @param completionHandler Completion callback, with the ID of the newly created segment as the first and only argument
 @param errorHandler Error callback
 */
- (void)createSegmentWithListID:(NSString *)listID
                          title:(NSString *)title
                          rules:(NSArray *)rules
              completionHandler:(void (^)(NSString *segmentID))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Update an existing segment.
 
 http://www.campaignmonitor.com/api/segments/#updating_a_segment
 
 @param segmentID ID of the segment to be updated
 @param title Title of the segment
 @param rules An array of `CSSegmentRule` (or nil). Existing rules will be removed.
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)updateSegmentWithSegmentID:(NSString *)segmentID
                             title:(NSString *)title
                             rules:(NSArray *)rules
                 completionHandler:(void (^)(void))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Add a new rule to an existing segment
 
 http://www.campaignmonitor.com/api/segments/#adding_a_segment_rule
 
 @param segmentID ID of the segment to which the rule will be added
 @param rule Rule to add
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)addRuleToSegmentWithID:(NSString *)segmentID
                          rule:(CSSegmentRule *)rule
             completionHandler:(void (^)(void))completionHandler
                  errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Remove all rules from an existing segment.
 
 http://www.campaignmonitor.com/api/segments/#deleting_a_segments_rules
 
 @param segmentID ID of the segment whose rules are to be deleted
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)removeAllRulesFromSegmentWithID:(NSString *)segmentID
                      completionHandler:(void (^)(void))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get the name, list ID, segment ID, number of active subscribers and rules for a segment.
 
 http://www.campaignmonitor.com/api/segments/#getting_a_segments_details
 
 @param segmentID ID of the segment to be retrieved
 @param completionHandler Completion callback, with a `CSSegment` object as the first and only argument
 @param errorHandler Error callback
 */
- (void)getSegmentDetailsWithSegmentID:(NSString *)segmentID
                     completionHandler:(void (^)(CSSegment *segment))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all of the active subscribers that match the rules for a specific segment.
 
 http://www.campaignmonitor.com/api/segments/#getting_active_subscribers
 
 @param segmentID ID of the segment you want the active subscribers for
 @param date Subscribers which became active on or after the date specified will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are `CSSubscriber`.
 @param errorHandler Error callback
 */
- (void)getActiveSubscribersWithSegmentID:(NSString *)segmentID
                                     date:(NSDate *)date
                                     page:(NSUInteger)page
                                 pageSize:(NSUInteger)pageSize
                               orderField:(NSString *)orderField
                                ascending:(BOOL)ascending
                        completionHandler:(void (^)(CSPaginatedResult *))completionHandler
                             errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Delete an existing segment from a subscriber list.
 
 http://www.campaignmonitor.com/api/segments/#deleting_a_segment
 
 @param segmentID ID of the segment to be deleted
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)deleteSegmentWithID:(NSString *)segmentID
          completionHandler:(void (^)(void))completionHandler
               errorHandler:(CSAPIErrorHandler)errorHandler;


@end
