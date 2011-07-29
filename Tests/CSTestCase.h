//
//  CSTestCase.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"

@interface CSTestCase : GHAsyncTestCase

@property (nonatomic, retain) CSAPI* testAPI;

- (CSAPIErrorHandler)assertError;
- (CSAPIErrorHandler)assertNoError;

- (void)testAsync:(void (^)(void))testBlock;
- (void)testAsync:(void (^)(void))testBlock withTimeout:(NSTimeInterval)timeout;
- (void)notifyTestFinished;

@end
