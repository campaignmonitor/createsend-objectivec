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


@interface CSCustomField : NSObject


@property (retain) NSString* name;
@property (retain) NSString* key;
@property (assign) CSCustomFieldDataType dataType;
@property (retain) NSArray* options;


+ (id)customFieldWithName:(NSString *)name
                 dataType:(CSCustomFieldDataType)dataType
                  options:(NSArray *)options;

+ (id)customFieldWithName:(NSString *)name
                 dataType:(CSCustomFieldDataType)dataType;

+ (id)customFieldWithDictionary:(NSDictionary *)customFieldDict;


- (NSString *)dataTypeString;


+ (NSDictionary *)dictionaryWithValue:(id)fieldValue forFieldKey:(NSString *)fieldKey;


@end
