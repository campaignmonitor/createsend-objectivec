//
//  CSAuthorizationViewController.m
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import "CSAuthorizationViewController.h"

@interface CSAuthorizationViewController () <UIWebViewDelegate>
@property (strong) CSAPI *API;
@property (strong) UIWebView *webView;
@end

@interface CSAuthorizationViewController (Private)
- (void)loadRequest;
- (void)openURL:(NSURL *)url;
@end

@implementation CSAuthorizationViewController

- (id)initWithAPI:(CSAPI *)API
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _API = API;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Campaign Monitor";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    webView.delegate = self;
    self.webView = webView;
    [self.view addSubview:self.webView];
    
    [self loadRequest];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (IBAction)cancelAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CSAPIDidCancelAuthorizationNotification object:self.API];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *appScheme = self.API.appScheme;
    if ([[[request URL] scheme] isEqual:appScheme]) {
        [self openURL:[request URL]];
        return NO;
    }
    return YES;
}
@end

@implementation CSAuthorizationViewController (Private)
- (void)loadRequest
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.API.authorizationURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:20];
    [self.webView loadRequest:request];
}

- (void)openURL:(NSURL *)url
{
    UIApplication *app = [UIApplication sharedApplication];
    id<UIApplicationDelegate> delegate = app.delegate;
    
    if ([delegate respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)]) {
        [delegate application:app openURL:url sourceApplication:@"com.campaignmonitor.CreateSend" annotation:nil];
    } else if ([delegate respondsToSelector:@selector(application:handleOpenURL:)]) {
        [delegate application:app handleOpenURL:url];
    }
}
@end
