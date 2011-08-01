//
//  CSSubscriptionViewController.h
//  CreateSend
//
//  Created by Nathan de Vries on 1/08/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSList.h"
#import "CSCustomField.h"

@interface CSSubscriptionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) NSString* listID;
@property (nonatomic, retain) NSArray* customFields;

@property (nonatomic, retain) NSString* subscriberName;
@property (nonatomic, retain) NSString* subscriberEmailAddress;
@property (nonatomic, retain) NSArray* subscriberCustomFieldValues;

- (id)initWithListID:(NSString *)listID;

@end
