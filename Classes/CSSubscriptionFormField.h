//
//  CSSubscriptionFormField.h
//  CreateSend
//
//  Created by Nathan de Vries on 1/08/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSSubscriptionFormFieldCell.h"

@interface CSSubscriptionFormField : NSObject

@property (nonatomic, copy) NSString* key;
@property (nonatomic, copy) NSString* label;
@property (nonatomic, retain) id value;

+ (id)fieldWithKey:(NSString *)key
             label:(NSString *)label
             value:(id)value;

- (CSSubscriptionFormFieldCell *)cell;

@end

#import "CSSubscriptionFormTextField.h"
#import "CSSubscriptionFormOptionsField.h"
