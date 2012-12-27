//
//  CSTemplate.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSTemplate : NSObject
@property (copy) NSString *templateID;
@property (copy) NSString *name;
@property (copy) NSString *previewPage;
@property (copy) NSString *screenshotPage;

+ (id)templateWithDictionary:(NSDictionary *)templateDictionary;
@end
