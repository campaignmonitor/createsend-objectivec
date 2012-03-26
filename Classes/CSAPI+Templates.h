//
//  CSAPI+Templates.h
//  CreateSend
//
//  Created by Nathan de Vries on 30/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"

/**
 Template-related APIs. See CSAPI for documentation of the other API categories.
 */
@interface CSAPI (Templates)

/**
 Get a list of all templates belonging to a particular client.
 
     http://www.campaignmonitor.com/api/clients/#getting_client_templates
 
 @param clientID The ID of the client for which templates should be retrieved
 @param completionHandler Completion callback, with an array of template
 dictionaries as the first and only argument. Dictionaries are in the following
 format:
 
     {
       "TemplateID": "5cac213cf061dd4e008de5a82b7a3621",
       "Name": "Template One",
       "PreviewURL": "http://preview.createsend.com/templates/publicpreview/01AF532CD8889B33?d=r",
       "ScreenshotURL": "http://preview.createsend.com/ts/r/14/833/263/14833263.jpg?0318092541"
     }
 
 @param errorHandler Error callback
 */
- (void)getTemplatesWithClientID:(NSString *)clientID
               completionHandler:(void (^)(NSArray* templates))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get all basic details for a specific template.
 
     http://www.campaignmonitor.com/api/templates/#getting_a_template
 
 @param templateID The ID of the template to be retrieved
 @param completionHandler Completion callback, with a template dictionary as the
 first and only argument. Dictionary is in the following format:
 
     {
       "TemplateID": "5cac213cf061dd4e008de5a82b7a3621",
       "Name": "Template One",
       "PreviewURL": "http://preview.createsend.com/templates/publicpreview/01AF532CD8889B33?d=r",
       "ScreenshotURL": "http://preview.createsend.com/ts/r/14/833/263/14833263.jpg?0318092600"
     }
 
 @param errorHandler Error callback
 */
- (void)getTemplateDetailsWithTemplateID:(NSString *)templateID
                       completionHandler:(void (^)(NSDictionary* template))completionHandler
                            errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Create a new template for a client.
 
     http://www.campaignmonitor.com/api/templates/#creating_a_template
 
 @param clientID The ID of the client for whom the template should be created
 @param name Name for the template
 @param htmlPageURL URL for the template HTML page
 @param zipFileURL URL for the template zip file
 @param completionHandler Completion callback, with the ID of the newly created template as the first and only argument
 @param errorHandler Error callback
 */
- (void)createTemplateWithClientID:(NSString *)clientID
                              name:(NSString *)name
                       htmlPageURL:(NSString *)htmlPageURL
                        zipFileURL:(NSString *)zipFileURL
                 completionHandler:(void (^)(NSString* templateID))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Update an existing template for a client.
 
     http://www.campaignmonitor.com/api/templates/#updating_a_template
 
 @param templateID The ID of the template to be updated
 @param name New name for the template
 @param htmlPageURL URL for the template HTML page
 @param zipFileURL URL for the template zip file
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)updateTemplateWithTemplateID:(NSString *)templateID
                                name:(NSString *)name
                         htmlPageURL:(NSString *)htmlPageURL
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
