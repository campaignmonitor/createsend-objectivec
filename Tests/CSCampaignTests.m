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


- (void)setUpClass { [CSAPIRequest setDefaultAPIKey:kCSTestsValidAPIKey]; }
- (void)tearDownClass { [CSAPIRequest setDefaultAPIKey:nil]; }


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

  [self performRequest:request forTestWithSelector:_cmd];

  GHAssertNil(request.error, nil);
}



@end
