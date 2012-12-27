//
//  CSSegment.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSSegment.h"
#import "CSSegmentRule.h"

@implementation CSSegment

+ (id)segmentWithDictionary:(NSDictionary *)segmentDictionary
{
    CSSegment *segment = [[self alloc] init];
    segment.segmentID = [segmentDictionary valueForKey:@"SegmentID"];
    segment.listID = [segmentDictionary valueForKey:@"ListID"];
    segment.title = [segmentDictionary valueForKey:@"Title"];
    segment.activeSubscriberCount = [[segmentDictionary valueForKey:@"ActiveSubscribers"] unsignedIntegerValue];
    
    __block NSMutableArray *rules = [[NSMutableArray alloc] init];
    [[segmentDictionary valueForKey:@"Rules"] enumerateObjectsUsingBlock:^(NSDictionary *segmentRuleDictionary, NSUInteger idx, BOOL *stop) {
        CSSegmentRule *segmentRule = [CSSegmentRule segmentRuleWithDictionary:segmentRuleDictionary];
        [rules addObject:segmentRule];
    }];
    segment.rules = [[NSArray alloc] initWithArray:rules];
    
    return segment;
}

@end
