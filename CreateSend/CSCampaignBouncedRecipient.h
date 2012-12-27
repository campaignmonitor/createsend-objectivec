//
//  CSCampaignBouncedRecipient.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSCampaignRecipient.h"

@interface CSCampaignBouncedRecipient : CSCampaignRecipient
@property (copy) NSString *bounceType;
@property (copy) NSString *reason;
@end
