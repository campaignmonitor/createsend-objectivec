//
//  CSSuppressedRecipient.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSSuppressedRecipient.h"

@implementation CSSuppressedRecipient

- (id)initWithDictionary:(NSDictionary *)recipientDictionary
{
    self = [super init];
    if (self) {
        _suppressionReason = [recipientDictionary valueForKey:@"SuppressionReason"];
        _emailAddress = [recipientDictionary valueForKey:@"EmailAddress"];
        _date = [[CSAPI sharedDateFormatter] dateFromString:[recipientDictionary valueForKey:@"Date"]];
        _state = [recipientDictionary valueForKey:@"State"];
    }
    return self;
}
@end
