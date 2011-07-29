//
//  CSPaginatedResult.m
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSPaginatedResult.h"

@implementation CSPaginatedResult

@synthesize results, orderedBy, ascending, page, pageSize, resultCount;
@synthesize totalResultCount, totalPages;

+ (id)resultWithDictionary:(NSDictionary *)resultDictionary {
  CSPaginatedResult* result = [[[self alloc] init] autorelease];
  
  result.results = [resultDictionary valueForKey:@"Results"];
  
  result.orderedBy = [resultDictionary valueForKey:@"ResultsOrderedBy"];
  result.ascending = [[resultDictionary valueForKey:@"OrderDirection"] isEqualToString:@"asc"];
  result.page = [[resultDictionary valueForKey:@"PageNumber"] integerValue];
  result.pageSize = [[resultDictionary valueForKey:@"PageSize"] integerValue];
  
  result.resultCount = [[resultDictionary valueForKey:@"RecordsOnThisPage"] integerValue];
  result.totalResultCount = [[resultDictionary valueForKey:@"TotalNumberOfRecords"] integerValue];
  result.totalPages = [[resultDictionary valueForKey:@"NumberOfPages"] integerValue];
  
  return result;
}

- (void)dealloc {
  [results release];
  
  [super dealloc];
}


@end
