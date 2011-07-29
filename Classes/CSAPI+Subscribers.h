//
//  CSAPI+Subscribers.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"
#import "CSSubscriber.h"

@interface CSAPI (Subscribers)

/*
 
 TODO: These APIs are yet to be implemented
 
 PUT http://api.createsend.com/api/v3/subscribers/{listid}.{xml|json}?email={email}
 
 */


- (void)subscribeToListWithID:(NSString *)listID
                 emailAddress:(NSString *)emailAddress
                         name:(NSString *)name
            shouldResubscribe:(BOOL)shouldResubscribe
            customFieldValues:(NSArray *)customFieldValues
            completionHandler:(void (^)(NSString* subscribedAddress))completionHandler
                 errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)unsubscribeFromListWithID:(NSString *)listID
                     emailAddress:(NSString *)emailAddress
                completionHandler:(void (^)(void))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getSubscriberDetailsWithEmailAddress:(NSString *)emailAddress
                                      listID:(NSString *)listID
                           completionHandler:(void (^)(CSSubscriber* subscriber))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getSubscriberHistoryWithEmailAddress:(NSString *)emailAddress
                                      listID:(NSString *)listID
                           completionHandler:(void (^)(NSDictionary* historyData))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)importSubscribersToListWithID:(NSString *)listID
                       subscriberData:(NSArray *)subscriberData
                    shouldResubscribe:(BOOL)shouldResubscribe
                    completionHandler:(void (^)(NSDictionary* responseObject))completionHandler
                         errorHandler:(CSAPIErrorHandler)errorHandler;

@end
