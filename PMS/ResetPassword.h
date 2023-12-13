//
//  ResetPassword.h
//  Mangkud
//
//  Created by Firststep Consulting on 14/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ResetPassword : UIViewController <UITextFieldDelegate>
{
    AppDelegate *delegate;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *oldpassLabel;
@property (weak, nonatomic) IBOutlet UILabel *newpassLabel;
@property (weak, nonatomic) IBOutlet UILabel *repassLabel;

@property (weak, nonatomic) IBOutlet UITextField *oldpassField;
@property (weak, nonatomic) IBOutlet UITextField *newpassField;
@property (weak, nonatomic) IBOutlet UITextField *repassField;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end
