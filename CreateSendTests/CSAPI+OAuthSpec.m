#import "CSSpecHelper.h"
#import "CSAPI.h"
#import "CSAPI+OAuth.h"

SPEC_BEGIN(CSAPIOAuthSpec)

describe(@"CSAPI+OAuth", ^{
    registerMatchers(@"OV");
    
    context(@"when an api caller is authenticated", ^{
        __block CSAPI *cs = nil;
        NSString *clientID = @"12345";
        NSString *clientSecret = @"hanshotfirst";
        NSArray *scope = @[CSAPIClientScopeManageLists, CSAPIClientScopeImportSubscribers];
        
        beforeEach(^{
            cs = [[CSAPI alloc] initWithClientID:clientID clientSecret:clientSecret scope:scope];
        });
        
        it(@"appScheme should be properly formatted", ^{
            [[cs.appScheme should] equal:@"csapi12345"];
        });
        
        it(@"authorizationURL should be properly formatted", ^{
            [[cs.authorizationURL.absoluteString should] equal:@"https://api.createsend.com/oauth?type=web_server&client_id=12345&redirect_uri=csapi12345%3A%2F%2Fauthorize&scope=ManageLists,ImportSubscribers"];
        });
        
        it(@"appConformsToScheme should be true if the appScheme URL Scheme is set in the main bundle", ^{
            NSBundle *mainBundle = [[NSBundle alloc] init];
            [mainBundle stub:@selector(infoDictionary) andReturn:@{@"CFBundleURLTypes": @[@{@"CFBundleURLSchemes": @[@"csapi12345"]}]}];
            [[NSBundle should] receive:@selector(mainBundle) andReturn:mainBundle];
            
            [[theValue([cs appConformsToScheme]) should] beTrue];
        });
        
        it(@"appConformsToScheme should be false if the appScheme URL Scheme is not set in the main bundle", ^{
            NSBundle *mainBundle = [[NSBundle alloc] init];
            [mainBundle stub:@selector(infoDictionary) andReturn:@{@"CFBundleURLTypes": @[@{@"CFBundleURLSchemes": @[]}]}];
            [[NSBundle should] receive:@selector(mainBundle) andReturn:mainBundle];
            
            [[theValue([cs appConformsToScheme]) should] beFalse];
        });
        
        it(@"should get authorization with parameters", ^{
            NSURLRequest *request = nil;
            __block NSDictionary *authorizationInfo = nil;
            [self stubSendAsynchronousRequestAndReturnResponseWithFixtureNamed:@"oauth_token.json" returningRequest:&request whileExecutingBlock:^{
                NSDictionary *parameters = @{@"grant_type": @"authorization_code", @"redirect_uri": @"csapi12345://authorize"};
                [cs getAuthorizationInfoWithParameters:parameters completionHandler:^(NSDictionary *response) {
                    authorizationInfo = response;
                } errorHandler:^(NSError *errorResponse) {
                    [errorResponse shouldBeNil];
                }];
            }];
            
            [authorizationInfo shouldNotBeNil];
            [[[authorizationInfo objectForKey:@"access_token"] should] equal:@"SlAV32hkKG"];
            [[[authorizationInfo objectForKey:@"refresh_token"] should] equal:@"tGzv3JOkF0XG5Qx2TlKWIA"];
            [[[authorizationInfo objectForKey:@"expires_in"] should] equal:theValue(1209600)];
            
            [[request.URL.absoluteString should] equal:cs.authConfig.tokenURL.absoluteString];
            [[request.HTTPMethod should] equal:@"POST"];
            [[[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] should] equal:@"redirect_uri=csapi12345%3A%2F%2Fauthorize&grant_type=authorization_code"];
        });
        
        it(@"should get authorization with code", ^{
            NSURLRequest *request = nil;
            [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                NSString *code = @"authcode";
                NSDictionary *expectedParameters = @{@"grant_type": @"authorization_code", @"client_id": clientID, @"client_secret": clientSecret, @"code": code, @"redirect_uri": @"csapi12345://authorize"};
                [[cs should] receive:@selector(getAuthorizationInfoWithParameters:completionHandler:errorHandler:) withArguments:expectedParameters, any(), any(), nil];
                [cs getAuthorizationInfoWithCode:code completionHandler:^(NSDictionary *response) {
                } errorHandler:^(NSError *errorResponse) {
                    [errorResponse shouldBeNil];
                }];
            }];
        });
        
        it(@"should refresh authorization info", ^{
            NSURLRequest *request = nil;
            [NSURLConnection stubSendAsynchronousRequestAndReturnRequest:&request whileExecutingBlock:^{
                NSString *refresh_token = @"tGzv3JOkF0XG5Qx2TlKWIA";
                NSDictionary *expectedParameters = @{@"grant_type": @"refresh_token", @"refresh_token": refresh_token};
                [cs.authConfig stub:@selector(refreshToken) andReturn:refresh_token];
                [[cs should] receive:@selector(getAuthorizationInfoWithParameters:completionHandler:errorHandler:) withArguments:expectedParameters, any(), any(), nil];
                [cs refreshAuthorizationInfo:^(NSDictionary *response) {
                } errorHandler:^(NSError *errorResponse) {
                    [errorResponse shouldBeNil];
                }];
            }];
        });
        
        context(@"can open url", ^{
            it(@"should be true if the url scheme matches the app scheme and the host matches a valid method", ^{
                [[theValue([cs canOpenURL:[NSURL URLWithString:@"csapi12345://authorize"]]) should] beTrue];
            });
            
            it(@"should be false if the url scheme does not match the app scheme", ^{
                [[theValue([cs canOpenURL:[NSURL URLWithString:@"csapi99999://authorize"]]) should] beFalse];
            });
            
            it(@"should be false if the host does not match a valid method", ^{
                [[theValue([cs canOpenURL:[NSURL URLWithString:@"csapi12345://invalid"]]) should] beFalse];
            });
        });
    });
});

SPEC_END
