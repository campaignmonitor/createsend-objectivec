//
//  CSAPI+Templates.m
//  CreateSend
//
//  Created by Nathan de Vries on 30/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI+Templates.h"

@implementation CSAPI (Templates)

- (void)getTemplatesWithClientID:(NSString *)clientID
               completionHandler:(void (^)(NSArray* templates))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"clients/%@/templates.json", clientID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)getTemplateDetailsWithTemplateID:(NSString *)templateID
                       completionHandler:(void (^)(NSDictionary* template))completionHandler
                            errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"templates/%@.json", templateID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

- (void)createTemplateWithClientID:(NSString *)clientID
                              name:(NSString *)name
                       htmlPageURL:(NSString *)htmlPageURL
                        zipFileURL:(NSString *)zipFileURL
                 completionHandler:(void (^)(NSString* templateID))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient postPath:[NSString stringWithFormat:@"templates/%@.json", clientID]
                 parameters:nil
                 bodyObject:[NSDictionary dictionaryWithObjectsAndKeys:
                             name, @"Name",
                             htmlPageURL, @"HtmlPageURL",
                             zipFileURL, @"ZipFileURL", nil]
                    success:completionHandler
                    failure:errorHandler];  
}

- (void)updateTemplateWithTemplateID:(NSString *)templateID
                                name:(NSString *)name
                         htmlPageURL:(NSString *)htmlPageURL
                          zipFileURL:(NSString *)zipFileURL
                   completionHandler:(void (^)(void))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient putPath:[NSString stringWithFormat:@"templates/%@.json", templateID]
                parameters:nil
                bodyObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            name, @"Name",
                            htmlPageURL, @"HtmlPageURL",
                            zipFileURL, @"ZipFileURL", nil]
                   success:^(id response) { completionHandler(); }
                   failure:errorHandler];
  
}

- (void)deleteTemplateWithID:(NSString *)templateID
           completionHandler:(void (^)(void))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient deletePath:[NSString stringWithFormat:@"templates/%@.json", templateID]
                   parameters:nil
                      success:^(id response) { completionHandler(); }
                      failure:errorHandler];
}

@end
