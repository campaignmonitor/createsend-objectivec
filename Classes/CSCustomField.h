//
//  CSCustomField.h
//  CreateSend
//
//  Created by Nathan de Vries on 20/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum _CSCustomFieldDataType {
  CSCustomFieldTextDataType,
  CSCustomFieldNumberDataType,
  CSCustomFieldMultiSelectOneDataType,
  CSCustomFieldMultiSelectManyDataType,
  CSCustomFieldCountryDataType,
  CSCustomFieldUSStateDataType
} CSCustomFieldDataType;

/**
 Represents a custom field, used for saving custom subscriber information
 */
@interface CSCustomField : NSObject

/** Field name */
@property (retain) NSString* name;

/** Field key (created automatically by the API) */
@property (retain) NSString* key;

/** Field data type */
@property (assign) CSCustomFieldDataType dataType;

/** Available options for fields of type `CSCustomFieldMultiSelectOneDataType` or `CSCustomFieldMultiSelectManyDataType` */
@property (retain) NSArray* options;

/**
 Creates and returns a `CSCustomField`. If you're not creating a multi-select custom field, you might want to use `customFieldWithName:dataType:` instead.
 
 @param name The name of the custom field
 @param dataType The data type of field
 @param options The available options if the field has a multi-select data type, or `nil` otherwise
 
 @return An instance of `CSCustomField`
 */
+ (id)customFieldWithName:(NSString *)name
                 dataType:(CSCustomFieldDataType)dataType
                  options:(NSArray *)options;

/**
 Creates and returns a `CSCustomField`
 
 @param name The name of the custom field
 @param dataType The data type of field
 
 @return An instance of `CSCustomField`
 */
+ (id)customFieldWithName:(NSString *)name
                 dataType:(CSCustomFieldDataType)dataType;

# pragma mark Internal

+ (id)customFieldWithDictionary:(NSDictionary *)customFieldDict;

- (NSString *)dataTypeString;

+ (NSDictionary *)dictionaryWithValue:(id)fieldValue forFieldKey:(NSString *)fieldKey;

@end
