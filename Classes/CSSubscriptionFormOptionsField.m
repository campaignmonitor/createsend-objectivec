//
//  CSSubscriptionFormOptionsField.m
//  CreateSend
//
//  Created by Nathan de Vries on 1/08/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSSubscriptionFormOptionsField.h"

@implementation CSSubscriptionFormOptionsField

@synthesize options=_options, multipleSelection=_multipleSelection;

+ (id)fieldWithKey:(NSString *)key
             label:(NSString *)label
             value:(id)value
           options:(NSArray *)options
 multipleSelection:(BOOL)multipleSelection {
  
  CSSubscriptionFormOptionsField* field = [super fieldWithKey:key label:label value:value];
  field.options = options;
  field.multipleSelection = multipleSelection;
  
  return field;
}

@end
