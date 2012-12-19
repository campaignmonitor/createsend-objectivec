//
//  CSCampaignEmailClient.h
//  CreateSend
//
//  Created by James Dennes on 19/12/12.
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSCampaignEmailClient : NSObject

@property (copy) NSString *client;
@property (copy) NSString *version;
@property (assign) float percentage;
@property (assign) NSUInteger subscribers;

+ (id)campaignEmailClientWithDictionary:(NSDictionary *)campaignEmailClientDictionary;

@end
