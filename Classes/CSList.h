//
//  CSList.h
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CSList : NSObject


@property (retain) NSString* listID;
@property (retain) NSString* name;


+ (id)listWithDictionary:(NSDictionary *)listDict;


@end
