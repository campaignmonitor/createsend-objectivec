//
//  CSAPI+Subscribers.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSAPI+Subscribers.h"
#import "NSString+URLEncoding.h"

NSString * const CSAPIErrorSubscriberImportResultKey = @"CSAPIErrorSubscriberImportResultKey";

@implementation CSAPI (Subscribers)
- (void)subscribeToListWithID:(NSString *)listID
                 emailAddress:(NSString *)emailAddress
                         name:(NSString *)name
            shouldResubscribe:(BOOL)shouldResubscribe
                 customFields:(NSArray *)customFields
            completionHandler:(void (^)(NSString *subscribedAddress))completionHandler
                 errorHandler:(CSAPIErrorHandler)errorHandler
{

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CSSubscriber dictionaryWithEmailAddress:emailAddress name:name customFieldValues:[customFields valueForKey:@"dictionaryValue"]]];
    [parameters setObject:@(shouldResubscribe) forKey:@"Resubscribe"];
    [self.restClient post:[NSString stringWithFormat:@"subscribers/%@.json", listID] withParameters:parameters success:completionHandler failure:errorHandler];
}

- (void)updateSubscriptionWithListID:(NSString *)listID
                 currentEmailAddress:(NSString *)currentEmailAddress
                     newEmailAddress:(NSString *)newEmailAddress
                                name:(NSString *)name
                   shouldResubscribe:(BOOL)shouldResubscribe
                        customFields:(NSArray *)customFields
                   completionHandler:(void (^)(void))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CSSubscriber dictionaryWithEmailAddress:newEmailAddress name:name customFieldValues:[customFields valueForKey:@"dictionaryValue"]]];
    [parameters setObject:@(shouldResubscribe) forKey:@"Resubscribe"];
    [self.restClient put:[NSString stringWithFormat:@"subscribers/%@.json?email=%@", listID, [currentEmailAddress cs_urlEncodedString]] withParameters:parameters success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)unsubscribeFromListWithID:(NSString *)listID
                     emailAddress:(NSString *)emailAddress
                completionHandler:(void (^)(void))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient post:[NSString stringWithFormat:@"subscribers/%@/unsubscribe.json", listID] withParameters:@{@"EmailAddress": emailAddress} success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];    
}

- (void)getSubscriberDetailsWithListID:(NSString *)listID
                          emailAddress:(NSString *)emailAddress
                     completionHandler:(void (^)(CSSubscriber *subscriber))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"subscribers/%@.json", listID] withParameters:@{@"email": emailAddress} success:^(NSDictionary *response) {
        CSSubscriber *subscriber = [CSSubscriber subscriberWithDictionary:response];
        if (completionHandler) completionHandler(subscriber);
    } failure:errorHandler];
}

- (void)getSubscriberHistoryWithListID:(NSString *)listID
                          emailAddress:(NSString *)emailAddress
                     completionHandler:(void (^)(NSArray *historyItems))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler

{
    [self.restClient get:[NSString stringWithFormat:@"subscribers/%@/history.json", listID] withParameters:@{@"email": emailAddress} success:^(NSArray *response) {
        __block NSMutableArray *historyItems = [[NSMutableArray alloc] initWithCapacity:response.count];
        [response enumerateObjectsUsingBlock:^(NSDictionary *subscriberHistoryItemDictionary, NSUInteger idx, BOOL *stop) {
            CSSubscriberHistoryItem *subscriberHistoryItem = [CSSubscriberHistoryItem subscriberHistoryItemWithDictionary:subscriberHistoryItemDictionary];
            [historyItems addObject:subscriberHistoryItem];
        }];
        if (completionHandler) completionHandler([[NSArray alloc] initWithArray:historyItems]);
    } failure:errorHandler];
}

- (void)importSubscribersToListWithID:(NSString *)listID
                          subscribers:(NSArray *)subscribers
                    shouldResubscribe:(BOOL)shouldResubscribe
shouldQueueSubscriptionBasedAutoresponders:(BOOL)shouldQueueSubscriptionBasedAutoresponders
shouldRestartSubscriptionBasedAutoresponders:(BOOL)shouldRestartSubscriptionBasedAutoresponders
                    completionHandler:(void (^)(CSSubscriberImportResult *subscriberImportResult))completionHandler
                         errorHandler:(CSAPIErrorHandler)errorHandler
{
    __block NSMutableArray *subscriberDictionaries = [[NSMutableArray alloc] initWithCapacity:subscribers.count];
    [subscribers enumerateObjectsUsingBlock:^(CSSubscriber *subscriber, NSUInteger idx, BOOL *stop) {
        NSArray *customFieldValues = [subscriber.customFields valueForKey:@"dictionaryValue"];
        [subscriberDictionaries addObject:[CSSubscriber dictionaryWithEmailAddress:subscriber.emailAddress name:subscriber.name customFieldValues:customFieldValues]];
    }];
    
    NSDictionary *parameters = @{@"Subscribers": subscriberDictionaries, @"Resubscribe": @(shouldResubscribe), @"QueueSubscriptionBasedAutoResponders": @(shouldQueueSubscriptionBasedAutoresponders), @"RestartSubscriptionBasedAutoresponders": @(shouldRestartSubscriptionBasedAutoresponders)};
    [self.restClient post:[NSString stringWithFormat:@"subscribers/%@/import.json", listID] withParameters:parameters success:^(NSDictionary *response) {
        CSSubscriberImportResult *subscriberImportResult = [CSSubscriberImportResult subscriberImportResultWithDictionary:response];
        if (completionHandler) completionHandler(subscriberImportResult);
    } failure:^(NSError *error) {
        NSDictionary *resultData = [[error userInfo] objectForKey:CSAPIErrorResultDataKey];
        if (resultData) {
            CSSubscriberImportResult *subscriberImportResult = [CSSubscriberImportResult subscriberImportResultWithDictionary:resultData];
            error = [[NSError alloc] initWithDomain:[error domain] code:[error code] userInfo:@{NSLocalizedDescriptionKey: [error localizedDescription], CSAPIErrorSubscriberImportResultKey: subscriberImportResult}];
        }
        
        if (errorHandler) errorHandler(error);
    }];
}
@end
