//
//  CSPaginatedResult.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

@interface CSPaginatedResult : NSObject

@property (copy) NSArray* results;

@property (copy) NSString* orderedBy;
@property (assign) BOOL ascending;

@property (assign) NSUInteger page;
@property (assign) NSUInteger pageSize;

@property (assign) NSUInteger resultCount;

@property (assign) NSUInteger totalResultCount;
@property (assign) NSUInteger totalPages;

+ (id)resultWithDictionary:(NSDictionary *)resultDictionary;

@end
