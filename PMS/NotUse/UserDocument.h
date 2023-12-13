//
//  UserDocument.h
//  Mangkud
//
//  Created by Firststep Consulting on 14/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserDocument : UIViewController <UITextFieldDelegate>
{
    AppDelegate *delegate;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *resumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerLetterLabel;
@property (weak, nonatomic) IBOutlet UILabel *joiningLetterLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn1;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn2;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn3;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn4;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn5;

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
