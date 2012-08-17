//
//  CSClient.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSClient.h"

@implementation CSClient

+ (id)clientWithDictionary:(NSDictionary *)clientDictionary
{
    CSClient *client = [[self alloc] init];
    client.clientID = [clientDictionary valueForKey:@"ClientID"];
    client.name = [clientDictionary valueForKey:@"Name"];
    
    client.APIKey = [clientDictionary valueForKey:@"ApiKey"];
    
    NSDictionary *accessDetails = [clientDictionary valueForKey:@"AccessDetails"];
    if (accessDetails) {
        client.username = [accessDetails valueForKey:@"Username"];
        client.accessLevel = [[accessDetails valueForKey:@"AccessLevel"] unsignedIntegerValue];
    }
    
    NSDictionary *basicDetails = [clientDictionary valueForKey:@"BasicDetails"];
    if (basicDetails) {
        client.clientID = [basicDetails valueForKey:@"ClientID"];
        client.name = [basicDetails valueForKey:@"CompanyName"];
        client.contactName = [basicDetails valueForKey:@"ContactName"];
        client.emailAddress = [basicDetails valueForKey:@"EmailAddress"];
        client.country = [basicDetails valueForKey:@"Country"];
        client.timezone = [basicDetails valueForKey:@"TimeZone"];
    }
    
    NSDictionary *billingDetails = [clientDictionary valueForKey:@"BillingDetails"];
    if (billingDetails) {
        client.canPurchaseCredits = [[billingDetails valueForKey:@"CanPurchaseCredits"] boolValue];
        client.markupOnDesignSpamTest = [[billingDetails valueForKey:@"MarkupOnDesignSpamTest"] floatValue];
        client.clientPays = [[billingDetails valueForKey:@"ClientPays"] boolValue];
        client.baseRatePerRecipient = [[billingDetails valueForKey:@"BaseRatePerRecipient"] floatValue];
        client.markupPerRecipient = [[billingDetails valueForKey:@"MarkupPerRecipient"] floatValue];
        client.markupOnDelivery = [[billingDetails valueForKey:@"MarkupOnDelivery"] floatValue];
        client.baseDeliveryRate = [[billingDetails valueForKey:@"BaseDeliveryRate"] floatValue];
        client.baseDesignSpamTestRate = [[billingDetails valueForKey:@"BaseDesignSpamTestRate"] floatValue];
        client.currency = [billingDetails valueForKey:@"Currency"];
    }

    return client;
}

@end
