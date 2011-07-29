//
//  CSAPI.m
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"

@implementation CSAPI

@synthesize siteURL=_siteURL;
@synthesize APIKey=_APIKey;
@synthesize username=_username;
@synthesize password=_password;

- (id)initWithSiteURL:(NSString *)siteURL
               APIKey:(NSString *)APIKey {
    
    if ((self = [self init])) {
        self.siteURL = siteURL;
        self.APIKey = APIKey;
    }
    return self;
}

- (id)initWithSiteURL:(NSString *)siteURL
             username:(NSString *)username
             password:(NSString *)password {
    
    if ((self = [self init])) {
        self.siteURL = siteURL;
        self.username = username;
        self.password = password;
    }
    return self;
}

- (void)dealloc {
    self.siteURL = nil;
    self.APIKey = nil;
    self.username = nil;
    self.password = nil;
    
    [super dealloc];
}

@end
