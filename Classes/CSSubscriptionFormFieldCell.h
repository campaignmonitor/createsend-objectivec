//
//  CSSubscriptionFormFieldCell.h
//  CreateSend
//
//  Created by Nathan de Vries on 1/08/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSSubscriptionFormField;

@interface CSSubscriptionFormFieldCell : UITableViewCell

@property (nonatomic, retain) CSSubscriptionFormField* field;

- (void)configureCell;
- (UIResponder *)responder;

@end
