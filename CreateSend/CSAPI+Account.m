//
//  CSAPI+Account.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSAPI+Account.h"
#import "NSString+URLEncoding.h"
#import "NSData+Base64.h"

@implementation CSAPI (Account)

- (void)getAPIKeyWithSiteURL:(NSString *)siteURL username:(NSString *)username password:(NSString *)password completionHandler:(void (^)(NSString *APIKey))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSString *authorizationString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authorizationData = [authorizationString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authorizationHeader = [NSString stringWithFormat:@"Basic %@", [authorizationData cs_base64EncodedString]];

    NSMutableURLRequest *request = [self.restClient requestWithMethod:@"GET" path:@"apikey.json" parameters:@{@"siteurl": siteURL} headers:@{@"Authorization": authorizationHeader}];
    [self.restClient sendAsynchronousRequest:request success:^(NSDictionary *response) {
        NSString *APIKey = [response valueForKey:@"ApiKey"];
        if (completionHandler) completionHandler(APIKey);
    } failure:errorHandler];
}

- (void)getClients:(void (^)(NSArray *clients))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:@"clients.json" success:^(NSArray *response) {
        __block NSMutableArray *clients = [[NSMutableArray alloc] initWithCapacity:response.count];
        [response enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *clientDictionary = (NSDictionary *)obj;
            CSClient *client = [CSClient clientWithDictionary:clientDictionary];
            [clients addObject:client];
        }];
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:clients]);
        
    } failure:errorHandler];
}

- (void)getBillingDetails:(void (^)(CSBillingDetails *billingDetails))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:@"billingdetails.json" success:^(NSDictionary *response) {
        CSBillingDetails *billingDetails = [CSBillingDetails billingDetailsWithDictionary:response];
        if (completionHandler) completionHandler(billingDetails);
    } failure:errorHandler];
}

- (void)getCountries:(void (^)(NSArray *countries))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:@"countries.json" success:completionHandler failure:errorHandler];
}

- (void)getTimezones:(void (^)(NSArray* timezones))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:@"timezones.json" success:completionHandler failure:errorHandler];
}

- (void)getSystemDate:(void (^)(NSDate* systemDate))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:@"systemdate.json" success:^(NSDictionary *response) {
        NSDateFormatter *formatter = [CSAPI sharedDateFormatter];
        NSDate *systemDate = [formatter dateFromString:[response valueForKey:@"SystemDate"]];
        if (completionHandler) completionHandler(systemDate);
    } failure:errorHandler];
}

- (void)addAdministratorWithName:(NSString *)name
                    emailAddress:(NSString *)emailAddress
               completionHandler:(void (^)(NSString *administratorEmailAddress))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{
        @"Name": name,
        @"EmailAddress": emailAddress
    };
    
    [self.restClient post:@"admins.json" withParameters:parameters success:^(NSDictionary *response) {
        NSString *administratorEmailAddress = [response valueForKey:@"EmailAddress"];
        if (completionHandler) completionHandler(administratorEmailAddress);
    } failure:errorHandler];
}

- (void)updateAdministratorWithEmailAddress:(NSString *)currentEmailAddress
                                       name:(NSString *)name
                            newEmailAddress:(NSString *)newEmailAddress
                          completionHandler:(void (^)(NSString *administratorEmailAddress))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{
        @"Name": name,
        @"EmailAddress": newEmailAddress
    };
    
    [self.restClient put:[NSString stringWithFormat:@"admins.json?email=%@", [currentEmailAddress cs_urlEncodedString]] withParameters:parameters success:^(NSDictionary *response) {
        NSString *administratorEmailAddress = [response valueForKey:@"EmailAddress"];
        if (completionHandler) completionHandler(administratorEmailAddress);
    } failure:errorHandler];
}

- (void)getAdministrators:(void (^)(NSArray *administrators))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:@"admins.json" success:^(NSArray *response) {
        __block NSMutableArray *administrators = [[NSMutableArray alloc] initWithCapacity:response.count];
        [response enumerateObjectsUsingBlock:^(NSDictionary *administratorDictionary, NSUInteger idx, BOOL *stop) {
            CSAdministrator *administrator = [CSAdministrator administratorWithDictionary:administratorDictionary];
            [administrators addObject:administrator];
        }];
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:administrators]);
    } failure:errorHandler];
}

- (void)getAdministratorWithEmailAddress:(NSString *)emailAddress completionHandler:(void (^)(CSAdministrator *administrator))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"admins.json?email=%@", [emailAddress cs_urlEncodedString]] success:^(NSDictionary *response) {
        CSAdministrator *administrator = [CSAdministrator administratorWithDictionary:response];
        if (completionHandler) completionHandler(administrator);
    } failure:errorHandler];
}

- (void)deleteAdministratorWithEmailAddress:(NSString *)emailAddress completionHandler:(void (^)(void))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient delete:[NSString stringWithFormat:@"admins.json?email=%@", [emailAddress cs_urlEncodedString]] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)setPrimaryContactWithEmailAddress:(NSString *)emailAddress completionHandler:(void (^)(NSString *primaryContactEmailAddress))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient put:[NSString stringWithFormat:@"primarycontact.json?email=%@", [emailAddress cs_urlEncodedString]] withParameters:nil success:^(NSDictionary *response) {
        NSString *primaryContactEmailAddress = [response valueForKey:@"EmailAddress"];
        if (completionHandler) completionHandler(primaryContactEmailAddress);
    } failure:errorHandler];
}

- (void)getPrimaryContact:(void (^)(NSString *primaryContactEmailAddress))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:@"primarycontact.json" success:^(NSString *response) {
        NSString *primaryContactEmailAddress = [response valueForKey:@"EmailAddress"];
        if (completionHandler) completionHandler(primaryContactEmailAddress);
    } failure:errorHandler];
}
@end
