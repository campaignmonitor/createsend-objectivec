//
//  CSCampaignTests.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSCampaignCreateRequest.h"


@interface CSCampaignTests : GHAsyncTestCase
@end


@implementation CSCampaignTests


- (void)performRequest:(CSAPIRequest *)request forTestWithSelector:(SEL)selector {
  [self prepare];

  [request setCompletionBlock:^{ [self notify:kGHUnitWaitStatusSuccess forSelector:selector]; }];
  [request setFailedBlock:^{ [self notify:kGHUnitWaitStatusFailure forSelector:selector]; }];

  [request startAsynchronous];

  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}


# pragma mark -
# pragma mark CSCampaignCreateRequest


- (void)testCSCampaignCreateRequest {
  CSCampaignCreateRequest* request = [CSCampaignCreateRequest requestWithClientID:kCSTestsValidClientID
                                                                             name:@"Campaign Name"
                                                                          subject:@"Subject"
                                                                         fromName:@"John Doe"
                                                                        fromEmail:@"johndoe@example.com"
                                                                          replyTo:@"johndoe@example.com"
                                                                    HTMLURLString:@"http://example.com/campaigncontent/index.html"
                                                                    textURLString:@"http://example.com/campaigncontent/index.txt"
                                                                          listIDs:[NSArray array]
                                                                       segmentIDs:[NSArray array]];
  request.username = kCSTestsValidAPIKey;

  [self performRequest:request forTestWithSelector:_cmd];

  GHAssertNil(request.error, @"");
}



@end
