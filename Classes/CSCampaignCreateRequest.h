//
//  CSCampaignCreateRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"


@interface CSCampaignCreateRequest : CSAPIRequest


+ (id)requestWithClientID:(NSString *)clientID
                     name:(NSString *)name
                  subject:(NSString *)subject
                 fromName:(NSString *)fromName
                fromEmail:(NSString *)fromEmail
                  replyTo:(NSString *)replyTo
            HTMLURLString:(NSString *)HTMLURLString
            textURLString:(NSString *)textURLString
                  listIDs:(NSArray *)listIDs
               segmentIDs:(NSArray *)segmentIDs;


@end
