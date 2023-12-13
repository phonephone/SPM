//
//  LeaveForm.h
//  Mangkud
//
//  Created by Firststep Consulting on 28/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LeaveForm : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    AppDelegate *delegate;
    
    NSDateFormatter *df;
    NSDateFormatter *hf;
    UIDatePicker *startPicker;
    UIDatePicker *endPicker;
    UIPickerView *typePicker;
    
    NSString *leavetypeID;
    
    NSLocale *localeEN;
}
@property (nonatomic) NSString *mode;
@property (nonatomic) NSString *action;
@property (nonatomic) NSMutableArray *leaveTopicArray;
@property (nonatomic) NSDictionary *leaveDetailArray;
@property (nonatomic) NSMutableArray *otHourArray;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *sumLabel;

@property (weak, nonatomic) IBOutlet UITextField *field1;
@property (weak, nonatomic) IBOutlet UITextField *field2;
@property (weak, nonatomic) IBOutlet UITextField *field3;
@property (weak, nonatomic) IBOutlet UITextView *detailText;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@end
