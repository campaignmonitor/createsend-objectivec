//
//  CSClient.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSClient : NSObject
@property (copy) NSString *clientID;
@property (copy) NSString *name;
@property (copy) NSString *APIKey;
@property (copy) NSString *username;
@property (assign) NSUInteger accessLevel;
@property (copy) NSString *contactName;
@property (copy) NSString *emailAddress;
@property (copy) NSString *country;
@property (copy) NSString *timezone;
@property (assign) BOOL canPurchaseCredits;
@property (assign) NSUInteger credits;
@property (assign) BOOL clientPays;
@property (assign) float markupOnDesignSpamTest;
@property (assign) float baseRatePerRecipient;
@property (assign) float markupPerRecipient;
@property (assign) float markupOnDelivery;
@property (assign) float baseDeliveryRate;
@property (assign) float baseDesignSpamTestRate;
@property (copy) NSString *currency;
@property (copy) NSString *monthlyScheme;
    
+ (id)clientWithDictionary:(NSDictionary *)clientDictionary;
@end
