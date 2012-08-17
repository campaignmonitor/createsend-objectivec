//
//  CSCustomField.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CSCustomFieldTextDataType,
    CSCustomFieldNumberDataType,
    CSCustomFieldMultiSelectOneDataType,
    CSCustomFieldMultiSelectManyDataType,
    CSCustomFieldCountryDataType,
    CSCustomFieldUSStateDataType,
    CSCustomFieldDateDataType
} CSCustomFieldDataType;

/**
 Represents a custom field, used for custom subscriber information
 */
@interface CSCustomField : NSObject
@property (copy) NSString *key;
@property (copy) NSString *name;
@property (assign) CSCustomFieldDataType dataType;
@property (strong) NSArray *options;
@property (strong) id value;
@property (assign) BOOL clear;

/**
 Creates and returns a `CSCustomField`. If you want to explicitely specify the
 custom fields shown in a `CSSubscriptionFormViewController`, you should use
 this constructor as it allows you to specify the custom field's key.
 
 @param name The name of the custom field
 @param key The system-generated key of the custom field. Used during subcription.
 @param dataType The data type of the custom field
 @param options The available options if the field has a multi-selet data type, or `nil` otherwise
 @param value Optional value for the field
 
 @return An instance of `CSCustomField`
 **/
+ (id)customFieldWithName:(NSString *)name key:(NSString *)key dataType:(CSCustomFieldDataType)dataType options:(NSArray *)options value:(id)value;

/**
 Creates and returns a `CSCustomField`. If you want to explicitely specify the
 custom fields shown in a `CSSubscriptionFormViewController`, you should use
 this constructor as it allows you to specify the custom field's key.
 
 @param name The name of the custom field
 @param key The system-generated key of the custom field. Used during subcription.
 @param dataType The data type of the custom field
 @param options The available options if the field has a multi-selet data type, or `nil` otherwise
 
 @return An instance of `CSCustomField`
 **/
+ (id)customFieldWithName:(NSString *)name key:(NSString *)key dataType:(CSCustomFieldDataType)dataType options:(NSArray *)options;

/**
 Creates and returns a `CSCustomField`. If you're not creating a multi-select
 custom field, you might want to use `customFieldWithName:dataType:` instead.
 
 @param name The name of the custom field
 @param dataType The data type of field
 @param options The available options if the field has a multi-select data type, or `nil` otherwise
 
 @return An instance of `CSCustomField`
 */
+ (id)customFieldWithName:(NSString *)name dataType:(CSCustomFieldDataType)dataType options:(NSArray *)options;

/**
 Creates and returns a `CSCustomField`
 
 @param key The name of the custom field
 @param value The custom field value
 
 @return An instance of `CSCustomField`
 */
+ (id)customFieldWithKey:(NSString *)key value:(id)value;

/**
 Creates and returns a `CSCustomField`
 
 @param name The name of the custom field
 @param dataType The data type of field
 
 @return An instance of `CSCustomField`
 */
+ (id)customFieldWithName:(NSString *)name dataType:(CSCustomFieldDataType)dataType;

+ (id)customFieldWithDictionary:(NSDictionary *)customFieldDictionary;

- (NSString *)dataTypeString;
- (NSDictionary *)dictionaryValue;
@end
