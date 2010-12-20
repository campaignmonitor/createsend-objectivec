//
//  CSListStatsRequest.h
//  CreateSend
//
//  Created by Nathan de Vries on 20/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CSAPIRequest.h"


@interface CSListStatsRequest : CSAPIRequest


@property (retain) NSDictionary* listStatistics;


+ (id)requestWithListID:(NSString *)listID;


@end
