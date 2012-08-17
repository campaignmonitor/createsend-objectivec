//
//  CSCampaignRecipient.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSCampaignRecipient.h"

@implementation CSCampaignRecipient

- (id)initWithDictionary:(NSDictionary *)recipientDictionary
{
    self = [super init];
    if (self) {
        _emailAddress = [recipientDictionary valueForKey:@"EmailAddress"];
        _listID = [recipientDictionary valueForKey:@"ListID"];
        
        NSString *dateString = [recipientDictionary valueForKey:@"Date"];
        if (dateString) {
            _date = [[CSAPI sharedDateFormatter] dateFromString:dateString];
        }
        
        _IPAddress = [recipientDictionary valueForKey:@"IPAddress"];
    }
    return self;
}

@end
