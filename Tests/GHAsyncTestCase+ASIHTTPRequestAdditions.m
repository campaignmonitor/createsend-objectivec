//
//  GHAsyncTestCase+ASIHTTPRequestAdditions.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "GHAsyncTestCase+ASIHTTPRequestAdditions.h"


@implementation GHAsyncTestCase (ASIHTTPRequestAdditions)


- (void)performRequestAndWaitForResponse:(CSAPIRequest *)request {
    [self performRequestAndWaitForResponse:request forTestWithSelector:NULL];
}


- (void)performRequestAndWaitForResponse:(CSAPIRequest *)request
                     forTestWithSelector:(SEL)selector {
    
    [self prepare];
    
    [request setCompletionBlock:^{ [self notify:kGHUnitWaitStatusSuccess forSelector:selector]; }];
    [request setFailedBlock:^{ [self notify:kGHUnitWaitStatusSuccess forSelector:selector]; }];
    
    [request startAsynchronous];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:2.0];
}

- (void)testAsync:(void (^)(void))testBlock withTimeout:(NSTimeInterval)timeout {
    [self prepare];
    testBlock();    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:timeout];
}

- (void)testAsync:(void (^)(void))testBlock {
    [self testAsync:testBlock withTimeout:2.0];
}

- (void)notifyTestFinished {
    [self notify:kGHUnitWaitStatusSuccess forSelector:NULL];
}

@end
