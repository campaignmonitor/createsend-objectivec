//
//  CSCampaign.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSCampaign : NSObject
@property (copy) NSString *campaignID;
@property (copy) NSString *name;
@property (copy) NSString *subject;
@property (copy) NSString *webVersionPage;
@property (copy) NSString *previewPage;
@property (strong) NSDate *dateCreated;
@property (strong) NSDate *dateScheduled;
@property (copy) NSString *scheduledTimeZone;
@property (strong) NSDate *dateSent;
@property (assign) NSUInteger totalRecipients;

+ (id)campaignWithDictionary:(NSDictionary *)campaignDictionary;
@end
