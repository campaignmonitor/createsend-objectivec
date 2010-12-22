//
//  CSSubscriberHistoryRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 22/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"


@interface CSSubscriberHistoryRequest : CSAPIRequest


+ (id)requestWithListID:(NSString *)listID
           emailAddress:(NSString *)emailAddress;


@end
