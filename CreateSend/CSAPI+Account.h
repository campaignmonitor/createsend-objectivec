//
//  CSAPI+Account.h
//  CreateSend
//
//  Copyright (c) 2012 Campaign Monitor. All rights reserved.
//

#import "CSAPI.h"
#import "CSClient.h"
#import "CSAdministrator.h"
#import "CSBillingDetails.h"

/**
 Account-related APIs. See CSAPI for documentation of the other API categories.
 */
@interface CSAPI (Account)

/**
 Allows a client or designer to retrieve their API key, given their username, password, and site URL. 
 
 http://www.campaignmonitor.com/api/account/#getting_your_api_key
 
 @param siteURL The base URL of the CreateSend site. e.g. http://example.createsend.com/.
 @param username The username for the account
 @param password The password for the account
 @param completionHandler Completion callback, with the API Key as the first and only argument
 @param errorHandler Error callback
 */
- (void)getAPIKeyWithSiteURL:(NSString *)siteURL username:(NSString *)username password:(NSString *)password completionHandler:(void (^)(NSString *APIKey))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of all the clients in your account, including their name & ID.
 
 http://www.campaignmonitor.com/api/account/#getting_your_clients
 
 @param completionHandler Completion callback, with an array of `CSClient` objects as the first and only argument
 @param errorHandler Error callback
 */
- (void)getClients:(void (^)(NSArray *clients))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Returns billing details for your account, including the number of credits in your account.
 
 http://www.campaignmonitor.com/api/account/#getting_your_billing_details
 
 @param completionHandler Completion callback, including a `CSBillingDetails` object as the first and only argument
 @param errorHandler Error callback
 */
- (void)getBillingDetails:(void (^)(CSBillingDetails *billingDetails))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of valid countries.
 
 http://www.campaignmonitor.com/api/account/#getting_valid_countries
 
 @param completionHandler Completion callback, including a list of country names as an `NSArray`
 @param errorHandler Error callback
 @see [CSAPI(Clients) createClientWithCompanyName:country:timezone:completionHandler:errorHandler:]
 */
- (void)getCountries:(void (^)(NSArray *countries))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get a list of valid timezones.
 
 http://www.campaignmonitor.com/api/account/#getting_valid_timezones
 
 @param completionHandler Completion callback, including a list of timezone names as an `NSArray`
 @param errorHandler Error callback
 @see [CSAPI(Clients) createClientWithCompanyName:country:timezone:completionHandler:errorHandler:]
 */
- (void)getTimezones:(void (^)(NSArray* timezones))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Get the current time.
 
 http://www.campaignmonitor.com/api/account/#getting_the_current_date
 
 @param completionHandler Completion callback, including the current time as an `NSDate`
 @param errorHandler Error callback
 @see [CSAPI(Clients) createClientWithCompanyName:country:timezone:completionHandler:errorHandler:]
 */
- (void)getSystemDate:(void (^)(NSDate* systemDate))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Adds a new administrator to the account. An invitation will be sent to the new administrator via email
 
 http://www.campaignmonitor.com/api/account/#adding_an_admin
 
 @param name Name of the person
 @param emailAddress Email address of the person
 @param completionHandler Completion callback, with email address of the administrator as the only argument
 @param errorHandler Error callback
 */
- (void)addAdministratorWithName:(NSString *)name
                    emailAddress:(NSString *)emailAddress
               completionHandler:(void (^)(NSString *administratorEmailAddress))completionHandler
                    errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Updates the email address and/or name of an administrator.
 
 http://www.campaignmonitor.com/api/account/#updating_an_admin
 
 @param currentEmailAddress The email address of the admin whose details will be updated. This is regarded as the 'old' email address.
 @param name Name of the administrator
 @param newEmailAddress New email address of the person
 @param completionHandler Completion callback, with email address of the administrator as the only argument
 @param errorHandler Error callback
 */
- (void)updateAdministratorWithEmailAddress:(NSString *)currentEmailAddress
                                       name:(NSString *)name
                            newEmailAddress:(NSString *)newEmailAddress
                          completionHandler:(void (^)(NSString *administratorEmailAddress))completionHandler
                               errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Contains a list of all (active or invited) administrators associated with a particular account.
 
 http://www.campaignmonitor.com/api/account/#getting_account_admins
 
 @param completionHandler Completion callback, with an array of `CSAdministrator` objects as the first and only argument
 @param errorHandler Error callback
 */
- (void)getAdministrators:(void (^)(NSArray *administrators))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Returns the details of a single administrator associated with an account.
 
 http://www.campaignmonitor.com/api/account/#getting_account_admin
 
 @param emailAddress The email address of the administrator whose information should be retrieved.
 @param completionHandler Completion callback, with a `CSAdministrator` as the only argument.
 @param errorHandler Error callback
 */
- (void)getAdministratorWithEmailAddress:(NSString *)emailAddress completionHandler:(void (^)(CSAdministrator *administrator))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Changes the status of an active administrator to a deleted administrator. They will no longer be able to log into this account
 
 http://www.campaignmonitor.com/api/account/#deleting_an_admin
 
 @param emailAddress The email address of the administrator to be deleted.
 @param completionHandler Completion callback
 @param errorHandler Error callback
 */
- (void)deleteAdministratorWithEmailAddress:(NSString *)emailAddress completionHandler:(void (^)(void))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Sets the primary contact for the account to be the administrator with the specified email address.
 
 http://www.campaignmonitor.com/api/account/#setting_primary_contact
 
 @param emailAddress The email address of the administrator to be assigned as the primary contact for the account.
 @param completionHandler Completion callback, with email address of the primary contact as the only argument
 @param errorHandler Error callback
 */
- (void)setPrimaryContactWithEmailAddress:(NSString *)emailAddress completionHandler:(void (^)(NSString *primaryContactEmailAddress))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Returns the email address of the administrator who is selected as the primary contact for this account.
 
 http://www.campaignmonitor.com/api/account/#getting_primary_contact
 
 @param completionHandler Completion callback, with email address of the primary contact as the only argument
 @param errorHandler Error callback
 */
- (void)getPrimaryContact:(void (^)(NSString *primaryContactEmailAddress))completionHandler errorHandler:(CSAPIErrorHandler)errorHandler;

/**
 Returns a URL which initiates a new external session for the user with the given email address.
 
 http://www.campaignmonitor.com/api/account/#single_sign_on
 
 @param email The email address of the Campaign Monitor user for whom the login session should be created.
 @param chrome Which 'chrome' to display - Must be either "all", "tabs", or "none".
 @param url The URL to display once logged in. e.g. "/subscribers/"
 @param integratorID The integrator ID. You need to contact Campaign Monitor support to get an integrator ID.
 @param clientID The Client ID of the client which should be active once logged in to the Campaign Monitor account.

 */
-(void)getExternalSessionUrl:(NSString *)email
                      chrome:(NSString *)chrome
                         url:(NSString *)url
                integratorID:(NSString *)integratorID
                    clientID:(NSString *)clientID
           completionHandler:(void (^)(NSString *sessionUrl))completionHandler
                errorHandler:(CSAPIErrorHandler)errorHandler;

@end
