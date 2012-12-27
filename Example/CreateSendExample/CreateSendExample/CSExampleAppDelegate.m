//
//  CSExampleAppDelegate.m
//  CreateSendExample
//
//  Copyright (c) 2012 Campaign Monitor All rights reserved.
//

#import "CSExampleAppDelegate.h"
#import "CSAPI.h"

#import "CSSubscriptionFormViewController.h"

typedef enum _CSExampleAppCustomFieldBehavior {
  CSExampleAppCustomFieldBehaviorNone,
  CSExampleAppCustomFieldBehaviorStatic,
  CSExampleAppCustomFieldBehaviorDynamic
} CSExampleAppCustomFieldBehavior;

@implementation CSExampleAppDelegate

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];

  self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  [self.window makeKeyAndVisible];
  
  // NOTE: This fetches the first subscription list from the first client in
  //       your account, and presents a subscription form for that list.

  // Replace with your API key
  CSAPI* API = [[[CSAPI alloc] initWithAPIKey:@"..."] autorelease];
  
  [API getClients:^(NSArray *clients) {
    
    CSClient* client = [clients objectAtIndex:0];
    [API getSubscriberListsWithClientID:client.clientID
                      completionHandler:^(NSArray *subscriberLists) {
                        
                        CSList *list = [subscriberLists objectAtIndex:0];
                        NSString *listID = list.listID;
                        
                        CSSubscriptionFormViewController* subscriptionform;
                        
                        // Note: Change this value to choose between the various subscription form custom field behaviors
                        CSExampleAppCustomFieldBehavior customFieldBehavior = CSExampleAppCustomFieldBehaviorStatic;
                        
                        if (customFieldBehavior == CSExampleAppCustomFieldBehaviorNone) {
                          subscriptionform = [CSSubscriptionFormViewController controllerWithAPI:API
                                                                              subscriptionListID:listID];
                          
                        } else if (customFieldBehavior == CSExampleAppCustomFieldBehaviorStatic) {
                          NSArray* customFields = [NSArray arrayWithObjects:
                                                   [CSCustomField customFieldWithName:@"Text field with custom label"
                                                                                  key:@"[Text]"
                                                                             dataType:CSCustomFieldTextDataType
                                                                              options:nil],
                                                   
                                                   [CSCustomField customFieldWithName:@"Date field with custom label"
                                                                                  key:@"[Date]"
                                                                             dataType:CSCustomFieldDateDataType
                                                                              options:nil], nil];
                          
                          subscriptionform = [CSSubscriptionFormViewController controllerWithAPI:API
                                                                              subscriptionListID:listID
                                                                                    customFields:customFields];
                          
                        } else if (customFieldBehavior == CSExampleAppCustomFieldBehaviorDynamic) {
                          subscriptionform = [CSSubscriptionFormViewController controllerWithAPI:API
                                                                              subscriptionListID:listID
                                                                      shouldAutoLoadCustomFields:YES];
                        }
                        
                        self.window.rootViewController = [[[UINavigationController alloc] initWithRootViewController:subscriptionform] autorelease];
                        
                      } errorHandler:^(NSError *error) {
                        NSLog(@"Failed to get subscriber lists. Error: %@", [error localizedDescription]);
                      }];
    
  } errorHandler:^(NSError* error){
    NSLog(@"Failed to get clients. Error: %@", [error localizedDescription]);
  }];
  
  return YES;
}

- (void)dealloc {
  [_window release];
  [super dealloc];
}

@end
