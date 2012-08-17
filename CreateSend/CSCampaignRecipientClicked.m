//
//  CSCampaignRecipientClicked.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSCampaignRecipientClicked.h"

@implementation CSCampaignRecipientClicked

- (id)initWithDictionary:(NSDictionary *)recipientDictionary
{
    self = [super initWithDictionary:recipientDictionary];
    if (self) {
        _URL = [NSURL URLWithString:[recipientDictionary valueForKey:@"URL"]];
    }
    return self;
}

@end
