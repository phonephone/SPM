//
//  LeaveForm.m
//  Mangkud
//
//  Created by Firststep Consulting on 28/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "LeaveForm.h"
#import "Leave.h"
#import "Leave_Left.h"

@interface LeaveForm ()
{
    
}
@end

@implementation LeaveForm

@synthesize mode,action,leaveTopicArray,leaveDetailArray,otHourArray,titleLabel,label1,label2,label3,detailLabel,sumLabel,field1,field2,field3,detailText,sendBtn,cancelBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
    /*
    if ([mode isEqualToString:@"Leave"]||[mode isEqualToString:@"Leave_Ahead"]) {
        self.tabBarController.tabBar.hidden = YES;
        
    }
    else
    {
        self.tabBarController.tabBar.hidden = NO;
    }
    */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"mode %@",mode);
    NSLog(@"leaveTopicArray %@",leaveTopicArray);
    NSLog(@"leaveDetailArray %@",leaveDetailArray);
    
    otHourArray = [[NSMutableArray alloc] init];//[NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    label1.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    label2.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    label3.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    detailLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    sumLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    
    field1.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    field2.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    field3.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    detailText.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    
    [self addbottomBorder:field1 withColor:nil];
    [self addbottomBorder:field2 withColor:nil];
    [self addbottomBorder:field3 withColor:nil];
    
    detailText.delegate = self;
    detailText.layer.borderWidth = 1.0f;
    detailText.layer.borderColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1].CGColor;
    [detailText  setTextContainerInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    sendBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
    sendBtn.backgroundColor = delegate.mainThemeColor;
    sendBtn.layer.cornerRadius = sendBtn.frame.size.height/2;
    sendBtn.layer.masksToBounds = YES;
    
    cancelBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
    cancelBtn.backgroundColor = delegate.cancelThemeColor;
    cancelBtn.layer.cornerRadius = cancelBtn.frame.size.height/2;
    cancelBtn.layer.masksToBounds = YES;
    
    NSLocale *localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:localeTH];
    
    hf = [[NSDateFormatter alloc] init];
    [hf setLocale:localeTH];
    
    localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    
    if ([mode isEqualToString:@"Leave"]) {
        titleLabel.text = @"คำขอลางาน";
        label1.text = @"วันที่เริ่มต้น";
        label2.text = @"วันที่สิ้นสุด";
        label3.text = @"ประเภทการลางาน";
        sumLabel.hidden = YES;
        
        startPicker = [[UIDatePicker alloc]init];
        [startPicker setDatePickerMode:UIDatePickerModeDate];
        //[startPicker setMinimumDate: [NSDate date]];
        [startPicker setLocale:localeTH];
        startPicker.calendar = [localeTH objectForKey:NSLocaleCalendar];
        startPicker.tag = 1;
        [startPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
        
        field1.inputView = startPicker;
        [df setDateFormat:@"dd MMM yyyy"];
        field1.text = [df stringFromDate:[NSDate date]];
        
        endPicker = [[UIDatePicker alloc]init];
        [endPicker setDatePickerMode:UIDatePickerModeDate];
        //[endPicker setMinimumDate: [NSDate date]];
        [endPicker setLocale:localeTH];
        endPicker.calendar = [localeTH objectForKey:NSLocaleCalendar];
        endPicker.tag = 2;
        [endPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
        
        field2.inputView = endPicker;
        [df setDateFormat:@"dd MMM yyyy"];
        field2.text = [df stringFromDate:[NSDate date]];
        
        typePicker = [[UIPickerView alloc]init];
        typePicker.delegate = self;
        typePicker.dataSource = self;
        [typePicker setShowsSelectionIndicator:YES];
        typePicker.tag = 3;
        [typePicker selectRow:0 inComponent:0 animated:YES];
        
        field3.inputView = typePicker;
        field3.text = [[leaveTopicArray objectAtIndex:0] objectForKey:@"leave_detail"];
        leavetypeID = [[leaveTopicArray objectAtIndex:0] objectForKey:@"leave_detail_id"];
        
        field1.userInteractionEnabled = NO;
        field2.userInteractionEnabled = NO;
        field3.userInteractionEnabled = NO;
        detailText.userInteractionEnabled = NO;
        sendBtn.hidden = YES;
        cancelBtn.hidden = YES;
    }
    else if ([mode isEqualToString:@"Leave_Ahead"])
    {
        titleLabel.text = @"คำขอหยุดงานล่วงหน้า";
        label1.text = @"ชื่อผู้ขอ";
        label2.text = @"ตั้งแต่วันที่";
        label3.text = @"ถึงวันที่";
        sumLabel.hidden = YES;
        
        field1.text = delegate.userFullname;
        
        startPicker = [[UIDatePicker alloc]init];
        [startPicker setDatePickerMode:UIDatePickerModeDate];
        [startPicker setMinimumDate: [NSDate date]];
        [startPicker setLocale:localeTH];
        startPicker.calendar = [localeTH objectForKey:NSLocaleCalendar];
        startPicker.tag = 1;
        [startPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
        
        field2.inputView = startPicker;
        [df setDateFormat:@"dd MMM yyyy"];
        field2.text = [df stringFromDate:[NSDate date]];
        field2.tag = 22;
        field2.delegate = self;
        
        endPicker = [[UIDatePicker alloc]init];
        [endPicker setDatePickerMode:UIDatePickerModeDate];
        [endPicker setMinimumDate: [NSDate date]];
        [endPicker setLocale:localeTH];
        endPicker.calendar = [localeTH objectForKey:NSLocaleCalendar];
        endPicker.tag = 2;
        [endPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
        
        field3.inputView = endPicker;
        [df setDateFormat:@"dd MMM yyyy"];
        field3.text = [df stringFromDate:[NSDate date]];
        field3.tag = 33;
        field3.delegate = self;
        
        field1.userInteractionEnabled = NO;
        field2.userInteractionEnabled = YES;
        field3.userInteractionEnabled = YES;
        detailText.userInteractionEnabled = YES;
        sendBtn.hidden = NO;
        cancelBtn.hidden = YES;
    }
    else if ([mode isEqualToString:@"Absence"]) {
        titleLabel.text = @"คำขอหยุดงาน";
        label1.text = @"ชื่อผู้ขอหยุดงาน";
        label2.text = @"วันที่ขอหยุดงาน";
        label3.text = @"เวรที่ขอหยุดงาน";
        sumLabel.hidden = YES;
    }
    else if ([mode isEqualToString:@"OT"])
    {
        titleLabel.text = @"คำขอชั่วโมงสะสม";
        label1.text = @"วันที่ขอชั่วโมงสะสม";
        label2.text = @"เวลาเริ่มต้นชั่วโมงสะสม";
        label3.text = @"เวลาสิ้นสุดชั่วโมงสะสม";
        sumLabel.text = @"";
        sumLabel.hidden = YES;
        
        startPicker = [[UIDatePicker alloc]init];
        [startPicker setDatePickerMode:UIDatePickerModeDate];
        [startPicker setMaximumDate: [NSDate date]];
        [startPicker setLocale:localeTH];
        startPicker.calendar = [localeTH objectForKey:NSLocaleCalendar];
        startPicker.tag = 1;
        [startPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
        startPicker.date = [NSDate date];
        
        field1.inputView = startPicker;
        [df setDateFormat:@"dd MMM yyyy"];
        field1.text = [df stringFromDate:startPicker.date];
        
        endPicker = [[UIDatePicker alloc]init];
        [endPicker setDatePickerMode:UIDatePickerModeTime];
        [endPicker setLocale:localeTH];
        endPicker.calendar = [localeTH objectForKey:NSLocaleCalendar];
        endPicker.tag = 2;
        [endPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
        endPicker.date = [NSDate date];
        
        field2.inputView = endPicker;
        [hf setDateFormat:@"HH:mm"];
        field2.text = [hf stringFromDate:endPicker.date];
        
        typePicker = [[UIPickerView alloc]init];
        typePicker.delegate = self;
        typePicker.dataSource = self;
        [typePicker setShowsSelectionIndicator:YES];
        typePicker.tag = 3;
        [typePicker selectRow:0 inComponent:0 animated:YES];
        
        field3.inputView = typePicker;
        field3.text = @"1.0";
        //[self updateHourCalculator];
        
        sumLabel.textColor = delegate.mainThemeColor2;
    }
    else if ([mode isEqualToString:@"Time"])
    {
        label1.text = @"ชื่อผู้ขอปรับเวลา";
        sumLabel.hidden = YES;
        
        if ([[leaveDetailArray objectForKey:@"clock_type"] isEqualToString:@"1"]) {
            titleLabel.text = @"คำขอปรับเวลาเข้างาน";
            label2.text = @"เวลาเข้างานปกติ";
            label3.text = @"เวลาที่มีการเข้างาน";
        }
        
        else if ([[leaveDetailArray objectForKey:@"clock_type"] isEqualToString:@"2"]) {
            titleLabel.text = @"คำขอปรับเวลาออกงาน";
            label2.text = @"เวลาออกงานปกติ";
            label3.text = @"เวลาที่มีการออกงาน";
        }
    }
    
    if (@available(iOS 13.4, *)) {
        startPicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        endPicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    
    if([action isEqualToString:@"edit"])
    {
        [self editInitial];
    }
}

- (void)editInitial
{
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setLocale:localeEN];
    [df2 setDateFormat:@"yyyy-MM-dd"];
    
    [df setDateFormat:@"dd MMM yyyy"];
    
    field1.userInteractionEnabled = NO;
    field2.userInteractionEnabled = NO;
    field3.userInteractionEnabled = NO;
    
    if ([mode isEqualToString:@"Leave"])
    {
        NSDate *startDate = [df2 dateFromString:[leaveDetailArray objectForKey:@"start_date"]];
        NSDate *endDate = [df2 dateFromString:[leaveDetailArray objectForKey:@"end_date"]];
        field1.text = [df stringFromDate:startDate];
        field2.text = [df stringFromDate:endDate];
        [startPicker setDate:startDate];
        [endPicker setDate:endDate];
        
        for (int i=0; i<3; i++)
        {
            NSMutableDictionary *topicArray = [leaveTopicArray objectAtIndex:i];
            if ([[leaveDetailArray objectForKey:@"leave_detail_id"] isEqualToString:[topicArray objectForKey:@"leave_detail_id"]]) {
                field3.text = [topicArray objectForKey:@"leave_detail"];
                leavetypeID = [leaveDetailArray objectForKey:@"leave_detail_id"];
                [typePicker selectRow:i inComponent:0 animated:YES];
            }
            else{
                
            }
        }
    }
    else if ([mode isEqualToString:@"Leave_Ahead"])
    {
        field1.text = [leaveDetailArray objectForKey:@"user_name"];
        
        NSDate *startDate = [df2 dateFromString:[leaveDetailArray objectForKey:@"start_date"]];
        field2.text = [df stringFromDate:startDate];
        startPicker.date = startDate;
        NSDate *endDate = [df2 dateFromString:[leaveDetailArray objectForKey:@"end_date"]];
        field3.text = [df stringFromDate:endDate];
        endPicker.date = endDate;
    }
    else if ([mode isEqualToString:@"Absence"])
    {
        field1.text = [leaveDetailArray objectForKey:@"user_name"];
        
        NSDate *startDate = [df2 dateFromString:[leaveDetailArray objectForKey:@"shift_date"]];
        field2.text = [df stringFromDate:startDate];
        field3.text = [NSString stringWithFormat:@"%@ - %@ น.",[leaveDetailArray objectForKey:@"on_duty"],[leaveDetailArray objectForKey:@"off_duty"]];
    }
    else if ([mode isEqualToString:@"OT"])
    {
        NSDate *startDate = [df2 dateFromString:[leaveDetailArray objectForKey:@"date"]];
        field1.text = [df stringFromDate:startDate];
        [startPicker setDate:startDate];
        /*
        NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
        [df3 setLocale:localeEN];
        [df3 setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *endDate = [df3 dateFromString:[NSString stringWithFormat:@"%@ %@",[leaveDetailArray objectForKey:@"date"],[leaveDetailArray objectForKey:@"start_time"]]];
        field2.text = [hf stringFromDate:endDate];
        [endPicker setDate:endDate];
        */
        field2.text = [leaveDetailArray objectForKey:@"real_time_start"];
        
        field3.text = [leaveDetailArray objectForKey:@"real_time_end"];
        field3.userInteractionEnabled = NO;
        /*
        field3.text = [NSString stringWithFormat:@"%.2f",[[leaveDetailArray objectForKey:@"time_limit"] floatValue]];
        
        for (float i=0; i<[field3.text floatValue]; i++)
        {
            NSLog(@"i = %f",i);
            if (i==0) {
                
            }
            else{
                [otHourArray addObject:[NSString stringWithFormat:@"%.2f",i+0.3]];
            }
            
            if (i<[field3.text floatValue]&&i+1<=[field3.text floatValue]) {
                [otHourArray addObject:[NSString stringWithFormat:@"%.2f",i+1]];
            }
            else{
                
            }
        }
        [typePicker reloadAllComponents];
        
        for (int i=0; i<[otHourArray count]; i++)
        {
            if ([field3.text floatValue] == [[otHourArray objectAtIndex:i] floatValue]) {
                [typePicker selectRow:i inComponent:0 animated:YES];
            }
        }
        field3.userInteractionEnabled = YES;
        
        [self updateHourCalculator];
         */
    }
    else if ([mode isEqualToString:@"Time"])
    {
        field1.text = [leaveDetailArray objectForKey:@"name"];
        field2.text = [NSString stringWithFormat:@"วันที่ %@ เวลา %@ น.",[delegate appTimeFromDatabase:[leaveDetailArray objectForKey:@"clock_date_duty"]],[leaveDetailArray objectForKey:@"clock_duty"]];
        field3.text = [NSString stringWithFormat:@"วันที่ %@ เวลา %@ น.",[delegate appTimeFromDatabase:[leaveDetailArray objectForKey:@"clock_date"]],[leaveDetailArray objectForKey:@"clock"]];
    }
    
    
    //Status
    if ([[leaveDetailArray objectForKey:@"status_text"] isEqualToString:@"สร้างคำขอ"]) {
        detailText.userInteractionEnabled = YES;
        sendBtn.hidden = NO;
        cancelBtn.hidden = NO;
    }
    else if ([[leaveDetailArray objectForKey:@"status_text"] isEqualToString:@"รอดำเนินการ"]&&[mode isEqualToString:@"Leave_Ahead"]) {
        field2.userInteractionEnabled = YES;
        field3.userInteractionEnabled = YES;
        detailText.userInteractionEnabled = YES;
        [sendBtn setTitle:@"แก้ไขคำขอ" forState:UIControlStateNormal];
        sendBtn.hidden = NO;
        cancelBtn.hidden = NO;
    }
    else{
        field1.userInteractionEnabled = NO;
        field2.userInteractionEnabled = NO;
        field3.userInteractionEnabled = NO;
        detailText.userInteractionEnabled = NO;
        sendBtn.hidden = YES;
        cancelBtn.hidden = YES;
    }
    
    detailText.text = [leaveDetailArray objectForKey:@"reason"];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 22) {
        
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 22) {

    }
    return YES;
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    switch (datePicker.tag) {
        case 1://Start Date
            [df setDateFormat:@"dd MMM yyyy"];
            if ([mode isEqualToString:@"Leave"])
            {
                field1.text = [df stringFromDate:startPicker.date];
                [endPicker setMinimumDate:startPicker.date];
                field2.text = [df stringFromDate:startPicker.date];
                //[df setDateFormat:@"yyyy-MM-dd"];
                //goDate = [df stringFromDate:datePicker.date];
            }
            else if ([mode isEqualToString:@"Leave_Ahead"])
            {
                field2.text = [df stringFromDate:startPicker.date];
                [endPicker setMinimumDate: startPicker.date];
                endPicker.date = startPicker.date;
                field3.inputView = endPicker;
                [df setDateFormat:@"dd MMM yyyy"];
                field3.text = [df stringFromDate:startPicker.date];
            }
            else if ([mode isEqualToString:@"OT"])
            {
                field1.text = [df stringFromDate:startPicker.date];
                endPicker.date = startPicker.date;
                field2.text = [hf stringFromDate:endPicker.date];
                //[self updateHourCalculator];
            }
            break;
            
        case 2://End Date
            if ([mode isEqualToString:@"Leave"])
            {
                field2.text = [df stringFromDate:endPicker.date];
            }
            else if ([mode isEqualToString:@"Leave_Ahead"])
            {
                field3.text = [df stringFromDate:endPicker.date];
            }
            else if ([mode isEqualToString:@"OT"])
            {
                field2.text = [hf stringFromDate:endPicker.date];
                
                //[self updateHourCalculator];
            }
            break;
    }
}

- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    long rowNum = 0;
    
    switch (pickerView.tag)
    {
        case 3://Type , HOUR
            if ([mode isEqualToString:@"Leave"])
            {
                rowNum = [leaveTopicArray count];
            }
            else if ([mode isEqualToString:@"OT"])
            {
                //rowNum = [otHourArray count];
                rowNum = [otHourArray count];
            }
            
            break;
            
        default:
            break;
    }
    return rowNum;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowTitle;
    
    switch (pickerView.tag)
    {
        case 3://Type , HOUR
            if ([mode isEqualToString:@"Leave"])
            {
                rowTitle = [[leaveTopicArray objectAtIndex:row] objectForKey:@"leave_detail"];
            }
            else if ([mode isEqualToString:@"OT"])
            {
                rowTitle = [otHourArray objectAtIndex:row];
            }
            break;
            
        default:
            break;
    }
    return rowTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag)
    {
        case 3://Type , HOUR
            if ([mode isEqualToString:@"Leave"])
            {
                field3.text = [[leaveTopicArray objectAtIndex:row] objectForKey:@"leave_detail"];
                leavetypeID = [[leaveTopicArray objectAtIndex:row] objectForKey:@"leave_detail_id"];
            }
            else if ([mode isEqualToString:@"OT"])
            {
                field3.text = [otHourArray objectAtIndex:row];
                
                //[self updateHourCalculator];
            }
            break;
            
        default:
            break;
    }
}
/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
*/
/*
- (void)updateHourCalculator
{
    NSString *tempHour;
    
    NSArray *items = [field3.text componentsSeparatedByString:@"."];
    NSString *str1=[items objectAtIndex:0];//before decimal
    NSString *str2=[items objectAtIndex:1];//after decimal
    
    if ([str2 isEqualToString:@"30"]) {
        tempHour = [NSString stringWithFormat:@"%@.5",str1];
    }
    else{
        tempHour = field3.text;;
    }
    
    NSDate *incrementedDate = [NSDate dateWithTimeInterval:[tempHour floatValue]*60*60 sinceDate:endPicker.date];
    sumLabel.text = [NSString stringWithFormat:@"สิ้นสุดชั่วโมงสะสมวันที่ %@ เวลา %@",[df stringFromDate:incrementedDate],[hf stringFromDate:incrementedDate]];
}
*/
- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,textField.frame.size.height+6, self.view.frame.size.width*0.9, 1.0f);
    
    if (color == nil) {
        bottomBorder.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1].CGColor;
    }
    else{
        bottomBorder.backgroundColor = color.CGColor;
        //UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, userField.frame.size.width, 20)];
        //textField.rightView = paddingView;
        //textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    [textField.layer addSublayer:bottomBorder];
    
    return textField;
}

- (IBAction)sendClicked:(id)sender
{
    if ([detailText.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"กรุณาระบุเหตุผล" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"OK");
        }];
        [alertController addAction:confirmAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยืนยันส่งคำขอ" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Confirm");
            [self loadSubmit];
        }];
        [alertController addAction:confirmAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Cancel");
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)loadSubmit
{
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setLocale:localeEN];
    [df2 setDateFormat:@"dd-MM-yyyy"];
    
    NSString *endDate;
    if ([mode isEqualToString:@"Leave"])
    {
        endDate = [df2 stringFromDate:endPicker.date];
    }
    else if ([mode isEqualToString:@"Leave_Ahead"])
    {
        [df2 setDateFormat:@"yyyy-MM-dd"];
        endDate = [df2 stringFromDate:endPicker.date];
    }
    else if ([mode isEqualToString:@"OT"])
    {
        endDate = [hf stringFromDate:endPicker.date];
    }
    NSString *startDate = [df2 stringFromDate:startPicker.date];
    
    NSString* url;
    NSString *encodeReason = [detailText.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    if([action isEqualToString:@"add"])
    {
        if ([mode isEqualToString:@"Leave"])
        {
            url = [NSString stringWithFormat:@"%@createLeaveData/%@/%@/%@/%@/%@",delegate.serverURL,delegate.userID,startDate,endDate,leavetypeID,encodeReason];
        }
        else if ([mode isEqualToString:@"Leave_Ahead"])
        {
            url = [NSString stringWithFormat:@"%@createLeaveAheadRequest/%@/%@/%@/%@",delegate.serverURL,delegate.userID,startDate,endDate,encodeReason];
        }
        else if ([mode isEqualToString:@"OT"])
        {
            url = [NSString stringWithFormat:@"%@createOvertimeData/%@/%@/%@/%@/%@",delegate.serverURL,delegate.userID,startDate,endDate,[leaveDetailArray objectForKey:@"time_limit"],encodeReason];
        }
    }
    else if([action isEqualToString:@"edit"])
    {
        if ([mode isEqualToString:@"Leave"])
        {
            url = [NSString stringWithFormat:@"%@updateLeaveData/%@/%@/%@/%@/%@",delegate.serverURL,[leaveDetailArray objectForKey:@"leave_id"],startDate,endDate,leavetypeID,encodeReason];
        }
        else if ([mode isEqualToString:@"Leave_Ahead"])
        {
            url = [NSString stringWithFormat:@"%@leaveAheadModStatus/%@/%@/%@/%@/6",delegate.serverURL,[leaveDetailArray objectForKey:@"la_id"],startDate,endDate,encodeReason];
        }
        else if ([mode isEqualToString:@"Absence"])
        {
            url = [NSString stringWithFormat:@"%@createAbsenceRequest/%@/%@/%@",delegate.serverURL,delegate.userID,[leaveDetailArray objectForKey:@"ab_id"],encodeReason];
        }
        else if ([mode isEqualToString:@"OT"])
        {
            url = [NSString stringWithFormat:@"%@createOvertimeDataNew/%@/%@/%@/%@/%@/%@/1",delegate.serverURL,delegate.userID,startDate,endDate,[leaveDetailArray objectForKey:@"time_limit"],encodeReason,[leaveDetailArray objectForKey:@"ota_id"]];
        }
        else if ([mode isEqualToString:@"Time"])
        {
            url = [NSString stringWithFormat:@"%@createClockInClockOutAdjustTime/%@/%@/%@/%@/%@/%@",delegate.serverURL,delegate.userID,[leaveDetailArray objectForKey:@"clock_id"],[leaveDetailArray objectForKey:@"clock_date"],[leaveDetailArray objectForKey:@"clock_duty"],[leaveDetailArray objectForKey:@"clock_type"],encodeReason];
        }
    }
    //NSLog(@"URL %@",url);
    [SVProgressHUD showWithStatus:@"Loading"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"JSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
             
             if ([mode isEqualToString:@"Leave_Ahead"])
             {
                 Leave_Left* viewController = (Leave_Left*)[self.parentViewController.childViewControllers objectAtIndex:[self.parentViewController.childViewControllers count]-2];
                 [viewController loadList];
             }
             else{
                 Leave* viewController = (Leave*)[self.parentViewController.childViewControllers objectAtIndex:0];
                 [viewController loadList];
             }
             [self.navigationController popViewControllerAnimated:YES];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
             //[self alertTitle:@"Fail" detail:[responseObject objectForKey:@"message"]];
         }
         [SVProgressHUD dismissWithDelay:3];
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
{
         NSLog(@"Error %@",error);
         [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
     }];
}

- (IBAction)deleteClicked:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยืนยันลบคำขอ" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Confirm");
        
        NSString* url;
        if ([mode isEqualToString:@"Leave"])
        {
            
        }
        else if ([mode isEqualToString:@"Leave_Ahead"])
        {
            url = [NSString stringWithFormat:@"%@leaveAheadDeleteData/%@",delegate.serverURL,[leaveDetailArray objectForKey:@"la_id"]];
        }
        else if ([mode isEqualToString:@"Absence"])
        {
            url = [NSString stringWithFormat:@"%@modAbsenceRequestStatus/%@/%@/5",delegate.serverURL,delegate.userID,[leaveDetailArray objectForKey:@"ab_id"]];
        }
        else if ([mode isEqualToString:@"OT"])
        {
            url = [NSString stringWithFormat:@"%@deleteOvertimeAutoData/%@/%@/2",delegate.serverURL,delegate.userID,[leaveDetailArray objectForKey:@"ota_id"]];
        }
        else if ([mode isEqualToString:@"Time"])
        {
            url = [NSString stringWithFormat:@"%@deleteClockInClockOutLateData/%@/%@/%@/%@/%@",delegate.serverURL,delegate.userID,[leaveDetailArray objectForKey:@"clock_id"],[leaveDetailArray objectForKey:@"clock_date"],[leaveDetailArray objectForKey:@"clock_duty"],[leaveDetailArray objectForKey:@"clock_type"]];
        }
        
        [SVProgressHUD showWithStatus:@"Loading"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"deleteJSON %@",responseObject);
             if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
                 [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
                 
                 if ([mode isEqualToString:@"Leave"]||[mode isEqualToString:@"Leave_Ahead"])
                 {
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 else
                 {
                     Leave* viewController = (Leave*)[self.parentViewController.childViewControllers objectAtIndex:0];
                     [viewController loadList];
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             }
             else{
                 [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
                 //[self alertTitle:@"Fail" detail:[responseObject objectForKey:@"message"]];
             }
             [SVProgressHUD dismissWithDelay:3];
         }
              failure:^(NSURLSessionDataTask *task, NSError *error)
     {
             NSLog(@"Error %@",error);
             [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
         }];
    }];
    [alertController addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertTitle:(NSString*)title detail:(NSString*)alertDetail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:alertDetail preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
