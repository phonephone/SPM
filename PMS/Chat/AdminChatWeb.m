//
//  AdminChatWeb.m
//  Mangkud
//
//  Created by Firststep Consulting on 29/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "AdminChatWeb.h"
#import "IQKeyboardManager.h"

@interface AdminChatWeb ()

@end

@implementation AdminChatWeb

@synthesize titleLabel,myWebView;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    //[[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?login/chatbox/%@",delegate.serverURLshort,delegate.userID];
    NSURL *url = [NSURL URLWithString:urlString];
    
    myWebView.navigationDelegate = self;
    myWebView.scrollView.bounces = NO;
    requestURL = [[NSURLRequest alloc] initWithURL:url];
    //[self.webView setAllowsInlineMediaPlayback:YES];
    //self.webView.mediaPlaybackRequiresUserAction = NO;
    [myWebView loadRequest:requestURL];
    
    [SVProgressHUD showWithStatus:@"Loading"];
    //https://github.com/SVProgressHUD/SVProgressHUD
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

#pragma mark - WKWebViewDelegate

//shouldStartLoadWithRequest
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //navigationAction.navigationType
    //navigationAction.request
    NSLog(@"Did start loading: %@", [navigationAction.request.URL absoluteString]);
    /*
     NSString *url = [navigationAction.request.URL absoluteString];
     url = [url stringByRemovingPercentEncoding:NSUTF8StringEncoding];
     
     if ([url rangeOfString:@"xxxx://"].location != NSNotFound) {
     // custom fundation
     decisionHandler(WKNavigationActionPolicyCancel);
     return; // the same as to use if...else
     }
     */
    decisionHandler(WKNavigationActionPolicyAllow);

}

//webViewDidFinishLoad
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
}

//didFailLoadWithError
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"!DidFailLoadWithError: %@", [error description]);
    //self.view.alpha = 1.f;
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
}

//webViewDidStartLoad
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [SVProgressHUD showWithStatus:@"Loading"];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
