//
//  CSSubscriber.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSubscriber : NSObject
@property (copy) NSString *emailAddress;
@property (copy) NSString *name;
@property (strong) NSDate *date;
@property (copy) NSString *state;
@property (strong) NSArray *customFields;
@property (copy) NSString *readsEmailWith;

+ (id)subscriberWithEmailAddress:(NSString *)emailAddress name:(NSString *)name customFields:(NSArray *)customFields;

+ (id)subscriberWithDictionary:(NSDictionary *)subscriberDictionary;

+ (NSDictionary *)dictionaryWithEmailAddress:(NSString *)emailAddress name:(NSString *)name customFieldValues:(NSArray *)customFieldValues;

- (id)initWithDictionary:(NSDictionary *)subscriberDictionary;

@end
