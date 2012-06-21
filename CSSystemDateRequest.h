//
//  CSSystemDateRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"


@interface CSSystemDateRequest : CSAPIRequest


@property (retain) NSDate* systemDate;


+ (id)request;
+ (id)requestWithAPIKey:(NSString *)APIKey;


@end
