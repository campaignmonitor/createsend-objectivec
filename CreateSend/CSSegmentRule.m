//
//  CSSegmentRule.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSSegmentRule.h"

@implementation CSSegmentRule

+ (id)segmentRuleWithSubject:(NSString *)subject clauses:(NSArray *)clauses
{
    CSSegmentRule *segmentRule = [[self alloc] init];
    segmentRule.subject = subject;
    segmentRule.clauses = clauses;
    return segmentRule;
}

+ (id)segmentRuleWithDictionary:(NSDictionary *)segmentRuleDictionary
{
    return [self segmentRuleWithSubject:[segmentRuleDictionary valueForKey:@"Subject"] clauses:[segmentRuleDictionary valueForKey:@"Clauses"]];
}

- (NSDictionary *)dictionaryValue
{
    return @{@"Subject": self.subject, @"Clauses": self.clauses};
}
@end
