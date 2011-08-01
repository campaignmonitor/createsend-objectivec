//
//  CSSubscriptionFormOptionsField.h
//  CreateSend
//
//  Created by Nathan de Vries on 1/08/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSSubscriptionFormField.h"

@interface CSSubscriptionFormOptionsField : CSSubscriptionFormField

@property (nonatomic, retain) NSArray* options;
@property (nonatomic, assign) BOOL multipleSelection;

+ (id)fieldWithKey:(NSString *)key
             label:(NSString *)label
             value:(id)value
           options:(NSArray *)options
 multipleSelection:(BOOL)multipleSelection;

@end
