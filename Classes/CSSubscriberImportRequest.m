//
//  CSSubscriberImportRequest.m
//  CreateSend
//
//  Created by Nathan de Vries on 22/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSSubscriberImportRequest.h"


@implementation CSSubscriberImportRequest


+ (id)requestWithListID:(NSString *)listID
      shouldResubscribe:(BOOL)shouldResubscribe
 subscriberDictionaries:(NSArray *)subscriberDictionaries {

  CSSubscriberImportRequest* request = [self requestWithAPISlug:[NSString stringWithFormat:@"subscribers/%@/import", listID]];
  request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                           subscriberDictionaries, @"Subscribers",
                           [NSNumber numberWithBool:shouldResubscribe], @"Resubscribe",
                           nil];

  return request;
}


@end
