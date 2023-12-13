//
//  Personal_3.h
//  PMS
//
//  Created by Truk Karawawattana on 14/2/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface Personal_3 : UIViewController <UITextFieldDelegate>
{
    AppDelegate *delegate;
    NSMutableDictionary *profileJSON;
}

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *surnameL;
@property (weak, nonatomic) IBOutlet UILabel *idL;
@property (weak, nonatomic) IBOutlet UILabel *birthdayL;
@property (weak, nonatomic) IBOutlet UILabel *branchL;
@property (weak, nonatomic) IBOutlet UILabel *departmentL;
@property (weak, nonatomic) IBOutlet UILabel *positionL;
@property (weak, nonatomic) IBOutlet UILabel *telL;
@property (weak, nonatomic) IBOutlet UILabel *emailL;

@property (weak, nonatomic) IBOutlet UITextField *nameR;
@property (weak, nonatomic) IBOutlet UITextField *surnameR;
@property (weak, nonatomic) IBOutlet UITextField *idR;
@property (weak, nonatomic) IBOutlet UITextField *birthdayR;
@property (weak, nonatomic) IBOutlet UITextField *branchR;
@property (weak, nonatomic) IBOutlet UITextField *departmentR;
@property (weak, nonatomic) IBOutlet UITextField *positionR;
@property (weak, nonatomic) IBOutlet UITextField *telR;
@property (weak, nonatomic) IBOutlet UITextField *emailR;

@end

NS_ASSUME_NONNULL_END
