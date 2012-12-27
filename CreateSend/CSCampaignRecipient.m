//
//  CSCampaignRecipient.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
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
        _latitude = [[recipientDictionary valueForKey:@"Latitude"] floatValue];
        _longitude = [[recipientDictionary valueForKey:@"Longitude"] floatValue];
        _city = [recipientDictionary valueForKey:@"City"];
        _region = [recipientDictionary valueForKey:@"Region"];
        _countryCode = [recipientDictionary valueForKey:@"CountryCode"];
        _countryName = [recipientDictionary valueForKey:@"CountryName"];
    }
    return self;
}

@end
