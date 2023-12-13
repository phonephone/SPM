//
//  Login.h
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Login : UIViewController <UITextFieldDelegate>
{
    AppDelegate *delegate;
    NSMutableDictionary *loginJSON;
    
    UITabBarController *tabBarController;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UIButton *signinBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

- (void)loginSuccess;
@end
