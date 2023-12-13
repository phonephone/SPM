//
//  UserProfile.h
//  Mangkud
//
//  Created by Firststep Consulting on 28/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserProfile : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    AppDelegate *delegate;
    NSMutableDictionary *profileJSON;
    
    NSDateFormatter *dfEN;
    NSDateFormatter *dfTH;
    UIDatePicker *birthdayPicker;
    UIPickerView *genderPicker;
    UIPickerView *marryPicker;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;
@property (weak, nonatomic) IBOutlet UILabel *deptLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *picLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstnameField;
@property (weak, nonatomic) IBOutlet UILabel *lastnameField;
@property (weak, nonatomic) IBOutlet UILabel *idField;
@property (weak, nonatomic) IBOutlet UILabel *branchField;
@property (weak, nonatomic) IBOutlet UILabel *deptField;
@property (weak, nonatomic) IBOutlet UILabel *positionField;
@property (weak, nonatomic) IBOutlet UILabel *telField;
@property (weak, nonatomic) IBOutlet UILabel *emailField;

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end
