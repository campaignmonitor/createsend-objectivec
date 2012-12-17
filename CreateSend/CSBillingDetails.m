//
//  CSBillingDetails.m
//  CreateSend
//
//  Created by James Dennes on 14/12/12.
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSBillingDetails.h"

@implementation CSBillingDetails

+ (id)billingDetailsWithDictionary:(NSDictionary *)billingDetailsDictionary
{
    CSBillingDetails *bd = [[self alloc] init];
    bd.credits = [[billingDetailsDictionary valueForKey:@"Credits"] unsignedIntegerValue];
    return bd;
}

@end