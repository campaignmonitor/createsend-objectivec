//
//  CSButtonFormField.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <IBAForms/IBAButtonFormField.h>
#import "CSButtonFormFieldCell.h"

@interface CSButtonFormField : IBAButtonFormField

@property (nonatomic, retain) CSButtonFormFieldCell* buttonFormFieldCell;

@end
