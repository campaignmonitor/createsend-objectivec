#import "CSSpecHelper.h"
#import "NSURL+CSAPI.h"

#import "CSAPI.h"
#import "CSClient.h"
#import "CSList.h"

SPEC_BEGIN(CSAPITemplatesSpec)

describe(@"CSAPI+Templates", ^{
    registerMatchers(@"OV");
    
    context(@"when an api caller is authenticated", ^{
        __block CSAPI *cs = nil;
        NSString *templateID = @"98y2e98y289dh89h938389";
        
        beforeEach(^{
            cs = [[CSAPI alloc] init];
        });
        
        context(@"create a template", ^{
            NSString *clientID = @"87y8d7qyw8d7yq8w7ydwqwd";
            NSString *name = @"Template One";
            NSString *htmlURLURL = @"http://templates.org/index.html";
            NSString *zipFileURL = @"http://templates.org/files.zip";
            
            it(@"should create a template", ^{
                NSURLRequest *request = nil;
                __block NSString *templateID = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"create_template.json" returningRequest:&request whileExecutingBlock:^{
                    [cs createTemplateWithClientID:clientID name:name htmlURLURL:htmlURLURL zipFileURL:zipFileURL completionHandler:^(NSString *response) {
                        templateID = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [[templateID should] equal:@"98y2e98y289dh89h938389"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"templates/%@.json", clientID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"POST"];
                
                NSDictionary *expectedPostBody = @{@"Name": name, @"htmlURLURL": htmlURLURL, @"ZipFileURL": zipFileURL};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs createTemplateWithClientID:clientID name:name htmlURLURL:htmlURLURL zipFileURL:zipFileURL completionHandler:^(NSString *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"update a template", ^{
            NSString *name = @"Template One Updated";
            NSString *htmlURLURL = @"http://templates.org/index.html";
            NSString *zipFileURL = @"http://templates.org/files.zip";

            it(@"should update a template", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                    [cs updateTemplateWithTemplateID:templateID name:name htmlURLURL:htmlURLURL zipFileURL:zipFileURL completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"templates/%@.json", templateID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"PUT"];
                
                NSDictionary *expectedPostBody = @{@"Name": name, @"htmlURLURL": htmlURLURL, @"ZipFileURL": zipFileURL};
                NSDictionary *postBody = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                [[postBody should] equal:expectedPostBody];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs updateTemplateWithTemplateID:templateID name:name htmlURLURL:htmlURLURL zipFileURL:zipFileURL completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"delete a template", ^{
            it(@"should delete a template", ^{
                NSURLRequest *request = nil;
                [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^ {
                    [cs deleteTemplateWithID:templateID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"templates/%@.json", templateID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
                [[request.HTTPMethod should] equal:@"DELETE"];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs deleteTemplateWithID:templateID completionHandler:^() {
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
        
        context(@"get the details of a template", ^{
            it(@"should get the details of a template", ^{
                NSURLRequest *request = nil;
                __block CSTemplate *template = nil;
                [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"template_details.json" returningRequest:&request whileExecutingBlock:^{
                    [cs getTemplateDetailsWithTemplateID:templateID completionHandler:^(CSTemplate *response) {
                        template = response;
                    } errorHandler:^(NSError *errorResponse) {
                        [errorResponse shouldBeNil];
                    }];
                }];
                
                [template shouldNotBeNil];
                [[template.templateID should] equal:@"98y2e98y289dh89h938389"];
                [[template.name should] equal:@"Template One"];
                [[template.previewPage should] equal:@"http://preview.createsend.com/createsend/templates/previewTemplate.aspx?ID=01AF532CD8889B33&d=r&c=E816F55BFAD1A753"];
                [[template.screenshotPage should] equal:@"http://preview.createsend.com/ts/r/14/833/263/14833263.jpg?0318092600"];
                
                NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"templates/%@.json", templateID] relativeToURL:cs.baseURL];
                [[request.URL.absoluteString should] equal:expectedURL.absoluteString];
            });
            
            it(@"should return an error if there is one", ^{
                [self stubSendAsynchronousRequestAndReturnErrorResponseWithCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage whileExecutingBlock:^{
                    __block NSError *error = nil;
                    [cs getTemplateDetailsWithTemplateID:templateID completionHandler:^(CSTemplate *response) {
                        [response shouldBeNil];
                    } errorHandler:^(NSError *errorResponse) {
                        error = errorResponse;
                    }];
                    
                    [[error should] haveErrorCode:CSAPIErrorNotFound message:CSAPIErrorNotFoundMessage];
                }];
            });
        });
    });
});

SPEC_END