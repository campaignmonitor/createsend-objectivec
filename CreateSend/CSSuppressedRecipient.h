//
//  CSSuppressedRecipient.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSuppressedRecipient : NSObject
@property (copy) NSString *suppressionReason;
@property (copy) NSString *emailAddress;
@property (strong) NSDate *date;
@property (copy) NSString *state;

- (id)initWithDictionary:(NSDictionary *)recipientDictionary;

@end
