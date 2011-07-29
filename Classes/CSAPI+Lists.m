//
//  CSAPI+Lists.m
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI+Lists.h"

@implementation CSAPI (Lists)

- (void)createListWithClientID:(NSString *)clientID
                         title:(NSString *)title
               unsubscribePage:(NSString *)unsubscribePage
       confirmationSuccessPage:(NSString *)confirmationSuccessPage
            shouldConfirmOptIn:(BOOL)shouldConfirmOptIn
             completionHandler:(void (^)(NSString* listID))completionHandler
                  errorHandler:(CSAPIErrorHandler)errorHandler {
    
    __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                               slug:[NSString stringWithFormat:@"lists/%@", clientID]];
    
    request.requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
                             title, @"Title",
                             unsubscribePage, @"UnsubscribePage",
                             confirmationSuccessPage, @"ConfirmationSuccessPage",
                             [NSNumber numberWithBool:shouldConfirmOptIn], @"ConfirmedOptIn",
                             nil];
    
    [request setCompletionBlock:^{
        completionHandler(request.parsedResponse);
    }];
    
    [request setFailedBlock:^{ errorHandler(request.error); }];
    [request startAsynchronous];
}

- (void)getListsWithClientID:(NSString *)clientID
           completionHandler:(void (^)(NSArray* lists))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler {
    
    __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                               slug:[NSString stringWithFormat:@"clients/%@/lists",
                                                                     clientID]];
    
    [request setCompletionBlock:^{
        NSMutableArray* lists = [NSMutableArray array];
        for (NSDictionary* listDict in request.parsedResponse) {
            [lists addObject:[CSList listWithDictionary:listDict]];
        }
        completionHandler([NSArray arrayWithArray:lists]);
    }];
    
    [request setFailedBlock:^{ errorHandler(request.error); }];
    [request startAsynchronous];
}

- (void)deleteListWithID:(NSString *)listID
       completionHandler:(void (^)(void))completionHandler
            errorHandler:(CSAPIErrorHandler)errorHandler {
    
    __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                               slug:[NSString stringWithFormat:@"lists/%@", listID]];
    request.requestMethod = @"DELETE";
    
    [request setCompletionBlock:completionHandler];
    [request setFailedBlock:^{ errorHandler(request.error); }];
    [request startAsynchronous];
}

- (void)getCustomFieldsWithListID:(NSString *)listID
                completionHandler:(void (^)(NSArray* customFields))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler {
    
    __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                               slug:[NSString stringWithFormat:@"lists/%@/customfields", listID]];
    
    [request setCompletionBlock:^{
        NSMutableArray* customFields = [NSMutableArray array];
        for (NSDictionary* customFieldDict in request.parsedResponse) {
            [customFields addObject:[CSCustomField customFieldWithDictionary:customFieldDict]];
        }
        completionHandler([NSArray arrayWithArray:customFields]);
    }];
    
    [request setFailedBlock:^{ errorHandler(request.error); }];
    [request startAsynchronous];
}

- (void)getListDetailsWithListID:(NSString *)listID
               completionHandler:(void (^)(CSList* list))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler {
    
    __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                               slug:[NSString stringWithFormat:@"lists/%@", listID]];
    
    [request setCompletionBlock:^{
        CSList* list = [CSList listWithDictionary:request.parsedResponse];
        completionHandler(list);
    }];
    
    [request setFailedBlock:^{ errorHandler(request.error); }];
    [request startAsynchronous];
}

- (void)getListStatisticsWithListID:(NSString *)listID
                  completionHandler:(void (^)(NSDictionary* listStatisticsData))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler {
    
    __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                               slug:[NSString stringWithFormat:@"lists/%@/stats", listID]];
    
    [request setCompletionBlock:^{
        completionHandler(request.parsedResponse);
    }];
    
    [request setFailedBlock:^{ errorHandler(request.error); }];
    [request startAsynchronous];
}

- (void)createCustomFieldWithListID:(NSString *)listID
                        customField:(CSCustomField *)customField
                  completionHandler:(void (^)(NSString* customFieldKey))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler {
    
    __block CSAPIRequest* request = [CSAPIRequest requestWithAPIKey:self.APIKey
                                                               slug:[NSString stringWithFormat:@"lists/%@/customfields", listID]];
    
    NSMutableDictionary* requestObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          customField.name, @"FieldName",
                                          [customField dataTypeString], @"DataType", nil];
    
    if (customField.options) {
        [requestObject setObject:customField.options
                          forKey:@"Options"];
    }
    
    request.requestObject = requestObject;
    
    [request setCompletionBlock:^{
        completionHandler(request.parsedResponse);
    }];
    
    [request setFailedBlock:^{ errorHandler(request.error); }];
    [request startAsynchronous];
}

@end
