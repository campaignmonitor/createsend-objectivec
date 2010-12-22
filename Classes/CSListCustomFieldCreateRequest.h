//
//  CSListCustomFieldCreateRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 20/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"
#import "CSCustomField.h"


@interface CSListCustomFieldCreateRequest : CSAPIRequest


@property (retain) NSString* customFieldKey;


+ (id)requestWithListID:(NSString *)listID
            customField:(CSCustomField *)customField;


@end
