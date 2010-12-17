//
//  CSCountriesRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSCountriesRequest.h"


@implementation CSCountriesRequest


@synthesize countries=_countries;


+ (id)request {
  return [self requestWithAPISlug:@"countries"];
}


- (void)handleParsedResponse {
  self.countries = self.parsedResponse;
}


- (void)dealloc {
  [_countries release];

  [super dealloc];
}


@end
