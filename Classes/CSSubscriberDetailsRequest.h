//
//  CSSubscriberDetailsRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 22/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"
#import "CSSubscriber.h"


@interface CSSubscriberDetailsRequest : CSAPIRequest


@property (retain) CSSubscriber* subscriber;


+ (id)requestWithListID:(NSString *)listID
           emailAddress:(NSString *)emailAddress;


@end
