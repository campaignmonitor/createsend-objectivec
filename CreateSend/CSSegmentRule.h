//
//  CSSegmentRule.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSegmentRule : NSObject
@property (copy) NSString *subject;
@property (strong) NSArray *clauses;

+ (id)segmentRuleWithSubject:(NSString *)subject clauses:(NSArray *)clauses;
+ (id)segmentRuleWithDictionary:(NSDictionary *)segmentRuleDictionary;

- (NSDictionary *)dictionaryValue;
@end
