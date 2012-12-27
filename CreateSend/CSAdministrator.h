//
//  CSAdministrator.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSAdministrator : NSObject
@property (copy) NSString *name;
@property (copy) NSString *emailAddress;
@property (copy) NSString *status;

+ (id)administratorWithDictionary:(NSDictionary *)administratorDictionary;
@end
