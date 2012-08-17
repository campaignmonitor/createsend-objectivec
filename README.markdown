# CreateSend Objective-C #

<img src="https://github.com/campaignmonitor/createsend-objectivec/raw/master/Example/CreateSendExample/CreateSendExample.png" align="right" width="396px" height="744px" />

CreateSend Objective-C is a library for talking to the Campaign Monitor API from Cocoa & Cocoa Touch applications. It supports Mac OS X 10.5+ & iOS 4.0+.

### Features ###

- Supports all of the available [Campaign Monitor APIs](http://www.campaignmonitor.com/api/).
- Provides a drop-in UI for adding new subscribers to your lists, with custom field support.

### Sample Project ###

A sample project is included in `$SRCROOT/Example/CreateSendExample/CreateSendExample.xcodeproj`. With the help of [IBAForms](https://github.com/ittybittydude/IBAForms/) by the friendly folks at [Itty Bitty Apps](http://www.ittybittyapps.com), `CreateSendExample` demonstrates presenting a form for subscribing to a Campaign Monitor list.

You will need to specify your API key in `CSExampleAppDelegate.m` before building & running `CreateSendExample`.

The provided `CSSubscriptionFormViewController` class can present a simple form with name & email address, or it can display the custom fields configured for the subscription list. Set the `customFieldBehavior` variable in `CSExampleAppDelegate.m` to any of the values specified in `CSExampleAppCustomFieldBehavior` to configure the form in fixed-fields or dynamic-fields mode.

### Basic API Wrapper Usage Examples ###

If you prefer to build your own custom UI, you can simply use the API wrapper directly. For full documentation of the API wrapper, see the class documentation is available in `Documentation/html/index.html` (generated with `rake docs:generate`).

Here's a some examples to get you started.

#### Getting your API key: ####

    CSAPI *API = [[CSAPI alloc] init];
    
    [API getAPIKeyWithSiteURL:@"http://yoursite.createsend.com/" username:@"yourusername" password:@"yourpassword" completionHandler:^(NSString *APIKey) {
        NSLog(@"Your API key is %@", APIKey);
    } errorHandler:^(NSError *error) {
        NSLog(@"Something went wrong: %@", error);
    }];

#### Subscribing to a list: ####

    CSAPI *API = [[CSAPI alloc] initWithAPIKey:@"ab6b0598d32fecd63485b18abb4f0ad7"];
    
    NSArray *customFields = @[
        [CSCustomField customFieldWithKey:@"AddressStreet" value:@"1 Infinite Loop"],
        [CSCustomField customFieldWithKey:@"AddressSuburb" value:@"Cupertino"]
    ];

    [API subscribeToListWithID:@"66f889ae2e1981157285b4f76f2e02ad"
                  emailAddress:@"johnny.appleseed@apple.com"
                          name:@"Johnny Appleseed"
             shouldResubscribe:YES
                  customFields:customFields
             completionHandler:^(NSString *subscribedAddress) {
                NSLog(@"Successfully subscribed %@", subscribedAddress);
             } errorHandler:^(NSError *error) {
                NSLog(@"Something went wrong: %@", error);
             }];

#### Authorizating via OAuth: ####

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        API = [[CSAPI alloc] initWithClientID:@"CLIENT_ID" clientSecret:@"CLIENT_SECRET" scope:@[CSAPIClientScopeManageLists, CSAPIClientScopeImportSubscribers]];
        if (!API.isAuthorized) {
            [API authorize];    
        }
    }

Once authorized, your app will be launched with the URL scheme csapiCLIENT_ID. The easiest way to register for this scheme is right-click on your app's plist file and select Open As → Source Code, and add the following code below the first <dict> tag, substituting CLIENT_ID with your app's client id:

    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>csapiCLIENT_ID</string>
            </array>
        </dict>
    </array>

Now that your app is registered for the correct scheme, you need to add the following code to your application delegate in order to complete the authorization flow:

    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
    {
        if ([API handleOpenURL:url]) {
            if (API.isAuthorized) {
                NSLog(@"App has been authorized successfully!");
                // At this point you can start making API calls
            }
            return YES;
        }
        // Add whatever other url handling code your app requires here
        return NO;
    }
