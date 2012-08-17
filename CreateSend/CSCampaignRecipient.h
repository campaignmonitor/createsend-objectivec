//
//  CSCampaignRecipient.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSCampaignRecipient : NSObject
@property (copy) NSString *emailAddress;
@property (copy) NSString *listID;
@property (strong) NSDate *date;
@property (copy) NSString *IPAddress;

- (id)initWithDictionary:(NSDictionary *)recipientDictionary;
@end
