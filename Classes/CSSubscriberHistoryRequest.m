//
//  CSSubscriberHistoryRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 22/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSSubscriberHistoryRequest.h"


@implementation CSSubscriberHistoryRequest


+ (id)requestWithListID:(NSString *)listID
           emailAddress:(NSString *)emailAddress {

  return [self requestWithAPISlug:[NSString stringWithFormat:@"subscribers/%@/history", listID]
                  queryParameters:[NSDictionary dictionaryWithObject:emailAddress
                                                              forKey:@"email"]];
}


@end
