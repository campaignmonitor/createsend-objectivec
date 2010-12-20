//
//  CSListStatsRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 20/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSListStatsRequest.h"


@implementation CSListStatsRequest


@synthesize listStatistics=_listStatistics;


+ (id)requestWithListID:(NSString *)listID {
  return [self requestWithAPISlug:[NSString stringWithFormat:@"lists/%@/stats", listID]];
}


- (void)handleParsedResponse {
  self.listStatistics = self.parsedResponse;
}


- (void)dealloc {
  [_listStatistics release];

  [super dealloc];
}


@end
