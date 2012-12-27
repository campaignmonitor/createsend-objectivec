//
//  CSSegment.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSegment : NSObject
@property (copy) NSString *segmentID;
@property (copy) NSString *listID;
@property (copy) NSString *title;
@property (strong) NSArray *rules;
@property (assign) NSUInteger activeSubscriberCount;

+ (id)segmentWithDictionary:(NSDictionary *)segmentDictionary;
@end
