//
//  CSCampaignBouncedRecipient.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSCampaignRecipient.h"

@interface CSCampaignBouncedRecipient : CSCampaignRecipient
@property (copy) NSString *bounceType;
@property (copy) NSString *reason;
@end
