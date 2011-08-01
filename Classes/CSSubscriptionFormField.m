//
//  CSSubscriptionFormField.m
//  CreateSend
//
//  Created by Nathan de Vries on 1/08/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSSubscriptionFormField.h"

@implementation CSSubscriptionFormField

@synthesize key=_field;
@synthesize label=_fieldLabel;
@synthesize value=_value;

+ (id)fieldWithKey:(NSString *)key
             label:(NSString *)label
             value:(id)value {
  
  CSSubscriptionFormField* field = [[[self alloc] init] autorelease];
  field.key = key;
  field.label = label;
  field.value = value;
  return field;
}

- (CSSubscriptionFormFieldCell *)cell {
  CSSubscriptionFormFieldCell* cell = [[[CSSubscriptionFormFieldCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                          reuseIdentifier:NSStringFromClass([self class])] autorelease];
  return cell;
}

- (void)dealloc {
  self.key =
  self.label =
  self.value = nil;
  
  [super dealloc];
}

@end