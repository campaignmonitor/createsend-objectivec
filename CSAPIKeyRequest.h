//
//  CSAPIKeyRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 16/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"


@interface CSAPIKeyRequest : CSAPIRequest


+ (id)requestWithSiteURL:(NSString *)siteURL
                username:(NSString *)username
                password:(NSString *)password;


@property (retain) NSString* APIKey;


@end
