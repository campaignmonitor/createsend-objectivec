# CreateSend Objective-C #

CreateSend Objective-C is a library for talking to the Campaign Monitor API from Cocoa & Cocoa Touch applications. It supports Mac OS X 10.5+ & iOS 4.0+.

## Features ##

- Supports all of the available [Campaign Monitor APIs](http://www.campaignmonitor.com/api/).
- Provides a drop-in UI for adding new subscribers to your lists, with custom field support.

## Sample Project ##

A sample project is included in `$SRCROOT/Example/CreateSendExample/CreateSendExample.xcodeproj`. With the help of [IBAForms](https://github.com/ittybittydude/IBAForms/) by the friendly folks at [Itty Bitty Apps](http://www.ittybittyapps.com), `CreateSendExample` demonstrates presenting a form for subscribing to a Campaign Monitor list.

You will need to specify your own site URL and API key in `CSExampleAppDelegate.m` before building & running `CreateSendExample`.

The provided `CSSubscriptionFormViewController` class can present a simple form with name & email address, or it can display the custom fields configured for the subscription list. Set the `customFieldBehavior` variable in `CSExampleAppDelegate.m` to any of the values specified in `CSExampleAppCustomFieldBehavior` to configure the form in fixed-fields or dynamic-fields mode.

## Basic API Wrapper Usage Examples ##

If you prefer to build your own custom UI, you can simply use the API wrapper directly. For full documentation of the API wrapper, see the class documentation is available in `Documentation/html/index.html` (generated with `rake docs:generate`).

Here's a couple of examples to get you started.

### Getting your API key: ###

    CSAPI* API = [[[CSAPI alloc] initWithSiteURL:@"http://yoursite.createsend.com/"
                                        username:@"yourusername"
                                        password:@"yourpassword"] autorelease];
    
    [API getAPIKey:^(NSString* APIKey){
      NSLog(@"Your API key is %@", APIKey);
      
    } errorHandler:^(NSError* error) {
      NSLog(@"Something went wrong: %@", error);
      
    }];

### Subscribing to a list: ###

    CSAPI* API = [[[CSAPI alloc] initWithSiteURL:@"http://yoursite.createsend.com/"
                                          APIKey:@"ab6b0598d32fecd63485b18abb4f0ad7"] autorelease];
    
    NSArray* customFields = [NSArray arrayWithObjects:
                             [CSCustomField dictionaryWithValue:@"1 Infinite Loop"
                                                    forFieldKey:@"[AddressStreet]"],
                             [CSCustomField dictionaryWithValue:@"Cupertino"
                                                    forFieldKey:@"[AddressSuburb]"], nil];

    [API subscribeToListWithID:@"66f889ae2e1981157285b4f76f2e02ad"
                  emailAddress:@"johnny.appleseed@apple.com"
                          name:@"Johnny Appleseed"
             shouldResubscribe:YES
             customFieldValues:customFields
             completionHandler:^(NSString* subscribedAddress) {
               NSLog(@"Successfully subscribed %@", subscribedAddress);
               
             } errorHandler:^(NSError* error){
               NSLog(@"Something went wrong: %@", error);
               
             }];
