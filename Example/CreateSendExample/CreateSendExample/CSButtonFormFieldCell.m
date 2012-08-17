//
//  CSButtonFormFieldCell.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSButtonFormFieldCell.h"

@implementation CSButtonFormFieldCell

@synthesize fieldButton=_fieldButton;

- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
  if ((self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier])) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    
    self.label.alpha = 0.f;
    
    self.fieldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.fieldButton.contentMode = UIViewContentModeCenter;
    [self.cellView addSubview:self.fieldButton];
  }
  return self;
}

- (void)dealloc {
	[_fieldButton release], _fieldButton = nil;
	
	[super dealloc];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [self.fieldButton sizeToFit];
  self.fieldButton.frame = CGRectMake(self.fieldButton.frame.origin.x,
                                      self.fieldButton.frame.origin.y,
                                      self.fieldButton.frame.size.width + 60.f,
                                      self.fieldButton.frame.size.height);
                                      
  self.fieldButton.center = self.cellView.center;
}

@end
