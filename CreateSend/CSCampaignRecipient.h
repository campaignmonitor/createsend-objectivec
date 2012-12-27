//
//  CSCampaignRecipient.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSCampaignRecipient : NSObject
@property (copy) NSString *emailAddress;
@property (copy) NSString *listID;
@property (strong) NSDate *date;
@property (copy) NSString *IPAddress;
@property (assign) float latitude;
@property (assign) float longitude;
@property (copy) NSString *city;
@property (copy) NSString *region;
@property (copy) NSString *countryCode;
@property (copy) NSString *countryName;

- (id)initWithDictionary:(NSDictionary *)recipientDictionary;
@end
