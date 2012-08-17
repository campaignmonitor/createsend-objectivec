//
//  CSTemplate.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSTemplate.h"

@implementation CSTemplate

+ (id)templateWithDictionary:(NSDictionary *)templateDictionary
{
    CSTemplate *template = [[self alloc] init];
    template.templateID = [templateDictionary valueForKey:@"TemplateID"];
    template.name = [templateDictionary valueForKey:@"Name"];
    template.previewPage = [templateDictionary valueForKey:@"PreviewURL"];
    template.screenshotPage = [templateDictionary valueForKey:@"ScreenshotURL"];
    return template;
}
@end
