//
//  OVErrorMatcher.h
//
//  Created by Jonathan Younger on 8/15/12.
//  Copyright (c) 2012 Overcommitted, LLC. All rights reserved.
//

#import "Kiwi.h"

@interface NSObject (KWUserDefinedMatchersDefinitions)
- (void)haveErrorCode:(NSInteger)errorCode message:(NSString *)message;
@end

@interface OVErrorMatcher : KWMatcher
- (void)haveErrorCode:(NSInteger)errorCode message:(NSString *)message;
@end
