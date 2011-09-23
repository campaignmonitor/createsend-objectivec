//
//  CSAPI.m
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"

@implementation CSAPI

@synthesize restClient=_restClient;

@synthesize siteURL=_siteURL;
@synthesize APIKey=_APIKey;
@synthesize username=_username;
@synthesize password=_password;

- (id)initWithSiteURL:(NSString *)siteURL {
  if ((self = [self init])) {    
    self.siteURL = siteURL;
    
    NSURL* baseURL = [NSURL URLWithString:@"http://api.createsend.com/api/v3/"];
    self.restClient = [[[CSRestClient alloc] initWithBaseURL:baseURL] autorelease];
  }
  return self;
}

- (id)initWithSiteURL:(NSString *)siteURL
               APIKey:(NSString *)APIKey {
  
  if ((self = [self initWithSiteURL:siteURL])) {
    self.APIKey = APIKey;
    
    [self.restClient setAuthorizationHeaderWithUsername:APIKey
                                               password:@""];
  }
  return self;
}

- (id)initWithSiteURL:(NSString *)siteURL
             username:(NSString *)username
             password:(NSString *)password {
  
  if ((self = [self initWithSiteURL:siteURL])) {
    self.username = username;
    self.password = password;
    
    [self.restClient setAuthorizationHeaderWithUsername:username
                                               password:password];
  }
  return self;
}

- (void)dealloc {
  self.restClient = nil;
  self.siteURL = nil;
  self.APIKey = nil;
  self.username = nil;
  self.password = nil;
  
  [super dealloc];
}

+ (NSDateFormatter *)sharedDateFormatter {
  static dispatch_once_t predicate;
  static NSDateFormatter* sharedDateFormatter = nil;
  
  dispatch_once(&predicate, ^{
    sharedDateFormatter = [[NSDateFormatter alloc] init];
    NSLocale* locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
    [sharedDateFormatter setLocale:locale];
    sharedDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
  });
  
  return sharedDateFormatter;
}

+ (NSDictionary *)paginationParametersWithPage:(NSUInteger)page
                                      pageSize:(NSUInteger)pageSize
                                    orderField:(NSString *)orderField
                                     ascending:(BOOL)ascending {
  
  return [NSDictionary dictionaryWithObjectsAndKeys:
          [NSString stringWithFormat:@"%d", page], @"page",
          [NSString stringWithFormat:@"%d", pageSize], @"pagesize",
          orderField, @"orderfield",
          (ascending ? @"asc" : @"desc"), @"orderdirection",
          nil];
}

@end
