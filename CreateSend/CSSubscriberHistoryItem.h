//
//  CSSubscriberHistoryItem.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
            
@interface CSSubscriberHistoryItem : NSObject
@property (copy) NSString *typeID;
@property (copy) NSString *type;
@property (copy) NSString *name;
@property (strong) NSArray *actions;

+ (id)subscriberHistoryItemWithDictionary:(NSDictionary *)subscriberHistoryItemDictionary;
@end
