//
//  ShiftForm.h
//  PMS
//
//  Created by Firststep Consulting on 24/11/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ShiftForm : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    AppDelegate *delegate;
    
    NSDateFormatter *df;
    NSDateFormatter *df2;
    NSDateFormatter *df3;
    
    UIPickerView *requestDatePicker;
    UIPickerView *responseNamePicker;
    UIPickerView *responseDatePicker;
    
    NSMutableDictionary *shiftJSON;
    NSMutableArray *requestDateJSON;
    NSMutableArray *responseNameJSON;
    NSMutableArray *responseDateJSON;
    
    NSString *requestShiftID;
    NSString *responseID;
    NSString *responseShiftID;
    
    NSString *answerStatus;
    
    BOOL firstRequestDate;
    BOOL firstResponseName;
    BOOL firstResponseDate;
    
    NSString* errMSG;
}
@property (nonatomic) NSString *mode;//swap , accept , approve >>> all = view
@property (nonatomic) NSString *action;//add , view
@property (nonatomic) NSString *shiftID;
@property (nonatomic) BOOL hideBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *requestNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *responseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *responseDateLabel;

@property (weak, nonatomic) IBOutlet UITextField *requestNameField;
@property (weak, nonatomic) IBOutlet UITextField *requestDateField;
@property (weak, nonatomic) IBOutlet UITextField *responseNameField;
@property (weak, nonatomic) IBOutlet UITextField *responseDateField;

@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@end
