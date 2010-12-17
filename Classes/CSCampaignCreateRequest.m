//
//  CSCampaignCreateRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSCampaignCreateRequest.h"


@implementation CSCampaignCreateRequest


+ (id)requestWithClientID:(NSString *)clientID
                     name:(NSString *)name
                  subject:(NSString *)subject
                 fromName:(NSString *)fromName
                fromEmail:(NSString *)fromEmail
                  replyTo:(NSString *)replyTo
            HTMLURLString:(NSString *)HTMLURLString
            textURLString:(NSString *)textURLString
                  listIDs:(NSArray *)listIDs
               segmentIDs:(NSArray *)segmentIDs {

  CSCampaignCreateRequest* request = [self requestWithAPISlug:[NSString stringWithFormat:@"campaigns/%@", clientID]];
  request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                           name, @"Name",
                           subject, @"Subject",
                           fromName, @"FromName",
                           fromEmail, @"FromEmail",
                           replyTo, @"ReplyTo",
                           HTMLURLString, @"HtmlUrl",
                           textURLString, @"TextUrl",
                           listIDs, @"ListIDs",
                           segmentIDs, @"SegmentIDs",
                           nil];
  return request;
}


@end
