//
//  CSList.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSList.h"


@implementation CSList


@synthesize listID=_listID;
@synthesize name=_name;


+ (id)listWithDictionary:(NSDictionary *)listDict {
  CSList* list = [[[self alloc] init] autorelease];
  list.listID = [listDict valueForKey:@"ListID"];
  list.name = [listDict valueForKey:@"Name"];
  return list;
}


- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ listID='%@' name='%@'>",
          [self class], self.listID, self.name];
}


- (void)dealloc {
  [_listID release];
  [_name release];

  [super dealloc];
}


@end
