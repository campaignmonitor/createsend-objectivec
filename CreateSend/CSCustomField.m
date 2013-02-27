//
//  CSCustomField.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSCustomField.h"

static NSDictionary * gCustomFieldDataTypeMapping;

@interface CSCustomField (Private)
+ (CSCustomFieldDataType)dataTypeForDataTypeString:(NSString *)dataTypeString;
+ (NSString *)dataTypeStringForDataType:(CSCustomFieldDataType)dataType;
@end

@implementation CSCustomField

+ (void)initialize {
    if (self == [CSCustomField class]) {
        gCustomFieldDataTypeMapping = @{@"Text": @(CSCustomFieldTextDataType),
                                       @"Number": @(CSCustomFieldNumberDataType),
                                       @"MultiSelectOne": @(CSCustomFieldMultiSelectOneDataType),
                                       @"MultiSelectMany": @(CSCustomFieldMultiSelectManyDataType),
                                       @"Country": @(CSCustomFieldCountryDataType),
                                       @"USState": @(CSCustomFieldUSStateDataType),
                                       @"Date": @(CSCustomFieldDateDataType)};
    }
}

+ (id)customFieldWithName:(NSString *)name
                      key:(NSString *)key
                 dataType:(CSCustomFieldDataType)dataType
                  options:(NSArray *)options
                    value:(id)value
visibleInPreferenceCenter:(BOOL)visibleInPreferenceCenter
{
    
    CSCustomField *customField = [[self alloc] init];
    customField.name = name;
    customField.key = key;
    customField.dataType = dataType;
    customField.options = options;
    customField.value = value;
    customField.visibleInPreferenceCenter = visibleInPreferenceCenter;
    return customField;
}

+ (id)customFieldWithName:(NSString *)name key:(NSString *)key dataType:(CSCustomFieldDataType)dataType options:(NSArray *)options value:(id)value
{
    return [self customFieldWithName:name key:key dataType:dataType options:options value:value visibleInPreferenceCenter:YES];
}

+ (id)customFieldWithName:(NSString *)name key:(NSString *)key dataType:(CSCustomFieldDataType)dataType options:(NSArray *)options
{
    return [self customFieldWithName:name key:key dataType:dataType options:options value:nil];
}

+ (id)customFieldWithName:(NSString *)name dataType:(CSCustomFieldDataType)dataType options:(NSArray *)options
{
    return [self customFieldWithName:name key:nil dataType:dataType options:options];
}

+ (id)customFieldWithName:(NSString *)name dataType:(CSCustomFieldDataType)dataType
{
    return [self customFieldWithName:name dataType:dataType options:nil];
}

+ (id) customFieldWithKey:(NSString *)key
                     name:(NSString *)name
visibleInPreferenceCenter:(BOOL)visibleInPreferenceCenter
{
    return [self customFieldWithName:name key:key dataType:CSCustomFieldTextDataType options:nil value:nil visibleInPreferenceCenter:visibleInPreferenceCenter];
}

+ (id)customFieldWithKey:(NSString *)key value:(id)value
{
    return [self customFieldWithName:nil key:key dataType:CSCustomFieldTextDataType options:nil value:value];
}

+ (id)customFieldWithDictionary:(NSDictionary *)customFieldDictionary
{
    return [self customFieldWithName:[customFieldDictionary valueForKey:@"FieldName"] key:[customFieldDictionary valueForKey:@"Key"] dataType:[self dataTypeForDataTypeString:[customFieldDictionary valueForKey:@"DataType"]] options:[customFieldDictionary valueForKey:@"FieldOptions"] value:[customFieldDictionary valueForKey:@"Value"] visibleInPreferenceCenter:[[customFieldDictionary valueForKey:@"VisibleInPreferenceCenter"] boolValue]];
}

- (NSString *)dataTypeString
{
    return [[self class] dataTypeStringForDataType:self.dataType];
}

- (NSDictionary *)dictionaryValue
{
    id value = self.value;
    if (!value) {
        value = @"";
    } else if ([value isKindOfClass:[NSDate class]]) {
        value = [[CSAPI sharedDateFormatter] stringFromDate:value]; 
    }
    
    NSMutableDictionary *dictionaryValue = [[NSMutableDictionary alloc] initWithDictionary:@{@"Key": self.key, @"Value": value}];
    if (self.clear) [dictionaryValue setObject:@(YES) forKey:@"Clear"];
    return [[NSDictionary alloc] initWithDictionary:dictionaryValue];
}
@end

@implementation CSCustomField (Private)
+ (CSCustomFieldDataType)dataTypeForDataTypeString:(NSString *)dataTypeString
{
    return [[gCustomFieldDataTypeMapping valueForKey:dataTypeString] integerValue];
}

+ (NSString *)dataTypeStringForDataType:(CSCustomFieldDataType)dataType
{
    for (NSString *dataTypeString in [gCustomFieldDataTypeMapping allKeys]) {
        if ([self dataTypeForDataTypeString:dataTypeString] == dataType) {
            return dataTypeString;
        }
    }
    return [gCustomFieldDataTypeMapping objectForKey:@(CSCustomFieldTextDataType)];
}
@end
