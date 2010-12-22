//
//  CSSubscriberCreateRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 22/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"
#import "CSSubscriber.h"


@interface CSSubscriberCreateRequest : CSAPIRequest


@property (retain) NSString* subscribedEmailAddress;


+ (id)requestWithListID:(NSString *)listID
           emailAddress:(NSString *)emailAddress
                   name:(NSString *)name
      shouldResubscribe:(BOOL)shouldResubscribe;

+ (id)requestWithListID:(NSString *)listID
           emailAddress:(NSString *)emailAddress
                   name:(NSString *)name
      shouldResubscribe:(BOOL)shouldResubscribe
      customFieldValues:(NSArray *)customFieldValues;


@end
