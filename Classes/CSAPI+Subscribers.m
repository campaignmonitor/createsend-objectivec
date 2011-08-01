//
//  CSAPI+Subscribers.m
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI+Subscribers.h"

@implementation CSAPI (Subscribers)

- (void)subscribeToListWithID:(NSString *)listID
                 emailAddress:(NSString *)emailAddress
                         name:(NSString *)name
            shouldResubscribe:(BOOL)shouldResubscribe
            customFieldValues:(NSArray *)customFieldValues
            completionHandler:(void (^)(NSString* subscribedAddress))completionHandler
                 errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"subscribers/%@", listID]];
  
  NSDictionary* requestObject = [[[CSSubscriber dictionaryWithEmailAddress:emailAddress
                                                                      name:name
                                                         customFieldValues:customFieldValues] mutableCopy] autorelease];
  [requestObject setValue:[NSNumber numberWithBool:shouldResubscribe]
                   forKey:@"Resubscribe"];
  
  request.requestObject = requestObject;
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)updateSubscriptionWithListID:(NSString *)listID
                currentEmailAdddress:(NSString *)currentEmailAdddress
                     newEmailAddress:(NSString *)newEmailAddress
                                name:(NSString *)name
                   shouldResubscribe:(BOOL)shouldResubscribe
                   customFieldValues:(NSArray *)customFieldValues
                   completionHandler:(void (^)(void))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"subscribers/%@", listID]
                                                  queryParameters:[NSDictionary dictionaryWithObject:currentEmailAdddress
                                                                                              forKey:@"email"]];
  request.requestMethod = @"PUT";
  
  NSDictionary* requestObject = [[[CSSubscriber dictionaryWithEmailAddress:newEmailAddress
                                                                      name:name
                                                         customFieldValues:customFieldValues] mutableCopy] autorelease];
  [requestObject setValue:[NSNumber numberWithBool:shouldResubscribe]
                   forKey:@"Resubscribe"];
  
  request.requestObject = requestObject;
  
  [request setCompletionBlock:completionHandler];
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)unsubscribeFromListWithID:(NSString *)listID
                     emailAddress:(NSString *)emailAddress
                completionHandler:(void (^)(void))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"subscribers/%@/unsubscribe", listID]];
  request.requestObject = [NSDictionary dictionaryWithObject:emailAddress
                                                      forKey:@"EmailAddress"];
  
  [request setCompletionBlock:completionHandler];
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getSubscriberDetailsWithEmailAddress:(NSString *)emailAddress
                                      listID:(NSString *)listID
                           completionHandler:(void (^)(CSSubscriber* subscriber))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"subscribers/%@", listID]
                                                  queryParameters:[NSDictionary dictionaryWithObject:emailAddress
                                                                                              forKey:@"email"]];
  
  [request setCompletionBlock:^{
    CSSubscriber* subscriber = [CSSubscriber subscriberWithDictionary:request.parsedResponse];
    completionHandler(subscriber);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)getSubscriberHistoryWithEmailAddress:(NSString *)emailAddress
                                      listID:(NSString *)listID
                           completionHandler:(void (^)(NSDictionary* historyData))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"subscribers/%@/history", listID]
                                                  queryParameters:[NSDictionary dictionaryWithObject:emailAddress
                                                                                              forKey:@"email"]];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

- (void)importSubscribersToListWithID:(NSString *)listID
                       subscriberData:(NSArray *)subscriberData
                    shouldResubscribe:(BOOL)shouldResubscribe
                    completionHandler:(void (^)(NSDictionary* responseObject))completionHandler
                         errorHandler:(CSAPIErrorHandler)errorHandler {
  
  __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                             slug:[NSString stringWithFormat:@"subscribers/%@/import", listID]];
  
  request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                           subscriberData, @"Subscribers",
                           [NSNumber numberWithBool:shouldResubscribe], @"Resubscribe",
                           nil];
  
  [request setCompletionBlock:^{
    completionHandler(request.parsedResponse);
  }];
  
  [request setFailedBlock:^{ errorHandler(request.error); }];
  [request startAsynchronous];
}

@end
