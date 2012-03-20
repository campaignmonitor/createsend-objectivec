//
//  CSPaginatedResult.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

/**
 Wrapper class representing a "page" of data returned from the API.
 */
@interface CSPaginatedResult : NSObject

/** List of items in the result set that was returned from the API */
@property (copy) NSArray* results;

/** The field that the items have been ordered by */
@property (copy) NSString* orderedBy;

/** Whether or not the items are being sorted in ascending order */
@property (assign) BOOL ascending;

/** The page that this result set represents in the total result set */
@property (assign) NSUInteger page;

/** The number of items that were requested for this page of items */
@property (assign) NSUInteger pageSize;

/** The number of items returned in the result set */
@property (assign) NSUInteger resultCount;

/** The total number of items available */
@property (assign) NSUInteger totalResultCount;

/** The total number of pages available */
@property (assign) NSUInteger totalPages;

+ (id)resultWithDictionary:(NSDictionary *)resultDictionary;

@end
