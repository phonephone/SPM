//
//  Web.h
//  PMS
//
//  Created by Firststep Consulting on 30/12/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <WebKit/WebKit.h>

@interface Web : UIViewController <WKNavigationDelegate>
{
    AppDelegate *delegate;
    
    NSMutableURLRequest *request;
}
@property (nonatomic) NSString *menuID;
@property (nonatomic) NSString *urlStr;
@property (nonatomic) NSString *titleStr;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet WKWebView *myWebView;
@end
