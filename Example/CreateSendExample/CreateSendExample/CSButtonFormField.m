//
//  CSButtonFormField.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSButtonFormField.h"
#import "CSButtonFormFieldCell.h"

@implementation CSButtonFormField

@synthesize buttonFormFieldCell=_buttonFormFieldCell;

- (void)dealloc {
	[_buttonFormFieldCell release], _buttonFormFieldCell = nil;
	
	[super dealloc];
}

- (IBAFormFieldCell *)cell {
	return [self buttonFormFieldCell];
}

- (CSButtonFormFieldCell *)buttonFormFieldCell {
	if (_buttonFormFieldCell == nil) {
		_buttonFormFieldCell = [[CSButtonFormFieldCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
    [_buttonFormFieldCell.fieldButton addTarget:self
                         action:@selector(executionAction:)
               forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _buttonFormFieldCell;
}

- (void)updateCellContents {
  [self.buttonFormFieldCell.fieldButton setTitle:self.title
                                        forState:UIControlStateNormal];
  [self.buttonFormFieldCell setNeedsLayout];
}

- (void)executionAction:(UIButton *)fieldButton {
  if (executionBlock_ != NULL) {
    executionBlock_();
  }
}

@end
