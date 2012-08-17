//
//  CSSubscriberHistoryItem.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSSubscriberHistoryItem.h"
#import "CSSubscriberAction.h"

@implementation CSSubscriberHistoryItem

+ (id)subscriberHistoryItemWithDictionary:(NSDictionary *)subscriberHistoryItemDictionary
{
    CSSubscriberHistoryItem *action = [[self alloc] init];
    action.typeID = [subscriberHistoryItemDictionary valueForKey:@"ID"];
    action.type = [subscriberHistoryItemDictionary valueForKey:@"Type"];
    action.name = [subscriberHistoryItemDictionary valueForKey:@"Name"];
    
    __block NSMutableArray *actions = [[NSMutableArray alloc] init];
    [[subscriberHistoryItemDictionary valueForKey:@"Actions"] enumerateObjectsUsingBlock:^(NSDictionary *subscriberActionDictionary, NSUInteger idx, BOOL *stop) {
        CSSubscriberAction *action = [CSSubscriberAction subscriberActionWithDictionary:subscriberActionDictionary];
        [actions addObject:action];
    }];
    
    action.actions = [[NSArray alloc] initWithArray:actions];
    return action;
}
@end
