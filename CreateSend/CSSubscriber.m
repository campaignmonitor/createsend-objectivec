//
//  CSSubscriber.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSSubscriber.h"
#import "CSCustomField.h"

@implementation CSSubscriber

+ (id)subscriberWithEmailAddress:(NSString *)emailAddress name:(NSString *)name customFields:(NSArray *)customFields
{
    CSSubscriber *subscriber = [[self alloc] init];
    subscriber.emailAddress = emailAddress;
    subscriber.name = name;
    subscriber.customFields = customFields;
    return subscriber;
}

+ (id)subscriberWithDictionary:(NSDictionary *)subscriberDictionary
{
    return [[self alloc] initWithDictionary:subscriberDictionary];
}

+ (NSDictionary *)dictionaryWithEmailAddress:(NSString *)emailAddress name:(NSString *)name customFieldValues:(NSArray *)customFieldValues
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (emailAddress) [dictionary setObject:emailAddress forKey:@"EmailAddress"];
    if (name) [dictionary setObject:name forKey:@"Name"];
    [dictionary setObject:(customFieldValues ?: @[]) forKey:@"CustomFields"];
    return [[NSDictionary alloc] initWithDictionary:dictionary];
}

- (id)initWithDictionary:(NSDictionary *)subscriberDictionary
{
    self = [super init];
    if (self) {
        _emailAddress = [subscriberDictionary valueForKey:@"EmailAddress"];
        _name = [subscriberDictionary valueForKey:@"Name"];
        _state = [subscriberDictionary valueForKey:@"State"];
        _date = [[CSAPI sharedDateFormatter] dateFromString:[subscriberDictionary valueForKey:@"Date"]];
        
        NSArray *customFieldValues = [subscriberDictionary valueForKey:@"CustomFields"];
        __block NSMutableArray *customFields = [[NSMutableArray alloc] initWithCapacity:customFieldValues.count];
        [customFieldValues enumerateObjectsUsingBlock:^(NSDictionary *customFieldDictionary, NSUInteger idx, BOOL *stop) {
            [customFields addObject:[CSCustomField customFieldWithDictionary:customFieldDictionary]];
        }];
        _customFields = [[NSArray alloc] initWithArray:customFields];
        _readsEmailWith = [subscriberDictionary valueForKey:@"ReadsEmailWith"];
    }
    return self;
}

@end
