//
//  CSTimezonesRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"


@interface CSTimezonesRequest : CSAPIRequest


@property (retain) NSArray* timezones;


+ (id)request;
+ (id)requestWithAPIKey:(NSString *)APIKey;


@end
