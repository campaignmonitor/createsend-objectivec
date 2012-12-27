//
//  CSListForSubscriber.h
//  CreateSend
//
//  Created by James Dennes on 27/12/12.
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSListForSubscriber : NSObject
@property (copy) NSString *listID;
@property (copy) NSString *name;
@property (copy) NSString *subscriberState;
@property (strong) NSDate *dateSubscriberAdded;

+ (id)listWithDictionary:(NSDictionary *)listDictionary;

@end
