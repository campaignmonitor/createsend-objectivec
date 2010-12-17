//
//  CSSystemDateRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSSystemDateRequest.h"


@implementation CSSystemDateRequest


@synthesize systemDate=_systemDate;


+ (id)request {
  return [self requestWithAPISlug:@"systemdate"];
}


- (void)handleParsedResponse {
  NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
  NSLocale* locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
  [formatter setLocale:locale];
  formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

  self.systemDate = [formatter dateFromString:[self.parsedResponse valueForKey:@"SystemDate"]];
}


- (void)dealloc {
  [_systemDate release];

  [super dealloc];
}


@end
