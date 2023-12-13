//
//  Personal_2.h
//  PMS
//
//  Created by Truk Karawawattana on 14/2/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface Personal_2 : UIViewController <UITextFieldDelegate>
{
    AppDelegate *delegate;
    NSMutableDictionary *profileJSON;
}

@property(weak, nonatomic) IBOutlet UIImageView *profilePic;
@property(weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telL;
@property (weak, nonatomic) IBOutlet UILabel *emailL;
@property (weak, nonatomic) IBOutlet UILabel *emailprivateL;
@property(weak, nonatomic) IBOutlet UIImageView *lineL;
@property(weak, nonatomic) IBOutlet UIImageView *fbL;
@property(weak, nonatomic) IBOutlet UIImageView *igL;
@property(weak, nonatomic) IBOutlet UIImageView *linkL;

@property (weak, nonatomic) IBOutlet UITextField *telR;
@property (weak, nonatomic) IBOutlet UITextField *emailR;
@property (weak, nonatomic) IBOutlet UITextField *emailprivateR;
@property (weak, nonatomic) IBOutlet UITextField *lineR;
@property (weak, nonatomic) IBOutlet UITextField *fbR;
@property (weak, nonatomic) IBOutlet UITextField *igR;
@property (weak, nonatomic) IBOutlet UITextField *linkR;

@property(weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

NS_ASSUME_NONNULL_END
