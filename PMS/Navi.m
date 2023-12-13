//
//  Navi.m
//  PMS
//
//  Created by Truk Karawawattana on 29/1/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import "Navi.h"

@interface Navi ()

@end

@implementation Navi

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController.childViewControllerForStatusBarStyle;
}

-(UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController.childViewControllerForStatusBarStyle;
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
