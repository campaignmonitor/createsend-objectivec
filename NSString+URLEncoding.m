//
//  NSString+URLEncoding.m
//  CreateSend
//
//  Created by Nathan de Vries on 16/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "NSString+URLEncoding.h"


@implementation NSString (URLEncoding)


// NOTE: stringByAddingPercentEscapesUsingEncoding: is not RFC 3986 compliant
- (NSString *)stringByPercentEncodingForURLs {
  return [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              CFSTR("!*'();:@&=+$,/?%#[]"),
                                                              kCFStringEncodingUTF8) autorelease];
}


@end
