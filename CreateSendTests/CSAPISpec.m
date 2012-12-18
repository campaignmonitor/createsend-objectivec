#import "CSSpecHelper.h"
#import "CSAPI.h"

SPEC_BEGIN(CSAPISpec)

describe(@"CSAPI", ^{
    context(@"when an api caller is initialized", ^{
        __block CSAPI *cs = nil;
        NSString *clientID = @"12345";
        NSString *clientSecret = @"hanshotfirst";
        NSArray *scope = @[CSAPIClientScopeManageLists, CSAPIClientScopeImportSubscribers];

        beforeEach(^{
            cs = [[CSAPI alloc] initWithClientID:clientID clientSecret:clientSecret scope:scope];
        });

        it(@"should have the correct baseURL by default", ^{
            [[cs.baseURL.absoluteString should] equal:@"https://api.createsend.com/api/v3/"];
        });

        it(@"should allow baseURL to be set", ^{
            cs.baseURL = [NSURL URLWithString:@"https://anotherurl.net/api/"];
            [[cs.baseURL.absoluteString should] equal:@"https://anotherurl.net/api/"];
        });
        
        it(@"should have the correct userAgent", ^{
            [[cs.userAgent should] equal:[NSString stringWithFormat:@"createsend-objc-%@", CSCreateSendVersion]];
        });
        
        it(@"authConfig should be configured", ^{
            [[cs.authConfig.clientID should] equal:clientID];
            [[cs.authConfig.clientSecret should] equal:clientSecret];
            [[cs.authConfig.scope should] equal:scope];
            [[cs.authConfig.redirectURL.absoluteString should] equal:@"csapi12345://authorize"];
            [[cs.authConfig.tokenURL.absoluteString should] equal:@"https://api.createsend.com/oauth/token"];
        });
        
        it(@"restClient should be configured", ^{
            [[cs.restClient.baseURL.absoluteString should] equal:cs.baseURL.absoluteString];
            [[(id)cs.restClient.delegate should] beIdenticalTo:cs];
        });
    });
    
    context(@"isValidEmailAddress", ^{
        it(@"should be case insensitive", ^{
            [[@([CSAPI isValidEmailAddress:@"email@example.com"]) should] beTrue];
            [[@([CSAPI isValidEmailAddress:@"EMAIL@EXAMPLE.COM"]) should] beTrue];
            [[@([CSAPI isValidEmailAddress:@"eMAil@eXAmPle.CoM"]) should] beTrue];
        });
        
        context(@"should be true for", ^{
//          Note: Campaign Monitor supports common formats and not the full range of RFC compliant addresses
            it(@"commonly formatted email addresses", ^{
                [[@([CSAPI isValidEmailAddress:@"niceandsimple@example.com"]) should] beTrue];
                [[@([CSAPI isValidEmailAddress:@"very.common@example.com"]) should] beTrue];
                [[@([CSAPI isValidEmailAddress:@"a.little.lengthy.but.fine@dept.example.com"]) should] beTrue];
                [[@([CSAPI isValidEmailAddress:@"disposable.style.email.with+symbol@example.com"]) should] beTrue];
            });
        });
        
        context(@"should be false for", ^{
            it(@"a nil email address", ^{
                [[@([CSAPI isValidEmailAddress:nil]) should] beFalse];
            });
            
            it(@"an empty email address", ^{
                [[@([CSAPI isValidEmailAddress:@""]) should] beFalse];
            });
            
            
//          http://en.wikipedia.org/wiki/Email_address#Invalid_email_addresses
            it(@"invalid email addresses", ^{
                [[@([CSAPI isValidEmailAddress:@"Abc.example.com"]) should] beFalse]; // (an @ character must separate the local and domain parts)
                [[@([CSAPI isValidEmailAddress:@"Abc.@example.com"]) should] beFalse]; // (character dot(.) is last in local part)
                [[@([CSAPI isValidEmailAddress:@"Abc..123@example.com"]) should] beFalse]; // (character dot(.) is double)
                [[@([CSAPI isValidEmailAddress:@"A@b@c@example.com"]) should] beFalse]; // (only one @ is allowed outside quotation marks)
                [[@([CSAPI isValidEmailAddress:@"a\"b(c)d,e:f;g<h>i[j\\k]l@example.com"]) should] beFalse]; // (none of the special characters in this local part is allowed outside quotation marks)
                [[@([CSAPI isValidEmailAddress:@"just\"not\"right@example.com"]) should] beFalse]; // (quoted strings must be dot separated, or the only element making up the local-part)
                [[@([CSAPI isValidEmailAddress:@"this is\"not\\allowed@example.com"]) should] beFalse]; // (spaces, quotes, and backslashes may only exist when within quoted strings and preceded by a slash)
                [[@([CSAPI isValidEmailAddress:@"this\\ still\\\"not\\\\allowed@example.com"]) should] beFalse]; // (even if escaped (preceded by a backslash), spaces, quotes, and backslashes must still be contained by quotes)
            });
            
        });
    });
});

SPEC_END