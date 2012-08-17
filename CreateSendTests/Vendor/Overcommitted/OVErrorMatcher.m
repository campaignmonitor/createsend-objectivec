//
//  OVErrorMatcher.m
//
//  Created by Jonathan Younger on 8/15/12.
//  Copyright (c) 2012 Overcommitted, LLC. All rights reserved.
//

#import "OVErrorMatcher.h"

@interface OVErrorMatcher ()
@property (assign) NSInteger code;
@property (copy) NSString *message;
@end

@implementation OVErrorMatcher

+ (NSArray *)matcherStrings
{
    return @[@"haveErrorCode:message:"];
}

- (BOOL)evaluate
{
    NSError *error = (NSError *)self.subject;
    return ([error code] == self.code && [[error localizedDescription] isEqualToString:self.message]);
}

- (NSString *)failureMessageForShould
{
    return [NSString stringWithFormat:@"expected subject to have code: %i, message: %@, got %@", self.code, self.message, [KWFormatter formatObject:self.subject]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"have code: %i and message: %@", self.code, self.message];
}

- (void)haveErrorCode:(NSInteger)code message:(NSString *)message
{
    self.code = code;
    self.message = message;
}
@end
