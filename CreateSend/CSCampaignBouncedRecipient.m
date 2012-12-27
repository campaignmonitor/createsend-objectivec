//
//  CSCampaignBouncedRecipient.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSCampaignBouncedRecipient.h"

@implementation CSCampaignBouncedRecipient

- (id)initWithDictionary:(NSDictionary *)recipientDictionary
{
    self = [super initWithDictionary:recipientDictionary];
    if (self) {
        _bounceType = [recipientDictionary valueForKey:@"BounceType"];
        _reason = [recipientDictionary valueForKey:@"Reason"];
    }
    return self;
}

@end
