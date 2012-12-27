//
//  CSSpecHelper.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSSpecHelper.h"

NSString * const CSAPIErrorNotFoundMessage = @"We couldn't find the resource you're looking for. Please check the documentation and try again";
NSString * const CSAPIErrorInvalidEmailAddressMessage = @"Please provide a valid email address.";
NSString * const CSAPIErrorInvalidClientMessage = @"Invalid ClientID";
NSString * const CSAPIErrorWebhookRequestFailedMessage = @"The webhook request has failed";
NSString * const CSAPIErrorListTitleEmptyMessage = @"List Title Empty";
NSString * const CSAPIErrorInvalidKeyMessage = @"Invalid Key. Keys must be surrounded with [ ]";
NSString * const CSAPIErrorFieldKeyExistsMessage = @"The Field Key already exists";
NSString * const CSAPIErrorInvalidWebhookURLMessage = @"Invalid Webhook URL";

@implementation KWSpec (CSSpecHelper)
+ (void)stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:(NSString *)fixtureName returningRequest:(NSURLRequest **)request whileExecutingBlock:(void (^)(void))block
{
    [NSURLConnection stubSendAsynchronousRequestAndExecuteCompletionHandlerWithData:[NSData fixtureDataWithFileNamed:fixtureName] returningRequest:request whileExecutingBlock:^{
        if (block) block();
    }];
}

+ (void)stubSendAsynchronousRequestAndReturnErrorResponseWithCode:(NSInteger)code message:(NSString *)message whileExecutingBlock:(void (^)(void))block
{
    NSURLRequest *request = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"Code": @(code), @"Message": message} options:0 error:nil];
    [NSURLConnection stubSendAsynchronousRequestAndExecuteCompletionHandlerWithData:data returningRequest:&request whileExecutingBlock:^{
        if (block) block();
    }];
}
@end
