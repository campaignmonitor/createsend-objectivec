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

@property (nonatomic, readwrite, assign) BOOL shouldAutoLoadCustomFields;
@property (nonatomic, readwrite, retain) NSArray* customFields;

+ (id)controllerWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID;
- (id)initWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID;

+ (id)controllerWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID customFields:(NSArray *)customFields;
- (id)initWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID customFields:(NSArray *)customFields;

+ (id)controllerWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID shouldAutoLoadCustomFields:(BOOL)shouldAutoLoadCustomFields;
- (id)initWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID shouldAutoLoadCustomFields:(BOOL)shouldAutoLoadCustomFields;

@end
