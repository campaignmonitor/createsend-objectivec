//
//  CSSubscriptionFormViewController.m
//  CreateSend
//
//  Created by Nathan de Vries on 27/03/12.
//  Copyright (c) 2012 Nathan de Vries. All rights reserved.
//

#import "CSSubscriptionFormViewController.h"
#import "CSAPI.h"
#import "CSTableView.h"

@implementation CSSubscriptionFormViewController

@synthesize API=_API;
@synthesize listID=_listID;

+ (id)controllerWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID {
  return [[[self alloc] initWithWithAPI:API subscriptionListID:listID] autorelease];
}

- (id)initWithWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID {
  if ((self = [self init])) {
    self.title = NSLocalizedString(@"Subscribe to List", nil);
    
    self.API = API;
    self.listID = listID;
    
    NSMutableDictionary* model = [NSMutableDictionary dictionary];
    
    self.formDataSource = [[[IBAFormDataSource alloc] initWithModel:model] autorelease];
    
    // Name & Email Address Fields
    
    IBAFormSection* basicFormSection = [self.formDataSource addSectionWithHeaderTitle:nil
                                                                          footerTitle:nil];
    
    IBATextFormField* nameField = [[[IBATextFormField alloc] initWithKeyPath:@"name" title:NSLocalizedString(@"Name", nil)] autorelease];
    nameField.formFieldStyle = [self textFormFieldStyle];
    nameField.textFormFieldCell.textField.placeholder = @"Name";
    [basicFormSection addFormField:nameField];
    
    
		IBATextFormField* emailField = [[[IBATextFormField alloc] initWithKeyPath:@"email" title:NSLocalizedString(@"Email", nil)] autorelease];
    emailField.formFieldStyle = [self textFormFieldStyle];
    emailField.textFormFieldCell.textField.placeholder = @"Email";
    [basicFormSection addFormField:emailField];
    
    emailField.textFormFieldCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailField.textFormFieldCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailField.textFormFieldCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    
    
//    // Subscribe Button
//    
//    IBAFormSection* subscribeFormSection = [self.formDataSource addSectionWithHeaderTitle:nil footerTitle:nil];
//    
//		IBAButtonFormField* subscribeButtonField = [[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Subscribe", nil)
//                                                                                     icon:nil
//                                                                           executionBlock:[self subscribeAction]] autorelease];
//    
//    subscribeButtonField.formFieldStyle = [self buttonFormFieldStyle];
//    [subscribeFormSection addFormField:subscribeButtonField];
    
    //[self loadCustomFields];
  }
  return self;
}

- (IBAButtonFormFieldBlock)subscribeAction {
  return [Block_copy(^{
    
    NSMutableDictionary* formValues = [[(NSDictionary *)self.formDataSource.model mutableCopy] autorelease];
    
    NSString* email = [formValues objectForKey:@"email"];
    NSString* name = [formValues objectForKey:@"name"];
    [formValues removeObjectsForKeys:[NSArray arrayWithObjects:@"email", @"name", nil]];
    
    NSMutableArray* customFieldValues = [NSMutableArray array];
    [formValues enumerateKeysAndObjectsUsingBlock:^(NSString* customFieldKey, id customFieldValue, BOOL *stop) {
      if ([customFieldValue isKindOfClass:[NSSet class]]) {
        NSSet* customFieldOptions = (NSSet *)customFieldValue;
        for (IBAPickListFormOption* customFieldOption in customFieldOptions) {
          [customFieldValues addObject:[CSCustomField dictionaryWithValue:customFieldOption.name
                                                              forFieldKey:customFieldKey]];
        }
        
      } else if ([customFieldValue isKindOfClass:[NSDate class]]) {
        NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        dateFormatter.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        [customFieldValues addObject:[CSCustomField dictionaryWithValue:[dateFormatter stringFromDate:(NSDate *)customFieldValue]
                                                            forFieldKey:customFieldKey]];
        
      } else {
        [customFieldValues addObject:[CSCustomField dictionaryWithValue:customFieldValue
                                                            forFieldKey:customFieldKey]];
      }
    }];
    
    [self.API subscribeToListWithID:self.listID
                       emailAddress:email
                               name:name
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
    
  }) autorelease];
}

- (void)dealloc {
  [_API release], _API = nil;
  [_listID release], _listID = nil;
  
  [super dealloc];
}

#pragma mark - View Lifecycle

- (void)loadView {
  [super loadView];
  
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CSSubscriptionForm-Background-Pattern.png"]];
  
  CGRect tableViewFrame = CGRectMake(10.f, 0.f, self.view.bounds.size.width - 20.f, self.view.bounds.size.height);
  self.tableView = [[[CSTableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped] autorelease];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
                                     UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin);
  self.tableView.clipsToBounds = NO;
  self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, -10.f);
  
  CGRect headerPaddingRect = CGRectMake(0.f, 0.f, self.tableView.bounds.size.width, 10.f);
  self.tableView.tableHeaderView = [[[UIView alloc] initWithFrame:headerPaddingRect] autorelease];
  
  UIImage* subscribeButtonBackground = [[UIImage imageNamed:@"CSSubscriptionForm-Button-Background.png"] stretchableImageWithLeftCapWidth:8.f topCapHeight:0.f];
  UIButton* subscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [subscribeButton setBackgroundImage:subscribeButtonBackground forState:UIControlStateNormal];
  subscribeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
  [subscribeButton setTitleColor:[UIColor colorWithWhite:0.455f alpha:1.f] forState:UIControlStateNormal]; // #747474
  [subscribeButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
  [subscribeButton sizeToFit];
  
  CGRect footerPaddingRect = CGRectMake(0.f, 0.f, self.tableView.bounds.size.width, 10.f + subscribeButton.bounds.size.height);
  self.tableView.tableFooterView = [[[UIView alloc] initWithFrame:footerPaddingRect] autorelease];
  [self.tableView.tableFooterView addSubview:subscribeButton];
  
//  self.tableView.tableFooterView.backgroundColor = [UIColor greenColor];
//  subscribeButton.backgroundColor = [UIColor yellowColor];
  
  subscribeButton.frame = CGRectMake(roundf((self.tableView.tableFooterView.bounds.size.width - (subscribeButton.bounds.size.width + 20.f)) / 2.f),
                                     0.f,
                                     subscribeButton.bounds.size.width + 20.f,
                                     subscribeButton.bounds.size.height);
  
  [self.view addSubview:self.tableView];
}

# pragma mark - Dynamic Custom Field Fetching

- (void)loadCustomFields {
  [self.API getCustomFieldsWithListID:self.listID
                    completionHandler:^(NSArray* customFields) {
                      
                      [self configureFormWithCustomFields:customFields];
                      
                    } errorHandler:^(NSError *error) {
                      [[[[UIAlertView alloc] initWithTitle:@"Uh Oh!"
                                                   message:[NSString stringWithFormat:@"Unable to load custom fields\n\n%@", [error localizedDescription]]
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil] autorelease] show];
                    }];
}

- (void)configureFormWithCustomFields:(NSArray *)customFields {
  IBAFormSection* customFieldSection = [[[IBAFormSection alloc] initWithHeaderTitle:nil footerTitle:nil] autorelease];
  [self.formDataSource.sections insertObject:customFieldSection atIndex:1];
  customFieldSection.modelManager = self.formDataSource;
  customFieldSection.formFieldStyle = self.formDataSource.formFieldStyle;
  
  for (CSCustomField* customField in customFields) {
    switch (customField.dataType) {
      case CSCustomFieldNumberDataType: {
        IBATextFormField* numberField = [[[IBATextFormField alloc] initWithKeyPath:customField.key title:customField.name] autorelease];
        numberField.formFieldStyle = [self textFormFieldStyle];
        numberField.textFormFieldCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [customFieldSection addFormField:numberField];
        break;
      }
      case CSCustomFieldMultiSelectOneDataType:
      case CSCustomFieldCountryDataType:
      case CSCustomFieldUSStateDataType:
      case CSCustomFieldMultiSelectManyDataType: {
        NSArray* options;
        IBAPickListSelectionMode selectionMode;
        
        if (customField.dataType == CSCustomFieldMultiSelectManyDataType) {
          options = customField.options;
          selectionMode = IBAPickListSelectionModeMultiple;
          
        } else {
          options = [[NSArray arrayWithObject:@""] arrayByAddingObjectsFromArray:customField.options];
          selectionMode = IBAPickListSelectionModeSingle;
        }
        
        NSArray* picklistOptions = [IBAPickListFormOption pickListOptionsForStrings:options];
        IBAPickListFormField* selectField = [[[IBAPickListFormField alloc] initWithKeyPath:customField.key
                                                                                     title:customField.name
                                                                          valueTransformer:nil
                                                                             selectionMode:selectionMode
                                                                                   options:picklistOptions] autorelease];
        selectField.formFieldStyle = [self textFormFieldStyle];
        [customFieldSection addFormField:selectField];
        break;
      }
      case CSCustomFieldDateDataType: {
        IBADateFormField* dateField = [[[IBADateFormField alloc] initWithKeyPath:customField.key title:customField.name defaultValue:nil] autorelease];
        dateField.dateFormFieldType = IBADateFormFieldTypeDate;
        dateField.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        dateField.dateFormatter.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
        dateField.dateFormatter.dateFormat = @"yyyy-MM-dd";
        dateField.formFieldStyle = [self textFormFieldStyle];
        [customFieldSection addFormField:dateField];
        break;
      }
      default: {
        IBATextFormField* textField = [[[IBATextFormField alloc] initWithKeyPath:customField.key title:customField.name] autorelease];
        textField.formFieldStyle = [self textFormFieldStyle];
        [customFieldSection addFormField:textField];
        break;
      }
    }
  }
  
  [self.tableView reloadData];
}

#pragma mark - Form Field Styles

- (IBAFormFieldStyle *)textFormFieldStyle {
  IBAFormFieldStyle *style = [[[IBAFormFieldStyle alloc] init] autorelease];
  
  style.labelTextColor = [UIColor blackColor];
  style.labelFont = [UIFont boldSystemFontOfSize:12.f];
  style.labelTextAlignment = UITextAlignmentRight;
  style.labelFrame = CGRectZero;
  
  style.valueTextAlignment = UITextAlignmentLeft;
  style.valueTextColor = [UIColor colorWithWhite:0.467f alpha:1.f]; // #777
  style.valueFont = [UIFont systemFontOfSize:17.f];
  style.valueFrame = CGRectMake(IBAFormFieldLabelX, 10.f, IBAFormFieldLabelWidth + IBAFormFieldValueWidth + 5.f, IBAFormFieldValueHeight);
  
  style.activeColor = [UIColor whiteColor];
  
	return style;
}

- (IBAFormFieldStyle *)buttonFormFieldStyle {
	IBAFormFieldStyle *style = [[[IBAFormFieldStyle alloc] init] autorelease];
  
  style.labelTextColor = [UIColor colorWithRed:.318 green:.4 blue:.569 alpha:1.];
  style.labelFont = [UIFont boldSystemFontOfSize:20.];
  style.labelFrame = CGRectMake(10., 8., 300., 30.);
  style.labelTextAlignment = UITextAlignmentCenter;
  style.labelAutoresizingMask = UIViewAutoresizingFlexibleWidth;
  
  style.activeColor = [UIColor whiteColor];
  
	return style;
}

@end
