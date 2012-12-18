//
//  CSCampaignSummary.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSCampaignSummary.h"

@implementation CSCampaignSummary

+ (id)campaignSummaryWithDictionary:(NSDictionary *)campaignSummaryDictionary
{
    CSCampaignSummary *campaignSummary = [[self alloc] init];
    campaignSummary.recipientCount = [[campaignSummaryDictionary valueForKey:@"Recipients"] unsignedIntegerValue];
    campaignSummary.openedCount = [[campaignSummaryDictionary valueForKey:@"TotalOpened"] unsignedIntegerValue];
    campaignSummary.clickCount = [[campaignSummaryDictionary valueForKey:@"Clicks"] unsignedIntegerValue];
    campaignSummary.unsubscribedCount = [[campaignSummaryDictionary valueForKey:@"Unsubscribed"] unsignedIntegerValue];
    campaignSummary.bouncedCount = [[campaignSummaryDictionary valueForKey:@"Bounced"] unsignedIntegerValue];
    campaignSummary.uniqueOpenedCount = [[campaignSummaryDictionary valueForKey:@"UniqueOpened"] unsignedIntegerValue];
    campaignSummary.forwardsCount = [[campaignSummaryDictionary valueForKey:@"Forwards"] unsignedIntegerValue];
    campaignSummary.likesCount = [[campaignSummaryDictionary valueForKey:@"Likes"] unsignedIntegerValue];
    campaignSummary.mentionsCount = [[campaignSummaryDictionary valueForKey:@"Mentions"] unsignedIntegerValue];
    campaignSummary.webVersionPage = [campaignSummaryDictionary valueForKey:@"WebVersionURL"];
    campaignSummary.webVersionTextPage = [campaignSummaryDictionary valueForKey:@"WebVersionTextURL"];
    return campaignSummary;
}

@end
