//
//  AdminChatWeb.h
//  Mangkud
//
//  Created by Firststep Consulting on 29/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <WebKit/WebKit.h>

@interface AdminChatWeb : UIViewController <WKNavigationDelegate>
{
    AppDelegate *delegate;
    
    NSURLRequest *requestURL;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet WKWebView *myWebView;
@end
