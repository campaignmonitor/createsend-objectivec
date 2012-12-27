//
//  CSSubscriberImportResult.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSSubscriberImportResult.h"

@implementation CSSubscriberImportResult

+ (id)subscriberImportResultWithDictionary:(NSDictionary *)subscriberImportResultDictionary
{
    CSSubscriberImportResult *importResult = [[self alloc] init];
    importResult.totalUniqueEmailsSubmitted = [[subscriberImportResultDictionary valueForKey:@"TotalUniqueEmailsSubmitted"] unsignedIntegerValue];
    importResult.totalExistingSubscribers = [[subscriberImportResultDictionary valueForKey:@"TotalExistingSubscribers"] unsignedIntegerValue];
    importResult.totalNewSubscribers = [[subscriberImportResultDictionary valueForKey:@"TotalNewSubscribers"] unsignedIntegerValue];
    importResult.duplicateEmailsInSubmission = [subscriberImportResultDictionary valueForKey:@"DuplicateEmailsInSubmission"];
    importResult.failureDetails = [subscriberImportResultDictionary valueForKey:@"FailureDetails"];
    return importResult;
}

@end
