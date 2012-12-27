//
//  CSPaginatedResult.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSPaginatedResult.h"

@implementation CSPaginatedResult
+ (id)paginatedResultOfClass:(Class)class withDictionary:(NSDictionary *)resultDictionary
{
    CSPaginatedResult *result = [[self alloc] init];
    
    NSArray *dictionaryResults = [resultDictionary valueForKey:@"Results"];
    __block NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:dictionaryResults.count];
    [dictionaryResults enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL *stop) {
        if (class != [NSDictionary class]) {
            [results addObject:[[class alloc] initWithDictionary:dictionary]];
        } else {
            [results addObject:dictionary];
        }
    }];
    result.results = [[NSArray alloc] initWithArray:results];
    
    result.orderedBy = [resultDictionary valueForKey:@"ResultsOrderedBy"];
    result.ascending = [[resultDictionary valueForKey:@"OrderDirection"] isEqualToString:@"asc"];
    result.page = [[resultDictionary valueForKey:@"PageNumber"] integerValue];
    result.pageSize = [[resultDictionary valueForKey:@"PageSize"] integerValue];
    
    result.resultCount = [[resultDictionary valueForKey:@"RecordsOnThisPage"] integerValue];
    result.totalResultCount = [[resultDictionary valueForKey:@"TotalNumberOfRecords"] integerValue];
    result.totalPages = [[resultDictionary valueForKey:@"NumberOfPages"] integerValue];
    
    return result;
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.results objectAtIndex:index];
}
@end
