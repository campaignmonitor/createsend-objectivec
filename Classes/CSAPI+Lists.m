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
  
  NSMutableURLRequest* request = [self.restClient requestWithMethod:@"POST"
                                                               path:[NSString stringWithFormat:@"lists/%@.json", clientID]
                                                         parameters:nil];
  
  NSDictionary* requestBodyObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                     title, @"Title",
                                     unsubscribePage, @"UnsubscribePage",
                                     confirmationSuccessPage, @"ConfirmationSuccessPage",
                                     [NSNumber numberWithBool:shouldConfirmOptIn], @"ConfirmedOptIn",
                                     nil];
  
  [request setHTTPBody:[requestBodyObject JSONData]];
  
  [self.restClient enqueueHTTPOperationWithRequest:request
                                           success:completionHandler
                                           failure:errorHandler];
}

- (void)updateListWithListID:(NSString *)listID
                       title:(NSString *)title
             unsubscribePage:(NSString *)unsubscribePage
     confirmationSuccessPage:(NSString *)confirmationSuccessPage
          shouldConfirmOptIn:(BOOL)shouldConfirmOptIn
           completionHandler:(void (^)(void))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSMutableURLRequest* request = [self.restClient requestWithMethod:@"PUT"
                                                               path:[NSString stringWithFormat:@"lists/%@.json", listID]
                                                         parameters:nil];
  
  NSDictionary* requestBodyObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                     title, @"Title",
                                     unsubscribePage, @"UnsubscribePage",
                                     confirmationSuccessPage, @"ConfirmationSuccessPage",
                                     [NSNumber numberWithBool:shouldConfirmOptIn], @"ConfirmedOptIn", nil];
  
  [request setHTTPBody:[requestBodyObject JSONData]];
  
  [self.restClient enqueueHTTPOperationWithRequest:request
                                           success:^(id response) { completionHandler(); }
                                           failure:errorHandler];
}

- (void)getListsWithClientID:(NSString *)clientID
           completionHandler:(void (^)(NSArray* lists))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"clients/%@/lists.json", clientID]
                parameters:nil
                   success:^(NSArray* listDicts) {
                     NSMutableArray* lists = [NSMutableArray arrayWithCapacity:[listDicts count]];
                     
                     for (NSDictionary* listDict in listDicts) {
                       [lists addObject:[CSList listWithDictionary:listDict]];
                     }
                     
                     completionHandler([NSArray arrayWithArray:lists]);
                   }
                   failure:errorHandler];
}

- (void)deleteListWithID:(NSString *)listID
       completionHandler:(void (^)(void))completionHandler
            errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient deletePath:[NSString stringWithFormat:@"lists/%@.json", listID]
                   parameters:nil
                      success:^(id response) { completionHandler(); }
                      failure:errorHandler];
}

- (void)getListDetailsWithListID:(NSString *)listID
               completionHandler:(void (^)(CSList* list))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"lists/%@.json", listID]
                parameters:nil
                   success:^(NSDictionary* listDict) {
                     CSList* list = [CSList listWithDictionary:listDict];
                     completionHandler(list);
                   }
                   failure:errorHandler];
}

- (void)getListStatisticsWithListID:(NSString *)listID
                  completionHandler:(void (^)(NSDictionary* listStatisticsData))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"lists/%@/stats.json", listID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)getSubscribersWithListID:(NSString *)listID
                            slug:(NSString *)slug
                            date:(NSDate *)date
                            page:(NSUInteger)page
                        pageSize:(NSUInteger)pageSize
                      orderField:(NSString *)orderField
                       ascending:(BOOL)ascending
               completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSMutableDictionary* queryParameters;
  queryParameters = [[[CSAPIRequest paginationParametersWithPage:page
                                                        pageSize:pageSize
                                                      orderField:orderField
                                                       ascending:ascending] mutableCopy] autorelease];
  
  NSString* dateString = [[CSAPIRequest sharedDateFormatter] stringFromDate:date];
  [queryParameters setObject:dateString forKey:@"Date"];
  
  
  [self.restClient getPath:[NSString stringWithFormat:@"lists/%@/%@.json", listID, slug]
                parameters:queryParameters
                   success:^(id response) {
                     CSPaginatedResult* result = [CSPaginatedResult resultWithDictionary:response];
                     completionHandler(result);
                   }
                   failure:errorHandler];
}

- (void)getActiveSubscribersWithListID:(NSString *)listID
                                  date:(NSDate *)date
                                  page:(NSUInteger)page
                              pageSize:(NSUInteger)pageSize
                            orderField:(NSString *)orderField
                             ascending:(BOOL)ascending
                     completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                          errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self getSubscribersWithListID:listID
                            slug:@"active"
                            date:nil
                            page:page
                        pageSize:pageSize
                      orderField:orderField
                       ascending:ascending
               completionHandler:completionHandler
                    errorHandler:errorHandler];
}

- (void)getUnsubscribedSubscribersWithListID:(NSString *)listID
                                        date:(NSDate *)date
                                        page:(NSUInteger)page
                                    pageSize:(NSUInteger)pageSize
                                  orderField:(NSString *)orderField
                                   ascending:(BOOL)ascending
                           completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                                errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self getSubscribersWithListID:listID
                            slug:@"unsubscribed"
                            date:nil
                            page:page
                        pageSize:pageSize
                      orderField:orderField
                       ascending:ascending
               completionHandler:completionHandler
                    errorHandler:errorHandler];
}

- (void)getBouncedSubscribersWithListID:(NSString *)listID
                                   date:(NSDate *)date
                                   page:(NSUInteger)page
                               pageSize:(NSUInteger)pageSize
                             orderField:(NSString *)orderField
                              ascending:(BOOL)ascending
                      completionHandler:(void (^)(CSPaginatedResult* paginatedResult))completionHandler
                           errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self getSubscribersWithListID:listID
                            slug:@"bounced"
                            date:nil
                            page:page
                        pageSize:pageSize
                      orderField:orderField
                       ascending:ascending
               completionHandler:completionHandler
                    errorHandler:errorHandler];
}

- (void)getListSegmentsWithListID:(NSString *)listID
                completionHandler:(void (^)(NSArray* listSegments))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"lists/%@/segments.json", listID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

# pragma mark - Custom Fields

- (void)getCustomFieldsWithListID:(NSString *)listID
                completionHandler:(void (^)(NSArray* customFields))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"lists/%@/customfields.json", listID]
                parameters:nil
                   success:^(id response) {
                     NSMutableArray* customFields = [NSMutableArray array];
                     
                     for (NSDictionary* customFieldDict in response) {
                       [customFields addObject:[CSCustomField customFieldWithDictionary:customFieldDict]];
                     }
                     
                     completionHandler([NSArray arrayWithArray:customFields]);
                   }
                   failure:errorHandler];
}

- (void)createCustomFieldWithListID:(NSString *)listID
                        customField:(CSCustomField *)customField
                  completionHandler:(void (^)(NSString* customFieldKey))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSMutableURLRequest* request = [self.restClient requestWithMethod:@"POST"
                                                               path:[NSString stringWithFormat:@"lists/%@/customfields.json", listID]
                                                         parameters:nil];
  
  NSMutableDictionary* requestBodyObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            customField.name, @"FieldName",
                                            [customField dataTypeString], @"DataType", nil];
  
  if (customField.options) {
    [requestBodyObject setObject:customField.options
                          forKey:@"Options"];
  }
  
  [request setHTTPBody:[requestBodyObject JSONData]];
  
  [self.restClient enqueueHTTPOperationWithRequest:request
                                           success:completionHandler
                                           failure:errorHandler];
}

- (void)updateCustomFieldWithListID:(NSString *)listID
                     customFieldKey:(NSString *)fieldKey
                            options:(NSArray *)options
                       keepExisting:(BOOL)keepExisting
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSString* path = [NSString stringWithFormat:@"lists/%@/customfields/%@/options.json", listID, fieldKey];
  NSMutableURLRequest* request = [self.restClient requestWithMethod:@"PUT"
                                                               path:path
                                                         parameters:nil];
  
  NSDictionary* requestBodyObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                     options, @"Options",
                                     [NSNumber numberWithBool:keepExisting], @"KeepExistingOptions", nil];
  
  [request setHTTPBody:[requestBodyObject JSONData]];
  
  [self.restClient enqueueHTTPOperationWithRequest:request
                                           success:^(id response) { completionHandler(); }
                                           failure:errorHandler];
}

- (void)deleteCustomFieldWithListID:(NSString *)listID
                     customFieldKey:(NSString *)fieldKey
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient deletePath:[NSString stringWithFormat:@"lists/%@/customfields/%@.json", listID, fieldKey]
                   parameters:nil
                      success:^(id response) { completionHandler(); }
                      failure:errorHandler];
}

# pragma mark - Webhooks

- (void)createWebhookWithListID:(NSString *)listID
                         events:(NSArray *)events
                      URLString:(NSString *)URLString
                  payloadFormat:(NSString *)payloadFormat
              completionHandler:(void (^)(NSString* webhookID))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler {
  
  NSMutableURLRequest* request = [self.restClient requestWithMethod:@"POST"
                                                               path:[NSString stringWithFormat:@"lists/%@/webhooks.json", listID]
                                                         parameters:nil];
  
  NSDictionary* requestBodyObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                     events, @"Events",
                                     URLString, @"Url",
                                     payloadFormat, @"PayloadFormat", nil];
  
  [request setHTTPBody:[requestBodyObject JSONData]];
  
  [self.restClient enqueueHTTPOperationWithRequest:request
                                           success:completionHandler
                                           failure:errorHandler];
}

- (void)getWebhooksWithListID:(NSString *)listID
            completionHandler:(void (^)(NSArray* webhooks))completionHandler
                 errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"lists/%@/webhooks.json", listID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)testWebhookWithListID:(NSString *)listID
                    webhookID:(NSString *)webhookID
            completionHandler:(void (^)(void))completionHandler
                 errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"lists/%@/webhooks/%@/test.json", listID, webhookID]
                parameters:nil
                   success:^(id response) { completionHandler(); }
                   failure:errorHandler];
}

- (void)deleteWebhookWithListID:(NSString *)listID
                      webhookID:(NSString *)webhookID
              completionHandler:(void (^)(void))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient deletePath:[NSString stringWithFormat:@"lists/%@/webhooks/%@.json", listID, webhookID]
                   parameters:nil
                      success:^(id response) { completionHandler(); }
                      failure:errorHandler];
}

- (void)activateWebhookWithListID:(NSString *)listID
                        webhookID:(NSString *)webhookID
                completionHandler:(void (^)(void))completionHandler
                     errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient putPath:[NSString stringWithFormat:@"lists/%@/webhooks/%@/activate.json", listID, webhookID]
                parameters:nil
                   success:^(id response) { completionHandler(); }
                   failure:errorHandler];
}

- (void)deactivateWebhookWithListID:(NSString *)listID
                          webhookID:(NSString *)webhookID
                  completionHandler:(void (^)(void))completionHandler
                       errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient putPath:[NSString stringWithFormat:@"lists/%@/webhooks/%@/deactivate.json", listID, webhookID]
                parameters:nil
                   success:^(id response) { completionHandler(); }
                   failure:errorHandler];
}

@end
