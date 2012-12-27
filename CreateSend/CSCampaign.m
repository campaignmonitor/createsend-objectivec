//
//  CSCampaign.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSCampaign.h"

@implementation CSCampaign

+ (id)campaignWithDictionary:(NSDictionary *)campaignDictionary
{
    CSCampaign *campaign = [[self alloc] init];
    campaign.campaignID = [campaignDictionary valueForKey:@"CampaignID"];
    campaign.name = [campaignDictionary valueForKey:@"Name"];
    campaign.subject = [campaignDictionary valueForKey:@"Subject"];
    campaign.fromName = [campaignDictionary valueForKey:@"FromName"];
    campaign.fromEmail = [campaignDictionary valueForKey:@"FromEmail"];
    campaign.replyTo = [campaignDictionary valueForKey:@"ReplyTo"];
    
    campaign.webVersionPage = [campaignDictionary valueForKey:@"WebVersionURL"];
    campaign.webVersionTextPage = [campaignDictionary valueForKey:@"WebVersionTextURL"];
    campaign.previewPage = [campaignDictionary valueForKey:@"PreviewURL"];
    campaign.previewTextPage = [campaignDictionary valueForKey:@"PreviewTextURL"];
    
    NSString *dateCreatedString = [campaignDictionary valueForKey:@"DateCreated"];
    if (dateCreatedString) {
        campaign.dateCreated = [[CSAPI sharedDateFormatter] dateFromString:dateCreatedString];
    }
    
    NSString *dateScheduledString = [campaignDictionary valueForKey:@"DateScheduled"];
    if (dateScheduledString) {
        campaign.dateScheduled = [[CSAPI sharedDateFormatter] dateFromString:dateScheduledString];
    }
    campaign.scheduledTimeZone = [campaignDictionary valueForKey:@"ScheduledTimeZone"];
    
    NSString *dateSentString = [campaignDictionary valueForKey:@"SentDate"];
    if (dateSentString) {
        campaign.dateSent = [[CSAPI sharedDateFormatter] dateFromString:dateSentString];
    }
    campaign.totalRecipients = [[campaignDictionary valueForKey:@"TotalRecipients"] unsignedIntegerValue];
    
    return campaign;
}
@end
