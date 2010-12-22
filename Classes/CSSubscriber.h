//
//  CSSubscriber.h
//  CreateSend
//
//  Created by Nathan de Vries on 22/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CSSubscriber : NSObject


@property (retain) NSString* emailAddress;
@property (retain) NSString* name;
@property (retain) NSDate* date;
@property (retain) NSString* state;
@property (retain) NSArray* customFieldValues;


+ (id)subscriberWithDictionary:(NSDictionary *)subscriberDict;

+ (id)subscriberWithEmailAddress:(NSString *)emailAddress
                            name:(NSString *)name
               customFieldValues:(NSArray *)customFieldValues;


@end
