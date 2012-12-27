//
//  CSSubscriberAction.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSSubscriberAction.h"

@implementation CSSubscriberAction

+ (id)subscriberActionWithDictionary:(NSDictionary *)subscriberActionDictionary
{
    CSSubscriberAction *action = [[self alloc] init];
    action.event = [subscriberActionDictionary valueForKey:@"Event"];
    action.date = [[CSAPI sharedDateFormatter] dateFromString:[subscriberActionDictionary valueForKey:@"Date"]];
    action.IPAddress = [subscriberActionDictionary valueForKey:@"IPAddress"];
    action.detail = [subscriberActionDictionary valueForKey:@"Detail"];
    return action;
}

@end
