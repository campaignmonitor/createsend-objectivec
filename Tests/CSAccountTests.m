//
//  CSAccountTests.m
//  CreateSend
//
//  Created by Nathan de Vries on 16/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSTestCase.h"

@interface CSAccountTests : CSTestCase
@end

@implementation CSAccountTests

- (void)testGetAPIKeyWithValidCredentials {
  [self testAsync:^{
    CSAPI* validCredentialsAPI;
    validCredentialsAPI = [[[CSAPI alloc] initWithSiteURL:kCSTestsValidSiteURL
                                                 username:kCSTestsValidUsername
                                                 password:kCSTestsValidPassword] autorelease];
    
    [validCredentialsAPI getAPIKey:^(NSString* APIKey){
      [self notifyTestFinished];
      GHAssertNotNil(APIKey, nil);
      
    } errorHandler:[self assertNoError]];
  }];
}

- (void)testGetAPIKeyWithInvalidCredentials {
  [self testAsync:^{
    CSAPI* invalidCredentialsAPI;
    invalidCredentialsAPI = [[[CSAPI alloc] initWithSiteURL:@"..."
                                                   username:@"..."
                                                   password:@"..."] autorelease];
    
    [invalidCredentialsAPI getAPIKey:^(NSString* APIKey){
      [self notifyTestFinished];
      GHAssertNil(APIKey, nil);
      
    } errorHandler:[self assertError]];
  }];
}

- (void)testGetClients {
  [self testAsync:^{
    [self.testAPI getClients:^(NSArray* clients) {
      [self notifyTestFinished];
      GHAssertTrue([clients count] > 0, nil);
      
    } errorHandler:[self assertNoError]];
  }];
}

- (void)testGetCountries {
  [self testAsync:^{
    [self.testAPI getCountries:^(NSArray* countries) {
      [self notifyTestFinished];
      GHAssertTrue([countries count] > 0, nil);
      
    } errorHandler:[self assertNoError]];
  }];
}

- (void)testGetTimezones {
  [self testAsync:^{
    [self.testAPI getTimezones:^(NSArray* timezones) {
      [self notifyTestFinished];
      GHAssertTrue([timezones count] > 0, nil);
      
    } errorHandler:[self assertNoError]];
  }];
}

- (void)testGetSystemDate {
  [self testAsync:^{
    [self.testAPI getSystemDate:^(NSDate* systemDate) {
      [self notifyTestFinished];
      GHAssertNotNil(systemDate, nil);
      
    } errorHandler:[self assertNoError]];
  }];
}

@end
