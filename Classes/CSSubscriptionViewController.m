//
//  CSSubscriptionViewController.m
//  CreateSend
//
//  Created by Nathan de Vries on 1/08/11.
//  Copyright 2011 Nathan de Vries. All rights reserved.
//

#import "CSSubscriptionViewController.h"

#import "CSAPI.h"

#import "CSSubscriptionFormField.h"
#import "CSSubscriptionFormFieldCell.h"

@interface UIResponder (InputViews)
- (void)setInputView:(UIView *)inputView;
- (void)setInputAccessoryView:(UIView *)accessoryView;
@end

@interface CSSubscriptionViewController ()
- (void)subscribeButtonPressed:(UIBarButtonItem *)subscribeButton;
- (void)loadCustomFields;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

- (void)formInputAccessoryNextPreviousSegmentPressed:(UISegmentedControl *)nextPreviousSegment;
- (void)formInputAccessoryDoneButtonPressed:(UIBarButtonItem *)doneButton;

- (void)makeFormFieldCellActive:(CSSubscriptionFormFieldCell *)formFieldCell;
@end

@implementation CSSubscriptionViewController

@synthesize API=_API;
@synthesize tableView=_tableView;
@synthesize listID=_listID;
@synthesize customFields=_customFields;
@synthesize formFields=_formFields;
@synthesize activeFormFieldCell=_activeFormFieldCell;
@synthesize formInputAccessoryToolbar=_formInputAccessoryToolbar;


- (id)initWithListID:(NSString *)listID {
  if ((self = [self init])) {
    self.listID = listID;
    
    NSArray* primaryFields = [NSArray arrayWithObjects:
                              [CSSubscriptionFormTextField fieldWithKey:@"name"
                                                                  label:@"Name"
                                                                  value:@""
                                                           keyboardType:UIKeyboardTypeDefault],
                              
                              [CSSubscriptionFormTextField fieldWithKey:@"email"
                                                                  label:@"Email"
                                                                  value:@""
                                                           keyboardType:UIKeyboardTypeEmailAddress],
                              nil];
    
    self.formFields = [NSMutableArray arrayWithObject:primaryFields];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Subscribe"
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(subscribeButtonPressed:)] autorelease];
    
    self.API = [[[CSAPI alloc] initWithSiteURL:@"http://nathandevries.createsend.com/"
                                        APIKey:@"a0d82bbef67298bc91cbf3dbfde139be"] autorelease];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
  
  self.tableView = nil;
  self.listID = nil;
  self.customFields = nil;
  self.formFields = nil;
  self.API = nil;
  self.activeFormFieldCell = nil;
  
  [super dealloc];
}

# pragma mark - View Lifecycle

- (void)loadView {
  [super loadView];
  
  if (!self.customFields) {
    [self loadCustomFields];
  }
  
  self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] autorelease];
  self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  [self.view addSubview:self.tableView];
  
  
  UISegmentedControl* nextPreviousSegment;
  nextPreviousSegment = [[[UISegmentedControl alloc] initWithItems:[NSArray  arrayWithObjects:@"Previous", @"Next", nil]] autorelease];
  nextPreviousSegment.segmentedControlStyle = UISegmentedControlStyleBar;
  nextPreviousSegment.tintColor = [UIColor blackColor];
  nextPreviousSegment.momentary = YES;
  [nextPreviousSegment addTarget:self action:@selector(formInputAccessoryNextPreviousSegmentPressed:) forControlEvents:UIControlEventValueChanged];
  
  UIBarButtonItem* nextPreviousItem = [[[UIBarButtonItem alloc] initWithCustomView:nextPreviousSegment] autorelease];
  
  UIBarButtonItem* doneItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                             target:self 
                                                                             action:@selector(formInputAccessoryDoneButtonPressed:)] autorelease];
  
  UIBarButtonItem* flexibleSpace;
  flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                 target:nil
                                                                 action:nil] autorelease];
  
  UIToolbar* formInputAccessoryToolbar = [[[UIToolbar alloc] initWithFrame:CGRectZero] autorelease];
  formInputAccessoryToolbar.barStyle = UIBarStyleBlack;
  [formInputAccessoryToolbar sizeToFit];
  
  [formInputAccessoryToolbar setItems:[NSArray arrayWithObjects:nextPreviousItem, flexibleSpace, doneItem, nil]];
  
  self.formInputAccessoryToolbar = formInputAccessoryToolbar;
}

- (void)formInputAccessoryNextPreviousSegmentPressed:(UISegmentedControl *)nextPreviousSegment {
  NSIndexPath* indexPath = [self.tableView indexPathForCell:self.activeFormFieldCell];
  NSInteger rows = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
  
  NSIndexPath* newActiveIndexPath = nil;
  if (nextPreviousSegment.selectedSegmentIndex == 0) {
    // Previous segment pressed
    if (indexPath.row > 0) {
      newActiveIndexPath = [NSIndexPath indexPathForRow:(indexPath.row - 1)
                                              inSection:indexPath.section];
    }
    
  } else {
    // Next segment pressed
    if ((NSInteger)indexPath.row < rows - 1) {
      newActiveIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1)
                                              inSection:indexPath.section];
    }
  }
  
  if (newActiveIndexPath) {
    [self.tableView scrollToRowAtIndexPath:newActiveIndexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    
    CSSubscriptionFormFieldCell* newActiveCell;
    newActiveCell = (CSSubscriptionFormFieldCell *)[self.tableView cellForRowAtIndexPath:newActiveIndexPath];
    [self makeFormFieldCellActive:newActiveCell];
    
  } else {
    
  }
}

- (void)formInputAccessoryDoneButtonPressed:(UIBarButtonItem *)doneButton {
  [self.activeFormFieldCell resignFirstResponder];
  self.activeFormFieldCell = nil;
}

- (void)viewDidUnload {
  self.tableView = nil;
  self.formInputAccessoryToolbar = nil;
  
  [super viewDidUnload];
}

# pragma mark - UITableViewDelegate & UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.formFields count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [(NSArray *)[self.formFields objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CSSubscriptionFormField* formField = [[self.formFields objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  CSSubscriptionFormFieldCell* cell;
  cell = (CSSubscriptionFormFieldCell *)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([formField class])];
  
  if (cell == nil) {
    cell = [formField cell];
  }
  
  cell.field = formField;
  
  return cell;
}

- (void)makeFormFieldCellActive:(CSSubscriptionFormFieldCell *)formFieldCell {
  if (self.activeFormFieldCell) {
    [self.activeFormFieldCell resignFirstResponder];
    
  }
  
  if (formFieldCell != self.activeFormFieldCell) {
    self.activeFormFieldCell = formFieldCell;
    
    [self.activeFormFieldCell setInputAccessoryView:self.formInputAccessoryToolbar];
    [self.activeFormFieldCell becomeFirstResponder];
    
  } else {
    self.activeFormFieldCell = nil;
  }
}

- (NSArray *)allFormFields {
  NSMutableArray* allFields = [NSMutableArray array];
  for (NSArray* fields in self.formFields) {
    [allFields addObjectsFromArray:fields];
  }
  return [NSArray arrayWithArray:allFields];
}

- (NSIndexPath *)indexPathForFormField:(CSSubscriptionFormField *)formField {
  NSIndexPath* indexPath = nil;
  
  NSInteger section = 0;
  for (NSArray* fields in self.formFields) {
    NSInteger row = 0;
    for (CSSubscriptionFormField* field in fields) {
      if ([field isEqual:formField]) {
        indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        break;
      }
      row++;
    }
    section++;
  }
  
  return indexPath;
}

- (CSSubscriptionFormField *)textFormFieldAfter:(CSSubscriptionFormField *)formField {
  CSSubscriptionFormField* nextField = nil;
  
  NSArray* allFields = [self allFormFields];  
  NSUInteger formFieldIndex = [allFields indexOfObject:formField];
  
  if (formFieldIndex != NSNotFound && (formFieldIndex < [allFields count])) {
    nextField = [allFields objectAtIndex:formFieldIndex + 1];
  }
  
  return nextField;
}

- (CSSubscriptionFormField *)textFormFieldBefore:(CSSubscriptionFormField *)formField {
  return nil;
//  CSSubscriptionFormField* previousField = nil;
//  
//  NSArray* allFields = [self allFormFields];  
//  NSUInteger formFieldIndex = [allFields indexOfObject:formField];
//  
//  if (formFieldIndex != NSNotFound && (formFieldIndex - 1 < [allFields count] - 1)) {
//    nextField = [allFields objectAtIndex:formFieldIndex + 1];
//  }
//  
//  return nextField;
}

- (NSArray *)formFieldsInSection:(NSInteger)section {
  return [self.formFields objectAtIndex:section];
}

- (CSSubscriptionFormField *)formFieldForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [[self formFieldsInSection:indexPath.section] objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CSSubscriptionFormFieldCell* cell = (CSSubscriptionFormFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
  CSSubscriptionFormField* formField = [self formFieldForRowAtIndexPath:indexPath];
  
  if ([formField isKindOfClass:[CSSubscriptionFormTextField class]]) {
    if ([cell isFirstResponder]) {
      [cell resignFirstResponder];
      
    } else {
      [cell becomeFirstResponder];
    }
    
  } else if ([formField isKindOfClass:[CSSubscriptionFormOptionsField class]]) {
    // push options table view controller
  }
}

# pragma mark - IBActions

- (void)subscribeButtonPressed:(UIBarButtonItem *)subscribeButton {
  NSArray* primaryFields = [self.formFields objectAtIndex:0];
  CSSubscriptionFormTextField* nameField = [primaryFields objectAtIndex:0];
  CSSubscriptionFormTextField* emailField = [primaryFields objectAtIndex:1];
  
  NSMutableArray* customFieldValues = [NSMutableArray array];
  for (CSSubscriptionFormField* field in [self.formFields objectAtIndex:1]) {
    if (field.value)
      [customFieldValues addObject:[CSCustomField dictionaryWithValue:field.value
                                                          forFieldKey:field.key]];
  }
  
  [self.API subscribeToListWithID:self.listID
                     emailAddress:emailField.value
                             name:nameField.value
                shouldResubscribe:YES
                customFieldValues:customFieldValues
                completionHandler:^(NSString *subscribedAddress) {
                  [[[[UIAlertView alloc] initWithTitle:@"Success!"
                                               message:@"You've been subscribed to the list."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil] autorelease] show];
                  
                } errorHandler:^(NSError *error) {
                  [[[[UIAlertView alloc] initWithTitle:@"Uh Oh!"
                                               message:[NSString stringWithFormat:@"Unable to subscribe\n\nReason: %@", [error localizedDescription]]
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil] autorelease] show];
                }];
}

# pragma mark - Dynamic Custom Field Fetching

- (void)configureFormFieldsWithCustomFields:(NSArray *)customFields {
  NSMutableArray* customFormFields = [NSMutableArray array];
  
  for (CSCustomField* customField in customFields) {
    switch (customField.dataType) {
      case CSCustomFieldTextDataType: {
        [customFormFields addObject:[CSSubscriptionFormTextField fieldWithKey:customField.key
                                                                        label:customField.name
                                                                        value:nil
                                                                 keyboardType:UIKeyboardTypeDefault]];
        break;
      }
      case CSCustomFieldNumberDataType: {
        [customFormFields addObject:[CSSubscriptionFormTextField fieldWithKey:customField.key
                                                                        label:customField.name
                                                                        value:nil
                                                                 keyboardType:UIKeyboardTypeNumberPad]];
        break;
      }
      case CSCustomFieldMultiSelectOneDataType:
      case CSCustomFieldCountryDataType:
      case CSCustomFieldUSStateDataType: {
        [customFormFields addObject:[CSSubscriptionFormOptionsField fieldWithKey:customField.key
                                                                           label:customField.name
                                                                           value:nil
                                                                         options:customField.options
                                                               multipleSelection:NO]];
        break;
      }
      case CSCustomFieldMultiSelectManyDataType: {
        [customFormFields addObject:[CSSubscriptionFormOptionsField fieldWithKey:customField.key
                                                                           label:customField.name
                                                                           value:nil
                                                                         options:customField.options
                                                               multipleSelection:YES]];
        break;
      }
      default: {
        [customFormFields addObject:[CSSubscriptionFormTextField fieldWithKey:customField.key
                                                                        label:customField.name
                                                                        value:nil
                                                                 keyboardType:UIKeyboardTypeDefault]];
        break;
      }
    }
  }
  
  [self.formFields insertObject:customFormFields atIndex:1];
  [self.tableView reloadData];
}

- (void)loadCustomFields {
  [self.API getCustomFieldsWithListID:self.listID
                    completionHandler:^(NSArray* customFields) {
                      
                      [self configureFormFieldsWithCustomFields:customFields];
                      
                    } errorHandler:^(NSError *error) {
                      [[[[UIAlertView alloc] initWithTitle:@"Uh Oh!"
                                                   message:[NSString stringWithFormat:@"Unable to load custom fields\n\n%@", [error localizedDescription]]
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil] autorelease] show];
                    }];
}

# pragma mark - Keyboard Show / Hide

- (void)animateTableViewEdgeInsetWithBottom:(CGFloat)bottom animationDuration:(NSTimeInterval)animationDuration {
  if (self.tableView.contentInset.bottom == bottom)
    return;
  
  [UIView animateWithDuration:animationDuration
                   animations:^{
                     UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.f, 0.f, bottom, 0.f);
                     self.tableView.contentInset = edgeInsets;
                     self.tableView.scrollIndicatorInsets = edgeInsets;
                   }
                   completion: ^(BOOL finished){
                     self.tableView.scrollEnabled = YES;
                   }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
  CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
  NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
  [self animateTableViewEdgeInsetWithBottom:keyboardFrame.size.height
                          animationDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification {
  NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
  [self animateTableViewEdgeInsetWithBottom:0.f
                          animationDuration:animationDuration];
}

@end
