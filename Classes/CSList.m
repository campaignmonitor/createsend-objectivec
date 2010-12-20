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
@synthesize title=_title;
@synthesize unsubscribePage=_unsubscribePage;
@synthesize confirmationSuccessPage=_confirmationSuccessPage;
@synthesize confirmOptIn=_confirmOptIn;


+ (id)listWithDictionary:(NSDictionary *)listDict {
  CSList* list = [[[self alloc] init] autorelease];
  list.listID = [listDict valueForKey:@"ListID"];

  list.title = [listDict valueForKey:@"Title"] ?: [listDict valueForKey:@"Name"];

  list.unsubscribePage = [listDict valueForKey:@"UnsubscribePage"];
  list.confirmationSuccessPage = [listDict valueForKey:@"ConfirmationSuccessPage"];
  list.confirmOptIn = [[listDict valueForKey:@"ConfirmedOptIn"] boolValue];

  return list;
}


- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ listID='%@' title='%@' "
          "unsubscribePage='%@' confirmationSuccessPage='%@' confirmOptIn=%@>",
          [self class], self.listID, self.title, self.unsubscribePage,
          self.confirmationSuccessPage, self.confirmOptIn ? @"YES" : @"NO"];
}


- (void)dealloc {
  [_listID release];
  [_title release];
  [_unsubscribePage release];
  [_confirmationSuccessPage release];

  [super dealloc];
}


@end
