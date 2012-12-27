//
//  CSAPI+Templates.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSAPI+Templates.h"

@implementation CSAPI (Templates)

- (void)getTemplateDetailsWithTemplateID:(NSString *)templateID
                       completionHandler:(void (^)(CSTemplate *template))completionHandler
                            errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient get:[NSString stringWithFormat:@"templates/%@.json", templateID] success:^(NSDictionary *response) {
        CSTemplate *template = [CSTemplate templateWithDictionary:response];
        if (completionHandler) completionHandler(template);
    } failure:errorHandler];
}

- (void)createTemplateWithClientID:(NSString *)clientID
                              name:(NSString *)name
                       htmlURLURL:(NSString *)htmlURLURL
                        zipFileURL:(NSString *)zipFileURL
                 completionHandler:(void (^)(NSString *templateID))completionHandler
                      errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{@"Name": name, @"htmlURLURL": htmlURLURL, @"ZipFileURL": zipFileURL};
    [self.restClient post:[NSString stringWithFormat:@"templates/%@.json", clientID] withParameters:parameters success:completionHandler failure:errorHandler];
}

- (void)updateTemplateWithTemplateID:(NSString *)templateID
                                name:(NSString *)name
                         htmlURLURL:(NSString *)htmlURLURL
                          zipFileURL:(NSString *)zipFileURL
                   completionHandler:(void (^)(void))completionHandler
                        errorHandler:(CSAPIErrorHandler)errorHandler
{
    NSDictionary *parameters = @{@"Name": name, @"htmlURLURL": htmlURLURL, @"ZipFileURL": zipFileURL};
    [self.restClient put:[NSString stringWithFormat:@"templates/%@.json", templateID] withParameters:parameters success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}

- (void)deleteTemplateWithID:(NSString *)templateID
           completionHandler:(void (^)(void))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler
{
    [self.restClient delete:[NSString stringWithFormat:@"templates/%@.json", templateID] withParameters:nil success:^(id response) {
        if (completionHandler) completionHandler();
    } failure:errorHandler];
}
@end
