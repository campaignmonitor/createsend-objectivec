//
//  CSSubscriptionFormViewController.h
//  CreateSend
//
//  Created by Nathan de Vries on 27/03/12.
//  Copyright (c) 2012 Nathan de Vries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IBAForms/IBAForms.h>

@class CSAPI;

@interface CSSubscriptionFormViewController : IBAFormViewController

@property (nonatomic, readwrite, retain) CSAPI* API;
@property (nonatomic, readwrite, copy) NSString* listID;

+ (id)controllerWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID;
- (id)initWithWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID;

@end
