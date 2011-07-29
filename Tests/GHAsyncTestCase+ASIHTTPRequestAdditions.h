//
//  GHAsyncTestCase+ASIHTTPRequestAdditions.h
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"

@interface GHAsyncTestCase (ASIHTTPRequestAdditions)


- (void)performRequestAndWaitForResponse:(CSAPIRequest *)request;

- (void)performRequestAndWaitForResponse:(CSAPIRequest *)request
                     forTestWithSelector:(SEL)selector;


@end
