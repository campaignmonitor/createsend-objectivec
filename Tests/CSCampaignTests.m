//
//  CSCampaignTests.m
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSTestCase.h"

@interface CSCampaignTests : CSTestCase
@end

@implementation CSCampaignTests

- (void)testCreateCampaign {
  [self testAsync:^{
    [self.testAPI createCampaignWithClientID:kCSTestsValidClientID
                                        name:@"Campaign Name"
                                     subject:@"Subject"
                                    fromName:@"John Doe"
                                   fromEmail:@"johndoe@example.com"
                                     replyTo:@"johndoe@example.com"
                               HTMLURLString:@"http://example.com/campaigncontent/index.html"
                               textURLString:@"http://example.com/campaigncontent/index.txt"
                                     listIDs:[NSArray array]
                                  segmentIDs:[NSArray array]
                           completionHandler:^(NSString *campaignID) {
                             
                             [self notifyTestFinished];
                             GHAssertNotNil(campaignID, nil);
                             
                           } errorHandler:[self assertNoError]];
  }];
}

@end
