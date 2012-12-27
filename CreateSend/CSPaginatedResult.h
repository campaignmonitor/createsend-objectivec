//
//  CSPaginatedResult.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSPaginatedResult : NSObject
@property (strong) NSArray *results;
@property (copy) NSString *orderedBy;
@property (assign) BOOL ascending;
@property (assign) NSUInteger page;
@property (assign) NSUInteger pageSize;
@property (assign) NSUInteger resultCount;
@property (assign) NSUInteger totalResultCount;
@property (assign) NSUInteger totalPages;

+ (id)paginatedResultOfClass:(Class)class withDictionary:(NSDictionary *)resultDictionary;

- (id)objectAtIndex:(NSUInteger)index;
@end
