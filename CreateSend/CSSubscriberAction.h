//
//  CSSubscriberAction.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSubscriberAction : NSObject
@property (copy) NSString *event;
@property (strong) NSDate *date;
@property (copy) NSString *IPAddress;
@property (copy) NSString *detail;

+ (id)subscriberActionWithDictionary:(NSDictionary *)subscriberActionDictionary;
@end
