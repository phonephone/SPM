//
//  UserBank.h
//  Mangkud
//
//  Created by Firststep Consulting on 14/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserBank : UIViewController <UITextFieldDelegate>
{
    AppDelegate *delegate;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel1;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel2;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel3;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel4;

@property (weak, nonatomic) IBOutlet UITextField *addressField1;
@property (weak, nonatomic) IBOutlet UITextField *addressField2;
@property (weak, nonatomic) IBOutlet UITextField *addressField3;
@property (weak, nonatomic) IBOutlet UITextField *addressField4;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
