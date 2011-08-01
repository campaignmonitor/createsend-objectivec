//
//  CSSubscriptionViewController.h
//  CreateSend
//
//  Created by Nathan de Vries on 1/08/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSAPI;
@class CSSubscriptionFormFieldCell;

@interface CSSubscriptionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) CSAPI* API;

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) NSString* listID;
@property (nonatomic, retain) NSArray* customFields;

@property (nonatomic, retain) NSMutableArray* formFields;
@property (nonatomic, retain) CSSubscriptionFormFieldCell* activeFormFieldCell;

@property (nonatomic, retain) UIToolbar* formInputAccessoryToolbar;

- (id)initWithListID:(NSString *)listID;

@end
