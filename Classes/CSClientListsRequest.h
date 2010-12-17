//
//  CSClientListsRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"
#import "CSList.h"


@interface CSClientListsRequest : CSAPIRequest


@property (retain) NSArray* lists;


+ (id)requestWithClientID:(NSString *)clientID;


@end
