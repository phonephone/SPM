//
//  ApproveDetail.h
//  Mangkud
//
//  Created by Firststep Consulting on 5/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ApproveDetail : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    AppDelegate *delegate;
    NSMutableDictionary *approveJSON;
    
    NSString* errMSG;
    NSLocale *localeEN;
    
    UIPickerView *typePicker;
}
@property (nonatomic) NSString *mode;
@property (nonatomic) NSString *approveID;
@property (nonatomic) BOOL hideBtn;
@property (nonatomic) NSDictionary *approveDetailArray;
@property (nonatomic) NSMutableArray *otHourArray;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *calendarBtn;

@property (weak, nonatomic) IBOutlet UILabel *upLabel1;
@property (weak, nonatomic) IBOutlet UILabel *upLabel2;
@property (weak, nonatomic) IBOutlet UILabel *upLabel3;
@property (weak, nonatomic) IBOutlet UILabel *upLabel4;
@property (weak, nonatomic) IBOutlet UILabel *upLabel5;

@property (weak, nonatomic) IBOutlet UILabel *downLabel1;
@property (weak, nonatomic) IBOutlet UILabel *downLabel2;
@property (weak, nonatomic) IBOutlet UILabel *downLabel3;
@property (weak, nonatomic) IBOutlet UILabel *downLabel4;

@property (weak, nonatomic) IBOutlet UITextField *downField4;
@property (weak, nonatomic) IBOutlet UIImageView *downImage4;

//@property (weak, nonatomic) IBOutlet UILabel *downLabel5;
@property (weak, nonatomic) IBOutlet UITextView *downLabel5;

@property (weak, nonatomic) IBOutlet UIButton *approveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@end
