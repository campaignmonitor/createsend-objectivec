//
//  CSCampaignEmailClient.m
//  CreateSend
//
//  Created by James Dennes on 19/12/12.
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSCampaignEmailClient.h"

@implementation CSCampaignEmailClient

+ (id)campaignEmailClientWithDictionary:(NSDictionary *)campaignEmailClientDictionary
{
    CSCampaignEmailClient *ec = [[self alloc] init];
    ec.client = [campaignEmailClientDictionary valueForKey:@"Client"];
    ec.version = [campaignEmailClientDictionary valueForKey:@"Version"];
    ec.percentage = [[campaignEmailClientDictionary valueForKey:@"Percentage"] floatValue];
    ec.subscribers = [[campaignEmailClientDictionary valueForKey:@"Subscribers"] unsignedIntegerValue];

    return ec;
}

@end
