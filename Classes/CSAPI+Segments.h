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

/*
 
 TODO: These APIs are yet to be implemented
 
   POST http://api.createsend.com/api/v3/segments/{listid}.{xml|json}
    PUT http://api.createsend.com/api/v3/segments/{segmentid}.{xml|json}
   POST http://api.createsend.com/api/v3/segments/{segmentid}/rules.{xml|json}
    GET http://api.createsend.com/api/v3/segments/{segmentid}.{xml|json}
    GET http://api.createsend.com/api/v3/segments/{segmentid}/active.{xml|json}?date={YYYY-MM-DD}&page={pagenumber}&...
 DELETE http://api.createsend.com/api/v3/segments/{segmentid}.{xml|json}
 DELETE http://api.createsend.com/api/v3/segments/{segmentid}/rules.{xml|json}
 
 */

@end
