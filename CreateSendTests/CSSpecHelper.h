//
//  CSSpecHelper.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "Kiwi.h"
#import "NSData+FixtureAdditions.h"
#import "NSURLConnection+StubAdditions.h"
#import "OVErrorMatcher.h"
#import "NSString+URLEncoding.h"
#import "NSURL+CSAPI.h"

extern NSString * const CSAPIErrorNotFoundMessage;
extern NSString * const CSAPIErrorInvalidEmailAddressMessage;
extern NSString * const CSAPIErrorInvalidClientMessage;
extern NSString * const CSAPIErrorWebhookRequestFailedMessage;
extern NSString * const CSAPIErrorListTitleEmptyMessage;
extern NSString * const CSAPIErrorInvalidKeyMessage;
extern NSString * const CSAPIErrorFieldKeyExistsMessage;
extern NSString * const CSAPIErrorInvalidWebhookURLMessage;

@interface KWSpec (CSSpecHelper)
+ (void)stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:(NSString *)fixtureName returningRequest:(NSURLRequest **)request whileExecutingBlock:(void (^)(void))block;
+ (void)stubSendAsynchronousRequestAndReturnErrorResponseWithCode:(NSInteger)code message:(NSString *)message whileExecutingBlock:(void (^)(void))block;
@end
