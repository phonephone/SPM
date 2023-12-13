//
//  Tabbar.m
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Tabbar.h"

@interface Tabbar ()

@end

@implementation Tabbar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:delegate.fontMedium size:delegate.fontSize-4], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBar appearance] setTintColor:delegate.mainThemeColor];
    //[[UITabBar appearance] setAlpha:0.25];
    
    CGFloat kBarHeight = 200;

    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = kBarHeight;
    tabFrame.origin.y = self.view.frame.size.height - kBarHeight;
    self.tabBar.frame = tabFrame;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    //also you may add any fancy condition-based code here
    return UIStatusBarStyleLightContent;
}

-(UIViewController *)childViewControllerForStatusBarStyle {
    return self.selectedViewController.childViewControllerForStatusBarStyle;
}

-(UIViewController *)childViewControllerForStatusBarHidden {
    return self.selectedViewController.childViewControllerForStatusBarStyle;
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
