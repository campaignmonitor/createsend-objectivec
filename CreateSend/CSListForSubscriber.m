//
//  CSListForSubscriber.m
//  CreateSend
//
//  Created by James Dennes on 27/12/12.
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSListForSubscriber.h"

@implementation CSListForSubscriber

+ (id)listWithDictionary:(NSDictionary *)listDictionary
{
    CSListForSubscriber *list = [[CSListForSubscriber alloc] init];
    list.listID = [listDictionary valueForKey:@"ListID"];
    list.name = [listDictionary valueForKey:@"ListName"];
    list.subscriberState = [listDictionary valueForKey:@"SubscriberState"];
    list.dateSubscriberAdded = [[CSAPI sharedDateFormatter] dateFromString:[listDictionary valueForKey:@"DateSubscriberAdded"]];
    return list;
}

@end