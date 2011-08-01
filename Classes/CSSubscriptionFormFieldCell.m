//
//  CSSubscriptionFormFieldCell.m
//  CreateSend
//
//  Created by Nathan de Vries on 1/08/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSSubscriptionFormFieldCell.h"
#import "CSSubscriptionFormField.h"

@implementation CSSubscriptionFormFieldCell

@synthesize field=_field;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}

- (void)configureCell {
  self.textLabel.text = _field.label;
}

- (void)setField:(CSSubscriptionFormField *)newField {
  if (_field != newField) {
    [_field release];
    _field = [newField retain];
    
    [self configureCell];
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGRect oldTextLabelFrame = self.textLabel.frame;
  [self.textLabel sizeToFit];
  
  CGFloat newWidth = self.textLabel.frame.size.width;  
  self.textLabel.frame = (CGRect){ oldTextLabelFrame.origin, { newWidth, oldTextLabelFrame.size.height } };
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (UIResponder *)responder {
  return self;
}

@end
