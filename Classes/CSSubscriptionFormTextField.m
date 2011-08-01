//
//  CSSubscriptionFormTextField.m
//  CreateSend
//
//  Created by Nathan de Vries on 1/08/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSSubscriptionFormTextField.h"
#import "CSSubscriptionFormTextFieldCell.h"

@interface CSSubscriptionFormTextField ()

- (void)editingChanged;
- (void)editingDidEndOnExit;

@end


@implementation CSSubscriptionFormTextField

@synthesize textField=_textField;

+ (id)fieldWithKey:(NSString *)key
             label:(NSString *)label
             value:(id)value
      keyboardType:(UIKeyboardType)keyboardType {
  
  CSSubscriptionFormTextField* field = [super fieldWithKey:key label:label value:value];
  
  field.textField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
  field.textField.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
  field.textField.clearButtonMode = UITextFieldViewModeAlways;
  field.textField.font = [UIFont boldSystemFontOfSize:16.0];
  field.textField.textColor = [UIColor darkGrayColor];
  field.textField.textAlignment = UITextAlignmentRight;
  field.textField.backgroundColor = [UIColor clearColor];
  field.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  field.textField.autocorrectionType = UITextAutocorrectionTypeNo;
  field.textField.adjustsFontSizeToFitWidth = YES;
  field.textField.enablesReturnKeyAutomatically = NO;
  field.textField.returnKeyType = UIReturnKeyDone;
  field.textField.keyboardType = keyboardType;
  field.textField.text = value;
  
  [field.textField addTarget:field
                      action:@selector(editingChanged)
            forControlEvents:UIControlEventEditingChanged];
  
  [field.textField addTarget:field
                      action:@selector(editingDidEndOnExit)
            forControlEvents:UIControlEventEditingDidEndOnExit];
  
  return field;
}

- (UITableViewCell *)cell {
  return [[[CSSubscriptionFormTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:NSStringFromClass([self class])] autorelease];
}

- (void)editingChanged {
  self.value = self.textField.text;
}


- (void)editingDidEndOnExit {
  [self.textField resignFirstResponder];
}

- (void)dealloc {
  self.textField = nil;
  
  [super dealloc];
}

@end