//
//  CSBillingDetails.h
//  CreateSend
//
//  Created by James Dennes on 14/12/12.
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSBillingDetails : NSObject

@property (assign) NSUInteger credits;

+ (id)billingDetailsWithDictionary:(NSDictionary *)billingDetailsDictionary;

@end