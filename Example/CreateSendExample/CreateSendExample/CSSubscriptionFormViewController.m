//
//  CSSubscriptionFormViewController.m
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSSubscriptionFormViewController.h"
#import "CSAPI.h"

#import "CSButtonFormField.h"

@implementation CSSubscriptionFormViewController

@synthesize API=_API;
@synthesize listID=_listID;
@synthesize shouldAutoLoadCustomFields=_shouldAutoLoadCustomFields;
@synthesize customFields=_customFields;

+ (id)controllerWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID {
  return [[[self alloc] initWithAPI:API subscriptionListID:listID] autorelease];
}

- (id)initWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID {
  if ((self = [self init])) {
    self.title = NSLocalizedString(@"Subscribe", nil);
    
    self.API = API;
    self.listID = listID;
    self.shouldAutoLoadCustomFields = NO;
    
    NSMutableDictionary* model = [NSMutableDictionary dictionary];
    self.formDataSource = [[[IBAFormDataSource alloc] initWithModel:model] autorelease];
    
    [self configureRequiredFields];
    [self configureSubscribeButtonField];
  }
  return self;
}

+ (id)controllerWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID customFields:(NSArray *)customFields {
  return [[[self alloc] initWithAPI:API subscriptionListID:listID customFields:customFields] autorelease];
}

- (id)initWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID customFields:(NSArray *)customFields {
  if ((self = [self initWithAPI:API subscriptionListID:listID])) {
    self.customFields = customFields;
    [self configureCustomFields];
  }
  return self;
}

+ (id)controllerWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID shouldAutoLoadCustomFields:(BOOL)shouldAutoLoadCustomFields {
  return [[[self alloc] initWithAPI:API subscriptionListID:listID shouldAutoLoadCustomFields:shouldAutoLoadCustomFields] autorelease];
}

- (id)initWithAPI:(CSAPI *)API subscriptionListID:(NSString *)listID shouldAutoLoadCustomFields:(BOOL)shouldAutoLoadCustomFields {
  if ((self = [self initWithAPI:API subscriptionListID:listID])) {
    self.shouldAutoLoadCustomFields = shouldAutoLoadCustomFields;
    
    if (self.shouldAutoLoadCustomFields) {
      [self loadCustomFields];
    }
  }
  return self;
}

- (IBAButtonFormFieldBlock)subscribeAction {
  return [Block_copy(^{
    
    IBAFormSection* subscribeButtonSection = [self.formDataSource.sections lastObject];
    CSButtonFormField* subscribeButtonField = [subscribeButtonSection.formFields lastObject];
    UIButton* subscribeButton = subscribeButtonField.buttonFormFieldCell.fieldButton;
    
    subscribeButton.enabled = NO;
    
    NSMutableDictionary* formValues = [[(NSDictionary *)self.formDataSource.model mutableCopy] autorelease];
    
    NSString* email = [formValues objectForKey:@"email"];
    NSString* name = [formValues objectForKey:@"name"];
    [formValues removeObjectsForKeys:[NSArray arrayWithObjects:@"email", @"name", nil]];
    
    NSMutableArray* customFields = [NSMutableArray array];
    [formValues enumerateKeysAndObjectsUsingBlock:^(NSString* customFieldKey, id customFieldValue, BOOL *stop) {
      if ([customFieldValue isKindOfClass:[NSSet class]]) {
        NSSet* customFieldOptions = (NSSet *)customFieldValue;
        for (IBAPickListFormOption* customFieldOption in customFieldOptions) {
          [customFields addObject:[CSCustomField customFieldWithKey:customFieldKey value:customFieldOption.name]];
        }
                
      } else {
        [customFields addObject:[CSCustomField customFieldWithKey:customFieldKey value:customFieldValue]];
      }
    }];
    
    [self.API subscribeToListWithID:self.listID
                       emailAddress:email
                               name:name
                  shouldResubscribe:YES
                       customFields:customFields
                  completionHandler:^(NSString *subscribedAddress) {
                    
                    subscribeButton.enabled = YES;
                    
                    [[[[UIAlertView alloc] initWithTitle:@"Success!"
                                                 message:@"You've been subscribed to the list."
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil] autorelease] show];
                    
                  } errorHandler:^(NSError *error) {
                    
                    subscribeButton.enabled = YES;
                    
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
  [_customFields release], _customFields = nil;
  
  [super dealloc];
}

#pragma mark - View Lifecycle

- (void)loadView {
  [super loadView];
  
  self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] autorelease];
  self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
                                     UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin);
  
  [self.view addSubview:self.tableView];
}

# pragma mark - Dynamic Custom Field Fetching

- (void)configureRequiredFields {
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
}

- (void)configureSubscribeButtonField {
  IBAFormSection* subscribeFormSection = [self.formDataSource addSectionWithHeaderTitle:nil footerTitle:nil];
  
  CSButtonFormField* subscribeButtonField = [[[CSButtonFormField alloc] initWithTitle:NSLocalizedString(@"Subscribe", nil)
                                                                                 icon:nil
                                                                       executionBlock:[self subscribeAction]] autorelease];
  
  [subscribeButtonField.buttonFormFieldCell.fieldButton setTitle:NSLocalizedString(@"Subscribing...", nil)
                                                        forState:UIControlStateDisabled];
  
  [subscribeFormSection addFormField:subscribeButtonField];
  
  [self.tableView reloadData];  
}

- (void)configureCustomFields {
  for (CSCustomField* customField in self.customFields) {
    IBAFormSection* customFieldSection = [[[IBAFormSection alloc] initWithHeaderTitle:customField.name footerTitle:nil] autorelease];
    customFieldSection.modelManager = self.formDataSource;
    customFieldSection.formFieldStyle = self.formDataSource.formFieldStyle;
    
    [self.formDataSource.sections insertObject:customFieldSection
                                       atIndex:([self.formDataSource.sections count] - 1)];
    
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

# pragma mark - Custom Field Data Loading

- (void)loadCustomFields {
  [self.API getCustomFieldsWithListID:self.listID
                    completionHandler:^(NSArray* customFields) {
                      
                      self.customFields = customFields;
                      [self configureCustomFields];
                      
                    } errorHandler:^(NSError *error) {
                      [[[[UIAlertView alloc] initWithTitle:@"Uh Oh!"
                                                   message:[NSString stringWithFormat:@"Unable to load custom fields\n\n%@", [error localizedDescription]]
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil] autorelease] show];
                    }];
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

@end
