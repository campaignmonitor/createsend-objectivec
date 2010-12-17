//
//  CSClient.h
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CSClient : NSObject


@property (retain) NSString* clientID;
@property (retain) NSString* name;


+ (id)clientWithDictionary:(NSDictionary *)clientDict;


@end
