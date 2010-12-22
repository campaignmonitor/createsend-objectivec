//
//  CSSubscriberImportRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 22/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"


@interface CSSubscriberImportRequest : CSAPIRequest


+ (id)requestWithListID:(NSString *)listID
      shouldResubscribe:(BOOL)shouldResubscribe
 subscriberDictionaries:(NSArray *)subscriberDictionaries;


@end
