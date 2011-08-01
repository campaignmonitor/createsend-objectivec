//
//  CSSubscriptionFormTextFieldCell.m
//  CreateSend
//
//  Created by Nathan de Vries on 1/08/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSSubscriptionFormTextFieldCell.h"
#import "CSSubscriptionFormTextField.h"

@implementation CSSubscriptionFormTextFieldCell

- (void)configureCell {
  [super configureCell];
  
  [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  
  CSSubscriptionFormTextField* field = (CSSubscriptionFormTextField *)self.field;
  [self.contentView addSubview:field.textField];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CSSubscriptionFormTextField* field = (CSSubscriptionFormTextField *)self.field;
  UITextField* textField = field.textField;
  
  CGFloat margin = self.textLabel.frame.size.width + (self.indentationWidth * 2);
  textField.frame = CGRectMake(margin,
                               roundf((self.contentView.frame.size.height - [textField.font lineHeight]) / 2),
                               self.contentView.frame.size.width - margin - self.indentationWidth,
                               roundf([textField.font lineHeight]));
}

- (void)setInputAccessoryView:(UIView *)inputAccessoryView {
  CSSubscriptionFormTextField* field = (CSSubscriptionFormTextField *)self.field;
  field.textField.inputAccessoryView = inputAccessoryView;
}

- (BOOL)becomeFirstResponder {
  CSSubscriptionFormTextField* field = (CSSubscriptionFormTextField *)self.field;
  field.textField.enabled = YES;
  
  return [field.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
  CSSubscriptionFormTextField* field = (CSSubscriptionFormTextField *)self.field;
  field.textField.enabled = NO;
  
  return [field.textField resignFirstResponder];
}

- (UIResponder *)responder {
  CSSubscriptionFormTextField* field = (CSSubscriptionFormTextField *)self.field;
  return field.textField;
}

@end
