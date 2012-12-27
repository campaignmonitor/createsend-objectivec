//
//  CSWebhook.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSWebhook.h"

@implementation CSWebhook

+ (id)webhookWithDictionary:(NSDictionary *)webhookDictionary
{
    CSWebhook *webhook = [[self alloc] init];
    webhook.webhookID = [webhookDictionary valueForKey:@"WebhookID"];
    webhook.url = [webhookDictionary valueForKey:@"Url"];
    webhook.status = [webhookDictionary valueForKey:@"Status"];
    webhook.payloadFormat = [webhookDictionary valueForKey:@"PayloadFormat"];
    webhook.events = [webhookDictionary valueForKey:@"Events"];
    return webhook;
}

@end
