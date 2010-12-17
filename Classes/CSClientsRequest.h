//
//  CSClientsRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"
#import "CSClient.h"


@interface CSClientsRequest : CSAPIRequest


@property (retain) NSArray* clients;


+ (id)request;


@end
