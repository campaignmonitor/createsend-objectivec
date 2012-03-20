//
//  CSList.h
//  CreateSend
//
//  Created by Nathan de Vries on 17/12/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents a list containing subscribers
 */
@interface CSList : NSObject

/** ID */
@property (retain) NSString* listID;

/** Title */
@property (retain) NSString* title;

/** URL for the list's unsubscribe page */
@property (retain) NSString* unsubscribePage;

/** URL for the list's subscription confirmation page */
@property (retain) NSString* confirmationSuccessPage;

/** Whether or not to confirm subscriptions */
@property (assign) BOOL confirmOptIn;

+ (id)listWithDictionary:(NSDictionary *)listDict;

@end
