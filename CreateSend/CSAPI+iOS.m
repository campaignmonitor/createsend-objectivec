//
//  CSAPI+iOS.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSAPI+iOS.h"
#import "CSAuthorizationViewController.h"

@implementation CSAPI (iOS)
- (void)authorizeFromViewController:(UIViewController *)controller
{
    if (![self appConformsToScheme]) {
        NSLog(@"CSAPI: Unable to authorize; app isn't registered for correct URL scheme (%@)", self.appScheme);
        return;
    }
    
    CSAuthorizationViewController *authorizationViewController = [[CSAuthorizationViewController alloc] initWithAPI:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:authorizationViewController];
    [controller presentViewController:navigationController animated:YES completion:nil];
}
@end
