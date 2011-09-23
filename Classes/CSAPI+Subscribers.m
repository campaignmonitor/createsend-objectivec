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
  
  NSMutableURLRequest* request = [self.restClient requestWithMethod:@"POST"
                                                               path:[NSString stringWithFormat:@"subscribers/%@.json", listID]
                                                         parameters:nil];
  
  NSDictionary* requestBodyObject = [[[CSSubscriber dictionaryWithEmailAddress:emailAddress
                                                                          name:name
                                                             customFieldValues:customFieldValues] mutableCopy] autorelease];
  
  [requestBodyObject setValue:[NSNumber numberWithBool:shouldResubscribe]
                       forKey:@"Resubscribe"];
  
  [request setHTTPBody:[requestBodyObject JSONData]];
  
  [self.restClient enqueueHTTPOperationWithRequest:request
                                           success:completionHandler
                                           failure:errorHandler];
}

- (void)updateSubscriptionWithListID:(NSString *)listID
                currentEmailAdddress:(NSString *)currentEmailAdddress
                     newEmailAddress:(NSString *)newEmailAddress
                                name:(NSString *)name
                   shouldResubscribe:(BOOL)shouldResubscribe
                   customFieldValues:(NSArray *)customFieldValues
                   completionHandler:(void (^)(void))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSMutableURLRequest* request = [self.restClient requestWithMethod:@"POST"
                                                               path:[NSString stringWithFormat:@"subscribers/%@.json", listID]
                                                         parameters:[NSDictionary dictionaryWithObject:currentEmailAdddress forKey:@"email"]];
  
  NSDictionary* requestBodyObject = [[[CSSubscriber dictionaryWithEmailAddress:newEmailAddress
                                                                          name:name
                                                             customFieldValues:customFieldValues] mutableCopy] autorelease];
  
  [requestBodyObject setValue:[NSNumber numberWithBool:shouldResubscribe]
                       forKey:@"Resubscribe"];
  
  [request setHTTPBody:[requestBodyObject JSONData]];
  
  [self.restClient enqueueHTTPOperationWithRequest:request
                                           success:^(id response) { completionHandler(); }
                                           failure:errorHandler];
}

- (void)unsubscribeFromListWithID:(NSString *)listID
                     emailAddress:(NSString *)emailAddress
                completionHandler:(void (^)(void))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSMutableURLRequest* request = [self.restClient requestWithMethod:@"POST"
                                                               path:[NSString stringWithFormat:@"subscribers/%@/unsubscribe.json", listID]
                                                         parameters:nil];
  
  NSDictionary* requestBodyObject = [NSDictionary dictionaryWithObject:emailAddress
                                                                forKey:@"EmailAddress"];
  
  [request setHTTPBody:[requestBodyObject JSONData]];
  
  [self.restClient enqueueHTTPOperationWithRequest:request
                                           success:^(id response) { completionHandler(); }
                                           failure:errorHandler];
}

- (void)getSubscriberDetailsWithEmailAddress:(NSString *)emailAddress
                                      listID:(NSString *)listID
                           completionHandler:(void (^)(CSSubscriber* subscriber))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"subscribers/%@.json", listID]
                parameters:[NSDictionary dictionaryWithObject:emailAddress forKey:@"email"]
                   success:^(id response) {
                     CSSubscriber* subscriber = [CSSubscriber subscriberWithDictionary:response];
                     completionHandler(subscriber);
                   }
                   failure:errorHandler];
}

- (void)getSubscriberHistoryWithEmailAddress:(NSString *)emailAddress
                                      listID:(NSString *)listID
                           completionHandler:(void (^)(NSDictionary* historyData))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"subscribers/%@/history.json", listID]
                parameters:[NSDictionary dictionaryWithObject:emailAddress forKey:@"email"]
                   success:completionHandler
                   failure:errorHandler];
}

- (void)importSubscribersToListWithID:(NSString *)listID
                       subscriberData:(NSArray *)subscriberData
                    shouldResubscribe:(BOOL)shouldResubscribe
                    completionHandler:(void (^)(NSDictionary* responseObject))completionHandler
                         errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSMutableURLRequest* request = [self.restClient requestWithMethod:@"POST"
                                                               path:[NSString stringWithFormat:@"subscribers/%@/import.json", listID]
                                                         parameters:nil];
  
  NSDictionary* requestBodyObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                     subscriberData, @"Subscribers",
                                     [NSNumber numberWithBool:shouldResubscribe], @"Resubscribe", nil];
  
  [request setHTTPBody:[requestBodyObject JSONData]];
  
  [self.restClient enqueueHTTPOperationWithRequest:request
                                           success:completionHandler
                                           failure:errorHandler];
}

@end
