//
//  NSString+URLEncoding.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)
- (NSString *)cs_urlEncodedString {
	return [self cs_urlEncodedStringWithEncoding:NSUTF8StringEncoding];
}

// See http://github.com/pokeb/asi-http-request/raw/master/Classes/ASIFormDataRequest.m
- (NSString *)cs_urlEncodedStringWithEncoding:(NSStringEncoding)encoding {
	NSString *urlEncodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`", CFStringConvertNSStringEncodingToEncoding(encoding));
    return urlEncodedString ? urlEncodedString : @"";
}

@end
