//
//  NSURL+CSAPI.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CSAPI)
- (NSDictionary *)cs_queryValuesForKeys:(NSArray *)keys error:(NSError **)error;
- (id)cs_queryValueForKey:(NSString *)key;
@end
