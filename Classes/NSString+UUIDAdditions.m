//
//  NSString+UUIDAdditions.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "NSString+UUIDAdditions.h"


@implementation NSString (UUIDAdditions)


+ (NSString *)UUIDString {
  CFUUIDRef uuidRef = CFUUIDCreate(NULL);
  CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
  CFRelease(uuidRef);
  return [NSMakeCollectable(uuidStringRef) autorelease];
}


@end
