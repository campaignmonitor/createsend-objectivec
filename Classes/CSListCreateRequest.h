//
//  CSListCreateRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"


@interface CSListCreateRequest : CSAPIRequest


@property (retain) NSString* listID;


+ (id)requestWithClientID:(NSString *)clientID
                    title:(NSString *)title
          unsubscribePage:(NSString *)unsubscribePage
  confirmationSuccessPage:(NSString *)confirmationSuccessPage
       shouldConfirmOptIn:(BOOL)shouldConfirmOptIn;


@end
