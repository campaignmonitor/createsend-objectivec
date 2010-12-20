//
//  CSCustomField.m
//  CreateSend
//
//  Created by Nathan de Vries on 20/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSCustomField.h"


@interface CSCustomField()


+ (CSCustomFieldDataType)dataTypeForDataTypeString:(NSString *)dataTypeString;
+ (NSString *)dataTypeStringForDataType:(CSCustomFieldDataType)dataType;


@end


static NSDictionary* customFieldDataTypeMapping;


@implementation CSCustomField


@synthesize name=_name;
@synthesize key=_key;
@synthesize dataType=_dataType;
@synthesize options=_options;


+ (void)initialize {
  if (self == [CSCustomField class]) {
    customFieldDataTypeMapping = [[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"Text", [NSNumber numberWithInt:CSCustomFieldTextDataType],
                                   @"Number", [NSNumber numberWithInt:CSCustomFieldNumberDataType],
                                   @"MultiSelectOne", [NSNumber numberWithInt:CSCustomFieldMultiSelectOneDataType],
                                   @"MultiSelectMany", [NSNumber numberWithInt:CSCustomFieldMultiSelectManyDataType],
                                   @"Country", [NSNumber numberWithInt:CSCustomFieldCountryDataType],
                                   @"USState", [NSNumber numberWithInt:CSCustomFieldUSStateDataType],
                                   nil] retain];
  }
}


+ (id)customFieldWithDictionary:(NSDictionary *)customFieldDict {
  CSCustomField* customField = [[[self alloc] init] autorelease];


  customField.name = [customFieldDict valueForKey:@"FieldName"];
  customField.key = [customFieldDict valueForKey:@"Key"];
  customField.dataType = [self dataTypeForDataTypeString:[customFieldDict valueForKey:@"DataType"]];
  customField.options = [customFieldDict valueForKey:@"FieldOptions"];

  return customField;
}


- (NSString *)dataTypeString {
  return [[self class] dataTypeStringForDataType:self.dataType];
}


+ (CSCustomFieldDataType)dataTypeForDataTypeString:(NSString *)dataTypeString {
  return [[customFieldDataTypeMapping valueForKey:dataTypeString] integerValue];
}


+ (NSString *)dataTypeStringForDataType:(CSCustomFieldDataType)dataType {
  for (NSString* dataTypeString in [customFieldDataTypeMapping allKeys]) {
    if ([self dataTypeForDataTypeString:dataTypeString] == dataType) {
      return dataTypeString;
    }
  }
  return CSCustomFieldTextDataType;
}


- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ name='%@' key='%@' "
          "dataType='%@' options=%@>", [self class], self.name, self.key,
          [self dataTypeString], self.options];
}


- (void)dealloc {
  [_name release];
  [_key release];
  [_options release];

  [super dealloc];
}


@end
