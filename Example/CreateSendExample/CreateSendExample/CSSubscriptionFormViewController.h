//
//  CSSubscriptionFormViewController.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IBAForms/IBAForms.h>

@class CSAPI;

/**
 Drop-in view controller which presents a subscription form. The view controller
 can be configured in a number of ways:
 
 1. Subscribe with name & email address fields only
 2. Subscribe with name, email address & some custom fields (specified at compile-time)
 3. Subscribe with name, email address & all custom fields (fetched at run-time)
 
 The last configuration allows custom fields to be added/removed from your CM
 dashboard, and the subscription form will update dynamically without needing
 to re-release your application.
 */
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
