//
//  CSTestCase.m
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSTestCase.h"

@implementation CSTestCase

@synthesize testAPI;

- (void)setUp {
    self.testAPI = [[[CSAPI alloc] initWithSiteURL:kCSTestsValidSiteURL
                                            APIKey:kCSTestsValidAPIKey] autorelease];
}

- (void)tearDown {
    self.testAPI = nil;
}

- (CSAPIErrorHandler)assertError {
    return [[^(NSError* error) {
        [self notifyTestFinished];
        GHAssertNotNil(error, nil);
    } copy] autorelease];
}

- (CSAPIErrorHandler)assertNoError {
    return [[^(NSError* error) {
        [self notifyTestFinished];
        GHAssertNil(error, nil);
    } copy] autorelease];
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
