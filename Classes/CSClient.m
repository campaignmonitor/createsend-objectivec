//
//  CSClient.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSClient.h"


@implementation CSClient


@synthesize clientID=_clientID;
@synthesize name=_name;


+ (id)clientWithDictionary:(NSDictionary *)clientDict {
  CSClient* client = [[[self alloc] init] autorelease];
  client.clientID = [clientDict valueForKey:@"ClientID"];
  client.name = [clientDict valueForKey:@"Name"];
  return client;
}


- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ clientID='%@' name='%@'>",
          [self class], self.clientID, self.name];
}


- (void)dealloc {
  [_clientID release];
  [_name release];

  [super dealloc];
}


@end
