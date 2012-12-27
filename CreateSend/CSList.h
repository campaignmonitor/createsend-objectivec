//
//  CSList.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSList : NSObject
@property (copy) NSString *listID;
@property (copy) NSString *name;
@property (copy) NSString *unsubscribePage;
@property (copy) NSString *confirmationSuccessPage;
@property (assign) BOOL confirmOptIn;

+ (id)listWithDictionary:(NSDictionary *)listDictionary;
@end
