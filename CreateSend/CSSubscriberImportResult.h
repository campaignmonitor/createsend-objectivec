//
//  CSSubscriberImportResult.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSubscriberImportResult : NSObject
@property (assign) NSUInteger totalUniqueEmailsSubmitted;
@property (assign) NSUInteger totalExistingSubscribers;
@property (assign) NSUInteger totalNewSubscribers;
@property (strong) NSArray *duplicateEmailsInSubmission;
@property (strong) NSArray *failureDetails;

+ (id)subscriberImportResultWithDictionary:(NSDictionary *)subscriberImportResultDictionary;
@end
