//
//  GHAsyncTestCase+ASIHTTPRequestAdditions.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "GHAsyncTestCase+ASIHTTPRequestAdditions.h"


@implementation GHAsyncTestCase (ASIHTTPRequestAdditions)


- (void)performRequest:(CSAPIRequest *)request
   forTestWithSelector:(SEL)selector {

  [self prepare];

  [request setCompletionBlock:^{ [self notify:kGHUnitWaitStatusSuccess forSelector:selector]; }];
  [request setFailedBlock:^{ [self notify:kGHUnitWaitStatusSuccess forSelector:selector]; }];

  [request startAsynchronous];

  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:2.0];
}


@end
