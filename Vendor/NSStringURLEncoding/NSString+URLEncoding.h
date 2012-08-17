//
//  NSString+URLEncoding.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
- (NSString *)cs_urlEncodedString;
- (NSString *)cs_urlEncodedStringWithEncoding:(NSStringEncoding)encoding;
@end
