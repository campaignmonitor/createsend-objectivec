//
//  CSListDetailsRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 20/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"
#import "CSList.h"


@interface CSListDetailsRequest : CSAPIRequest


@property (retain) CSList* list;


+ (id)requestWithListID:(NSString *)listID;


@end
