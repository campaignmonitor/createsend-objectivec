//
//  CSList.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSList.h"

@implementation CSList

+ (id)listWithDictionary:(NSDictionary *)listDictionary
{
    CSList *list = [[CSList alloc] init];
    list.listID = [listDictionary valueForKey:@"ListID"];
    list.name = [listDictionary valueForKey:@"Title"] ?: [listDictionary valueForKey:@"Name"];
    list.unsubscribePage = [listDictionary valueForKey:@"UnsubscribePage"];
    list.confirmationSuccessPage = [listDictionary valueForKey:@"ConfirmationSuccessPage"];
    list.confirmOptIn = [[listDictionary valueForKey:@"ConfirmedOptIn"] boolValue];

    return list;
}

@end
