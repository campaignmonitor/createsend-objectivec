//
//  NSURL+CSAPI.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "NSURL+CSAPI.h"

@implementation NSURL (CSAPI)
- (NSDictionary *)cs_queryValuesForKeys:(NSArray *)keys error:(NSError **)error
{
	NSString *propertyName;
	NSString *propertyValue;
	
	NSMutableDictionary *properties = [NSMutableDictionary dictionary];
	NSScanner *scanner = [NSScanner scannerWithString:[self query]];
	while (![scanner isAtEnd]) {
		[scanner scanUpToString:@"=" intoString:&propertyName];
		[scanner scanString:@"=" intoString:nil];
		[scanner scanUpToString:@"&" intoString:&propertyValue];
		[scanner scanString:@"&" intoString:nil];
		
		NSString *unescapedPropertyName = [propertyName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		if ([keys containsObject:unescapedPropertyName]) {
			[properties setObject:[propertyValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:unescapedPropertyName];
		}
	}
	
	return [NSDictionary dictionaryWithDictionary:properties];
}

- (id)cs_queryValueForKey:(NSString *)key
{
	return [[self cs_queryValuesForKeys:@[key] error:nil] objectForKey:key];
}
@end
