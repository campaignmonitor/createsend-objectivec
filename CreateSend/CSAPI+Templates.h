//
//  CSAPI+Templates.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSAPI.h"
#import "CSTemplate.h"

/**
 Template-related APIs. See CSAPI for documentation of the other API categories.
 */
@interface CSAPI (Templates)

/**
 Get all basic details for a specific template.
 
 http://www.campaignmonitor.com/api/templates/#getting_a_template
 
 @param templateID The ID of the template to be retrieved
 @param completionHandler Completion callback, with a `CSTemplate` object as the first and only argument
 @param errorHandler Error callback
 */
- (void)getTemplateDetailsWithTemplateID:(NSString *)templateID
                       completionHandler:(void (^)(CSTemplate *template))completionHandler
                            errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Create a new template for a client.
 
 http://www.campaignmonitor.com/api/templates/#creating_a_template
 
 @param clientID The ID of the client for whom the template should be created
 @param name Name for the template
 @param htmlURLURL URL for the template HTML page
 @param zipFileURL URL for the template zip file
 @param completionHandler Completion callback, with the ID of the newly created template as the first and only argument
 @param errorHandler Error callback
 */
- (void)createTemplateWithClientID:(NSString *)clientID
                              name:(NSString *)name
                       htmlURLURL:(NSString *)htmlURLURL
                        zipFileURL:(NSString *)zipFileURL
                 completionHandler:(void (^)(NSString *templateID))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Update an existing template for a client.
 
 http://www.campaignmonitor.com/api/templates/#updating_a_template
 
 @param templateID The ID of the template to be updated
 @param name New name for the template
 @param htmlURLURL URL for the template HTML page
 @param zipFileURL URL for the template zip file
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)updateTemplateWithTemplateID:(NSString *)templateID
                                name:(NSString *)name
                         htmlURLURL:(NSString *)htmlURLURL
                          zipFileURL:(NSString *)zipFileURL
                   completionHandler:(void (^)(void))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Delete an existing template based on the template ID.
 
 http://www.campaignmonitor.com/api/templates/#deleting_a_template
 
 @param templateID The ID of the template to be deleted
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)deleteTemplateWithID:(NSString *)templateID
           completionHandler:(void (^)(void))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler;

@end
