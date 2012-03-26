//
//  CSAPI+Segments.m
//  CreateSend
//
//  Created by Nathan de Vries on 30/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI+Segments.h"

@implementation CSAPI (Segments)

- (void)getSegmentsWithClientID:(NSString *)clientID
              completionHandler:(void (^)(NSArray* segments))completionHandler
                   errorHandler:(CSAPIErrorHandler)errorHandler {
  
  [self.restClient getPath:[NSString stringWithFormat:@"clients/%@/segments.json", clientID]
                parameters:nil
                   success:completionHandler
                   failure:errorHandler];
}

@end
