//
//  CSSubscriber.m
//  CreateSend
//
//  Created by Nathan de Vries on 22/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSSubscriber.h"


@implementation CSSubscriber


@synthesize emailAddress=_emailAddress;
@synthesize name=_name;
@synthesize date=_date;
@synthesize state=_state;
@synthesize customFieldValues=_customFieldValues;
@synthesize resubscribe=_resubscribe;


+ (id)subscriberWithDictionary:(NSDictionary *)subscriberDict {
  return [self subscriberWithEmailAddress:[subscriberDict valueForKey:@"EmailAddress"]
                                     name:[subscriberDict valueForKey:@"Name"]
                        customFieldValues:[subscriberDict valueForKey:@"CustomFields"]];
}


+ (id)subscriberWithEmailAddress:(NSString *)emailAddress
                            name:(NSString *)name
               customFieldValues:(NSArray *)customFieldValues {

  CSSubscriber* subscriber = [[[CSSubscriber alloc] init] autorelease];
  subscriber.emailAddress = emailAddress;
  subscriber.name = name;
  subscriber.customFieldValues = customFieldValues;

  return subscriber;
}


- (void)dealloc {
  [_emailAddress release];
  [_name release];
  [_date release];
  [_state release];
  [_customFieldValues release];

  [super dealloc];
}



@end
