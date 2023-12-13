//
//  Web.m
//  PMS
//
//  Created by Firststep Consulting on 30/12/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Web.h"

@interface Web ()

@end

@implementation Web

@synthesize menuID,urlStr,titleStr,titleLabel,myWebView;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    titleLabel.text = titleStr;
    
    if ([menuID isEqualToString:@"1"]) {//We Dashboard
        [self loadDashboardClearNoti];
    }
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSLocale *localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    [dateFormatter setLocale:localeEN];
    [dateFormatter setDateFormat:@"MM-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"%@",urlStr);

    myWebView.navigationDelegate = self;
    //[self.webView setAllowsInlineMediaPlayback:YES];
    //self.webView.mediaPlaybackRequiresUserAction = NO;
    
    request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 300;
    [myWebView loadRequest:request];
    
    [SVProgressHUD showWithStatus:@"Loading"];
    //https://github.com/SVProgressHUD/SVProgressHUD
}

- (void)loadDashboardClearNoti
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@update_dashboard_noti_on_app/%@",delegate.serverURL,delegate.userID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"DashBoardJSON %@",responseObject);
         
     }
         failure:^(NSURLSessionDataTask *task, NSError *error)
{
         NSLog(@"Error %@",error);
         [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
     }];
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
    [SVProgressHUD dismiss];
    //[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
}

//webViewDidStartLoad
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    //[SVProgressHUD showWithStatus:@"Loading"];
}

- (IBAction)back:(id)sender
{
    /*
    if ([myWebView canGoBack]) {
        [myWebView goBack];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
     */
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
