//
//  CSAdministrator.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSAdministrator.h"

@implementation CSAdministrator

+ (id)administratorWithDictionary:(NSDictionary *)administratorDictionary
{
    CSAdministrator *administrator = [[self alloc] init];
    administrator.name = [administratorDictionary valueForKey:@"Name"];
    administrator.emailAddress = [administratorDictionary valueForKey:@"EmailAddress"];
    administrator.status = [administratorDictionary valueForKey:@"Status"];
    return administrator;
}
@end
