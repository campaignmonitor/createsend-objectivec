//
//  CSSubscriber.m
//  CreateSend
//
//  Created by Nathan de Vries on 22/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSSubscriber.h"
#import "CSAPIRequest.h"

@implementation CSSubscriber


@synthesize emailAddress=_emailAddress;
@synthesize name=_name;
@synthesize date=_date;
@synthesize state=_state;
@synthesize customFieldValues=_customFieldValues;


+ (id)subscriberWithEmailAddress:(NSString *)emailAddress
                            name:(NSString *)name
               customFieldValues:(NSArray *)customFieldValues {

  CSSubscriber* subscriber = [[[CSSubscriber alloc] init] autorelease];
  subscriber.emailAddress = emailAddress;
  subscriber.name = name;
  subscriber.customFieldValues = customFieldValues;

  return subscriber;
}


+ (id)subscriberWithDictionary:(NSDictionary *)subscriberDict {
  CSSubscriber* subscriber = [self subscriberWithEmailAddress:[subscriberDict valueForKey:@"EmailAddress"]
                                                         name:[subscriberDict valueForKey:@"Name"]
                                            customFieldValues:[subscriberDict valueForKey:@"CustomFields"]];

  subscriber.state = [subscriberDict valueForKey:@"State"];

  NSDateFormatter* formatter = [CSAPIRequest sharedDateFormatter];
  subscriber.date = [formatter dateFromString:[subscriberDict valueForKey:@"Date"]];

  return subscriber;
}


+ (NSDictionary *)dictionaryWithEmailAddress:(NSString *)emailAddress
                                        name:(NSString *)name
                           customFieldValues:(NSArray *)customFieldValues {

  return [NSDictionary dictionaryWithObjectsAndKeys:
          emailAddress, @"EmailAddress",
          name, @"Name",
          customFieldValues ?: [NSArray array], @"CustomFields",
          nil];
}


- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ emailAddress='%@' name='%@' "
          "date='%@' state='%@' customFieldValues=%@>",
          [self class], self.emailAddress, self.name, self.date, self.state,
          self.customFieldValues];
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
