//
//  CSAPI+Clients.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSAPI+Clients.h"
#import "NSString+URLEncoding.h"

@implementation CSAPI (Clients)

- (void)createClientWithCompanyName:(NSString *)companyName
                        contactName:(NSString *)contactName
                       emailAddress:(NSString *)emailAddress
                            country:(NSString *)country
                           timezone:(NSString *)timezone
                  completionHandler:(void (^)(NSString *clientID))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{
        @"CompanyName": companyName,
        @"ContactName": contactName,
        @"EmailAddress": emailAddress,
        @"Country": country,
        @"TimeZone": timezone
    };
    
    [self.restClient post:@"clients.json" withParameters:parameters success:completionHandler failure:errorHandler];
}

- (void)updateClientWithClientID:(NSString *)clientID
                     companyName:(NSString *)companyName
                     contactName:(NSString *)contactName
                    emailAddress:(NSString *)emailAddress
                         country:(NSString *)country
                        timezone:(NSString *)timezone
               completionHandler:(void (^)(void))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{
        @"CompanyName": companyName,
        @"ContactName": contactName,
        @"EmailAddress": emailAddress,
        @"Country": country,
        @"TimeZone": timezone
    };
    
    [self.restClient put:[NSString stringWithFormat:@"clients/%@/setbasics.json", clientID] withParameters:parameters success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)deleteClientWithID:(NSString *)clientID
         completionHandler:(void (^)(void))completionHandler
              errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient delete:[NSString stringWithFormat:@"clients/%@.json", clientID] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)setClientPAYGBillingSettingsWithClientID:(NSString *)clientID
                                        currency:(NSString *)currency
                              canPurchaseCredits:(BOOL)canPurchaseCredits
                                      clientPays:(BOOL)clientPays
                                markupPercentage:(float)markupPercentage
                                markupOnDelivery:(float)markupOnDelivery
                              markupPerRecipient:(float)markupPerRecipient
                          markupOnDesignSpamTest:(float)markupOnDesignSpamTest
                               completionHandler:(void (^)(void))completionHandler
                                    errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{
        @"Currency": currency,
        @"CanPurchaseCredits": @(canPurchaseCredits),
        @"ClientPays": @(clientPays),
        @"MarkupPercentage": @(markupPercentage),
        @"MarkupOnDelivery": @(markupOnDelivery),
        @"MarkupPerRecipient": @(markupPerRecipient),
        @"MarkupOnDesignSpamTest": @(markupOnDesignSpamTest),
    };
    
    [self.restClient put:[NSString stringWithFormat:@"clients/%@/setpaygbilling.json", clientID] withParameters:parameters success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)setClientMonthlyBillingWithClientID:(NSString *)clientID
                                   currency:(NSString *)currency
                                 clientPays:(BOOL)clientPays
                           markupPercentage:(float)markupPercentage
                          completionHandler:(void (^)(void))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{
        @"Currency": currency,
        @"ClientPays": @(clientPays),
        @"MarkupPercentage": @(markupPercentage),
    };
    
    [self.restClient put:[NSString stringWithFormat:@"clients/%@/setmonthlybilling.json", clientID] withParameters:parameters success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)getClientDetailsWithClientID:(NSString *)clientID
                   completionHandler:(void (^)(CSClient *client))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"clients/%@.json", clientID] success:^(NSDictionary *response) {
        CSClient *client = [CSClient clientWithDictionary:response];
        if (completionHandler) completionHandler(client);
    } failure:errorHandler];
}

- (void)getCampaignsWithClientID:(NSString *)clientID
                                slug:(NSString *)slug
                   completionHandler:(void (^)(NSArray *campaigns))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"clients/%@/%@.json", clientID, slug] success:^(NSArray *response) {
        __block NSMutableArray *campaigns = [[NSMutableArray alloc] initWithCapacity:response.count];
        [response enumerateObjectsUsingBlock:^(NSDictionary *campaignDictionary, NSUInteger idx, BOOL *stop) {
            CSCampaign *campaign = [CSCampaign campaignWithDictionary:campaignDictionary];
            [campaigns addObject:campaign];
        }];
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:campaigns]);
    } failure:errorHandler];
}

- (void)getSentCampaignsWithClientID:(NSString *)clientID
                   completionHandler:(void (^)(NSArray *campaigns))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self getCampaignsWithClientID:clientID slug:@"campaigns" completionHandler:completionHandler errorHandler:errorHandler];
}

- (void)getScheduledCampaignsWithClientID:(NSString *)clientID
                        completionHandler:(void (^)(NSArray *campaigns))completionHandler
                             errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self getCampaignsWithClientID:clientID slug:@"scheduled" completionHandler:completionHandler errorHandler:errorHandler];
}

- (void)getDraftCampaignsWithClientID:(NSString *)clientID
                    completionHandler:(void (^)(NSArray *campaigns))completionHandler
                         errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self getCampaignsWithClientID:clientID slug:@"drafts" completionHandler:completionHandler errorHandler:errorHandler];
}

- (void)getSubscriberListsWithClientID:(NSString *)clientID
                     completionHandler:(void (^)(NSArray *subscriberLists))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"clients/%@/lists.json", clientID] success:^(NSArray *response) {
        __block NSMutableArray *lists = [[NSMutableArray alloc] initWithCapacity:response.count];
        [response enumerateObjectsUsingBlock:^(NSDictionary *listDictionary, NSUInteger idx, BOOL *stop) {
            CSList *list = [CSList listWithDictionary:listDictionary];
            [lists addObject:list];
        }];
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:lists]);
    } failure:errorHandler];
}

- (void)getSuppressionListWithClientID:(NSString *)clientID
                                  page:(NSUInteger)page
                              pageSize:(NSUInteger)pageSize
                            orderField:(NSString *)orderField
                             ascending:(BOOL)ascending
                     completionHandler:(void (^)(CSPaginatedResult *paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = [CSAPI paginationParametersWithPage:page pageSize:pageSize orderField:orderField ascending:ascending];
    
    [self.restClient get:[NSString stringWithFormat:@"clients/%@/suppressionlist.json", clientID] withParameters:parameters success:^(NSDictionary *response) {
        CSPaginatedResult *paginatedResult = [CSPaginatedResult paginatedResultOfClass:[CSSuppressedRecipient class] withDictionary:response];
        if (completionHandler) completionHandler(paginatedResult);
    } failure:errorHandler];
}

- (void)getSegmentsWithClientID:(NSString *)clientID
              completionHandler:(void (^)(NSArray *segments))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"clients/%@/segments.json", clientID] success:^(NSArray *response) {
        __block NSMutableArray *segments = [[NSMutableArray alloc] initWithCapacity:response.count];
        [response enumerateObjectsUsingBlock:^(NSDictionary *segmentDictionary, NSUInteger idx, BOOL *stop) {
            CSSegment *segment = [CSSegment segmentWithDictionary:segmentDictionary];
            [segments addObject:segment];
        }];
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:segments]);
    } failure:errorHandler];
}

- (void)getTemplatesWithClientID:(NSString *)clientID
               completionHandler:(void (^)(NSArray *templates))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"clients/%@/templates.json", clientID] success:^(NSArray *response) {
        __block NSMutableArray *templates = [[NSMutableArray alloc] initWithCapacity:response.count];
        [response enumerateObjectsUsingBlock:^(NSDictionary *templateDictionary, NSUInteger idx, BOOL *stop) {
            CSTemplate *template = [CSTemplate templateWithDictionary:templateDictionary];
            [templates addObject:template];
        }];
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:templates]);
    } failure:errorHandler];
}

- (void)addPersonWithClientID:(NSString *)clientID
                         name:(NSString *)name
                 emailAddress:(NSString *)emailAddress
                     password:(NSString *)password
                  accessLevel:(NSUInteger)accessLevel
            completionHandler:(void (^)(NSString *personEmailAddress))completionHandler
                 errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"Name": name,
        @"EmailAddress": emailAddress,
        @"AccessLevel": @(accessLevel)
    }];
    if (password) [parameters setObject:password forKey:@"Password"];
    
    [self.restClient post:[NSString stringWithFormat:@"clients/%@/people.json", clientID] withParameters:parameters success:^(NSDictionary *response) {
        NSString *personEmailAddress = [response valueForKey:@"EmailAddress"];
        if (completionHandler) completionHandler(personEmailAddress);
    } failure:errorHandler];
}

- (void)updatePersonWithClientID:(NSString *)clientID
                            name:(NSString *)name
             currentEmailAddress:(NSString *)currentEmailAddress
                 newEmailAddress:(NSString *)newEmailAddress
                        password:(NSString *)password
                     accessLevel:(NSUInteger)accessLevel
               completionHandler:(void (^)(NSString *personEmailAddress))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{
                                       @"Name": name,
                                       @"EmailAddress": newEmailAddress,
                                       @"AccessLevel": @(accessLevel)
                                       }];
    if (password) [parameters setObject:password forKey:@"Password"];
    
    [self.restClient put:[NSString stringWithFormat:@"clients/%@/people.json?email=%@", clientID, [currentEmailAddress cs_urlEncodedString]] withParameters:parameters success:^(NSDictionary *response) {
        NSString *personEmailAddress = [response valueForKey:@"EmailAddress"];
        if (completionHandler) completionHandler(personEmailAddress);
    } failure:errorHandler];
}

- (void)getPeopleWithClientID:(NSString *)clientID completionHandler:(void (^)(NSArray *people))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"clients/%@/people.json", clientID] success:^(NSArray *response) {
        __block NSMutableArray *people = [[NSMutableArray alloc] initWithCapacity:response.count];
        [response enumerateObjectsUsingBlock:^(NSDictionary *personDictionary, NSUInteger idx, BOOL *stop) {
            CSPerson *person = [CSPerson personWithDictionary:personDictionary];
            [people addObject:person];
        }];
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:people]);
    } failure:errorHandler];
}

- (void)getPersonDetailsWithClientID:(NSString *)clientID emailAddress:(NSString *)emailAddress completionHandler:(void (^)(CSPerson *person))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"clients/%@/people.json?email=%@", clientID, [emailAddress cs_urlEncodedString]] success:^(NSDictionary *response) {
        CSPerson *person = [CSPerson personWithDictionary:response];
        if (completionHandler) completionHandler(person);
    } failure:errorHandler];
}

- (void)deletePersonWithClientID:(NSString *)clientID emailAddress:(NSString *)emailAddress completionHandler:(void (^)(void))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient delete:[NSString stringWithFormat:@"clients/%@/people.json?email=%@", clientID, [emailAddress cs_urlEncodedString]] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)setPrimaryContactWithClientID:(NSString *)clientID emailAddress:(NSString *)emailAddress completionHandler:(void (^)(NSString *primaryContactEmailAddress))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient put:[NSString stringWithFormat:@"clients/%@/primarycontact.json?email=%@", clientID, [emailAddress cs_urlEncodedString]] withParameters:nil success:^(NSDictionary *response) {
        NSString *primaryContactEmailAddress = [response valueForKey:@"EmailAddress"];
        if (completionHandler) completionHandler(primaryContactEmailAddress);
    } failure:errorHandler];
}

- (void)getPrimaryContactWithClientID:(NSString *)clientID completionHandler:(void (^)(NSString *primaryContactEmailAddress))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"clients/%@/primarycontact.json", clientID] success:^(NSString *response) {
        NSString *primaryContactEmailAddress = [response valueForKey:@"EmailAddress"];
        if (completionHandler) completionHandler(primaryContactEmailAddress);
    } failure:errorHandler];
}
@end
