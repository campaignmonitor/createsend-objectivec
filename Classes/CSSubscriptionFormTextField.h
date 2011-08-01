//
//  CSSubscriptionFormTextField.h
//  CreateSend
//
//  Created by Nathan de Vries on 1/08/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSSubscriptionFormField.h"

@interface CSSubscriptionFormTextField : CSSubscriptionFormField

@property (nonatomic, retain) UITextField* textField;

+ (id)fieldWithKey:(NSString *)key
             label:(NSString *)label
             value:(id)value
      keyboardType:(UIKeyboardType)keyboardType;

@end
