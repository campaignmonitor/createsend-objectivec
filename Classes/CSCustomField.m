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
                                   [NSNumber numberWithInt:CSCustomFieldTextDataType], @"Text",
                                   [NSNumber numberWithInt:CSCustomFieldNumberDataType], @"Number",
                                   [NSNumber numberWithInt:CSCustomFieldMultiSelectOneDataType], @"MultiSelectOne",
                                   [NSNumber numberWithInt:CSCustomFieldMultiSelectManyDataType], @"MultiSelectMany",
                                   [NSNumber numberWithInt:CSCustomFieldCountryDataType], @"Country",
                                   [NSNumber numberWithInt:CSCustomFieldUSStateDataType], @"USState",
                                   [NSNumber numberWithInt:CSCustomFieldDateDataType], @"Date",
                                   nil] retain];
  }
}

+ (id)customFieldWithName:(NSString *)name
                      key:(NSString *)key
                 dataType:(CSCustomFieldDataType)dataType
                  options:(NSArray *)options {
  
  CSCustomField* customField = [[[self alloc] init] autorelease];
  customField.name = name;
  customField.key = key;
  customField.dataType = dataType;
  customField.options = options;
  
  return customField;
}

+ (id)customFieldWithName:(NSString *)name
                 dataType:(CSCustomFieldDataType)dataType
                  options:(NSArray *)options {
  
  return [self customFieldWithName:name
                               key:nil
                          dataType:dataType
                           options:options];
}


+ (id)customFieldWithName:(NSString *)name
                 dataType:(CSCustomFieldDataType)dataType {
  
  return [self customFieldWithName:name
                          dataType:dataType
                           options:nil];
}


+ (id)customFieldWithDictionary:(NSDictionary *)customFieldDict {
  return [self customFieldWithName:[customFieldDict valueForKey:@"FieldName"]
                               key:[customFieldDict valueForKey:@"Key"]
                          dataType:[self dataTypeForDataTypeString:[customFieldDict valueForKey:@"DataType"]]
                           options:[customFieldDict valueForKey:@"FieldOptions"]];
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


+ (NSDictionary *)dictionaryWithValue:(id)fieldValue forFieldKey:(NSString *)fieldKey {
  return [NSDictionary dictionaryWithObjectsAndKeys:
          fieldValue, @"Value",
          fieldKey, @"Key",
          nil];
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
