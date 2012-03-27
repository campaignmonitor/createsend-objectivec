//
//  CSAPI+Segments.h
//  CreateSend
//
//  Created by Nathan de Vries on 30/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

/**
 Segment-related APIs. See CSAPI for documentation of the other API categories.
 */
#import "CSAPI.h"

@interface CSAPI (Segments)

/**
 Get a list of all segments belonging to a particular client.
 
     http://www.campaignmonitor.com/api/clients/#getting_client_segments
 
 @param clientID The ID of the client for which segments should be retrieved
 @param completionHandler Completion callback, with an array of segment
 dictionaries as the first and only argument. Dictionaries are in the following
 format:
 
     {
       "ListID": "a58ee1d3039b8bec838e6d1482a8a965",
       "SegmentID": "46aa5e01fd43381863d4e42cf277d3a9",
       "Title": "Segment One"
     }
 
 @param errorHandler Error callback
 */ 
- (void)getSegmentsWithClientID:(NSString *)clientID
              completionHandler:(void (^)(NSArray* segments))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Create a new segment for a specific list.
 
     http://www.campaignmonitor.com/api/segments/#creating_a_segment
 
 @param listID ID of the list on which the segment should be created
 @param title Title of the new segment
 @param rules A dictionary of rules (or nil)
 @param completionHandler Completion callback, with the ID of the newly created segment as the first and only argument
 @param errorHandler Error callback
 */
- (void)createSegmentWithListID:(NSString *)listID
                          title:(NSString *)title
                          rules:(NSDictionary *)rules
              completionHandler:(void (^)(NSString* segmentID))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Update an existing segment.
 
     http://www.campaignmonitor.com/api/segments/#updating_a_segment
 
 @param segmentID ID of the segment to be updated
 @param title Title of the segment
 @param rules A dictionary of rules (or nil). Existing rules will be removed.
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)updateSegmentWithSegmentID:(NSString *)segmentID
                             title:(NSString *)title
                             rules:(NSDictionary *)rules
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
                          rule:(NSDictionary *)rule
             completionHandler:(void (^)(void))completionHandler
                  errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Remove all rules from an existing segment.
 
     http://www.campaignmonitor.com/api/segments/#deleting_segment_rules
 
 @param segmentID ID of the segment whose rules are to be deleted
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)removeAllRulesFromSegmentWithID:(NSString *)segmentID
                      completionHandler:(void (^)(void))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get the name, list ID, segment ID, number of active subscribers and rules for a segment.
 
     http://www.campaignmonitor.com/api/segments/#getting_a_segment
 
 @param segmentID ID of the segment to be retrieved
 @param completionHandler Completion callback, with a segment dictionary as the
 first and only argument. The dictionary is in the following format:
 
     {
       "SegmentID": "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1",
       "ListID": "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1",
       "Title": "Segment Title",
       "ActiveSubscribers": 0,
       "Rules": [
         {
           "Subject": "Subject1",
           "Clauses": [
             "Clause1_1",
             "Clause1_2"
           ]
         },
         {
           "Subject": "Subject2",
           "Clauses": [
             "Clause2_1"
           ]
         }
       ]
     }
 
 @param errorHandler Error callback
 */
- (void)getSegmentDetailsWithSegmentID:(NSString *)segmentID
                     completionHandler:(void (^)(NSDictionary* segmentDetails))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a paged result representing all of the active subscribers that match the rules for a specific segment.
 
     http://www.campaignmonitor.com/api/segments/#getting_segment_subs
 
 @param segmentID ID of the segment you want the active subscribers for
 @param date Subscribers which became active on or after the date specified will be returned
 @param page The page to retrieve
 @param pageSize The number of subscribers to retrieve per page. Values accepted are between `10` and `1000`.
 @param orderField The subscriber field to order the list by. Values accepted are `email`, `name` or `date`.
 @param ascending Whether to sort the list (see `orderField`) in ascending order
 @param completionHandler Completion callback, with a `CSPaginatedResult` as the first and only argument. Items in the result list are in the following format:
 
     {
       "EmailAddress": "subs+7t8787Y@example.com",
       "Name": "Person One",
       "Date": "2010-10-25 10:28:00",
       "State": "Active",
       "CustomFields": [
         {
           "Key": "website",
           "Value": "http://example.com"
         },
         {
           "Key": "age",
           "Value": "24"
         },
         {
           "Key": "subscription date",
           "Value": "2010-03-09"
         }
       ]
     }
 
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
