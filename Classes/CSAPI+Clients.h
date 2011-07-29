//
//  CSAPI+Clients.h
//  CreateSend
//
//  Created by Nathan de Vries on 29/07/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSAPI.h"
#import "CSClient.h"

@interface CSAPI (Clients)

- (void)getClients:(void (^)(NSArray* clients))completionHandler
      errorHandler:(CSAPIErrorHandler)errorHandler;

@end
