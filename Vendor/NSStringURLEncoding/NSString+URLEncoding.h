//
//  NSString+URLEncoding.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
- (NSString *)cs_urlEncodedString;
- (NSString *)cs_urlEncodedStringWithEncoding:(NSStringEncoding)encoding;
@end
