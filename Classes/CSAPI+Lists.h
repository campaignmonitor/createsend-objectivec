//
//  CSAPI+Lists.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"

#import "CSList.h"
#import "CSCustomField.h"

@interface CSAPI (Lists)

- (void)createListWithClientID:(NSString *)clientID
                         title:(NSString *)title
               unsubscribePage:(NSString *)unsubscribePage
       confirmationSuccessPage:(NSString *)confirmationSuccessPage
            shouldConfirmOptIn:(BOOL)shouldConfirmOptIn
             completionHandler:(void (^)(NSString* listID))completionHandler
                  errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getListsWithClientID:(NSString *)clientID
           completionHandler:(void (^)(NSArray* lists))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)deleteListWithID:(NSString *)listID
       completionHandler:(void (^)(void))completionHandler
            errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getCustomFieldsWithListID:(NSString *)listID
                completionHandler:(void (^)(NSArray* customFields))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getListDetailsWithListID:(NSString *)listID
               completionHandler:(void (^)(CSList* list))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)getListStatisticsWithListID:(NSString *)listID
                  completionHandler:(void (^)(NSDictionary* listStatisticsData))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

- (void)createCustomFieldWithListID:(NSString *)listID
                        customField:(CSCustomField *)customField
                  completionHandler:(void (^)(NSString* customFieldKey))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler;

@end