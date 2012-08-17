//
//  CSWebhook.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSWebhook : NSObject
@property (copy) NSString *webhookID;
@property (copy) NSString *url;
@property (copy) NSString *status;
@property (copy) NSString *payloadFormat;
@property (strong) NSArray *events;

+ (id)webhookWithDictionary:(NSDictionary *)webhookDictionary;
@end
