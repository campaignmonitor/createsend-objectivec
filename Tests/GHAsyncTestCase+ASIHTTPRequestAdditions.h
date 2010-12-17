//
//  GHAsyncTestCase+ASIHTTPRequestAdditions.h
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "CSAPIRequest.h"


@interface GHAsyncTestCase (ASIHTTPRequestAdditions)


- (void)performRequest:(CSAPIRequest *)request
   forTestWithSelector:(SEL)selector;


@end
