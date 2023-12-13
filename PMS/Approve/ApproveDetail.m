//
//  ApproveDetail.m
//  Mangkud
//
//  Created by Firststep Consulting on 5/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "ApproveDetail.h"
#import "Approve.h"
#import "Web.h"

@interface ApproveDetail ()

@end

@implementation ApproveDetail

@synthesize mode,approveID,hideBtn,approveDetailArray,titleLabel,calendarBtn,upLabel1,upLabel2,upLabel3,upLabel4,upLabel5,downLabel1,downLabel2,downLabel3,downLabel4,downLabel5,downField4,downImage4,approveBtn,cancelBtn,alertLabel,otHourArray;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    delegate.reloadProfile = YES;
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    otHourArray = [[NSMutableArray alloc] init];//[NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    
    NSLog(@"approveDetailArray %@",approveDetailArray);
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    upLabel1.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    upLabel2.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    upLabel3.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    upLabel4.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    upLabel5.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    
    downLabel1.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    downLabel2.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    downLabel3.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    downLabel4.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    downLabel5.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    
    downLabel5.layer.borderWidth = 1.0f;
    downLabel5.layer.borderColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1].CGColor;
    [downLabel5  setTextContainerInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    upLabel5.hidden = YES;
    downLabel5.hidden = YES;
    
    downField4.hidden = YES;
    downImage4.hidden = YES;
    downLabel5.editable = NO;
    
    [self addbottomBorder:downLabel1 withColor:nil];
    [self addbottomBorder:downLabel2 withColor:nil];
    [self addbottomBorder:downLabel3 withColor:nil];
    [self addbottomBorder:downLabel4 withColor:nil];
    
    approveBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    approveBtn.backgroundColor = delegate.mainThemeColor;
    approveBtn.layer.cornerRadius = approveBtn.frame.size.height/2;
    approveBtn.layer.masksToBounds = YES;
    approveBtn.tag = 1;
    [approveBtn setTitle:@"อนุมัติ" forState:UIControlStateNormal];
    
    cancelBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    cancelBtn.backgroundColor = delegate.cancelThemeColor;
    cancelBtn.layer.cornerRadius = approveBtn.frame.size.height/2;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.tag = 2;
    [cancelBtn setTitle:@"ไม่อนุมัติ" forState:UIControlStateNormal];
    
    approveBtn.hidden = hideBtn;
    cancelBtn.hidden = hideBtn;
    
    errMSG = @"";
    
    alertLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    alertLabel.hidden = YES;
    
    localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    
    if (!mode) {
        mode = @"Leave";
    }
    
    if ([mode isEqualToString:@"Leave_Ahead"])
    {
        titleLabel.text = @"รายละเอียดคำขอหยุดงานล่วงหน้า";
        
        upLabel1.text = @"ชื่อผู้ขอ";
        upLabel2.text = @"ตั้งแต่วันที่";
        upLabel3.text = @"ถึงวันที่";
        
        upLabel4.hidden = YES;
        downLabel4.hidden = YES;
        
        upLabel5.text = @"เหตุผล";
        upLabel5.hidden = NO;
        
        downLabel1.text = [approveDetailArray objectForKey:@"user_name"];
        downLabel2.text = [delegate appTimeFromDatabase:[approveDetailArray objectForKey:@"start_date"]];
        downLabel3.text = [delegate appTimeFromDatabase:[approveDetailArray objectForKey:@"end_date"]];
        
        downLabel5.text = [approveDetailArray objectForKey:@"reason"];
        downLabel5.hidden = NO;
        
        //[approveBtn setTitle:@"แก้ไขคำขอ" forState:UIControlStateNormal];
        //[cancelBtn setTitle:@"ลบคำขอ" forState:UIControlStateNormal];
        approveBtn.hidden = YES;
        cancelBtn.hidden = YES;
    }
    else if ([mode isEqualToString:@"Absence"])
    {
        titleLabel.text = @"รายละเอียดคำขอหยุดงาน";
        
        upLabel1.text = @"ชื่อผู้ขอหยุดงาน";
        upLabel2.text = @"วันที่ขอหยุดงาน";
        upLabel3.text = @"เวรที่ขอหยุดงาน";
        
        upLabel4.hidden = YES;
        downLabel4.hidden = YES;
        
        upLabel5.text = @"เหตุผล";
        upLabel5.hidden = NO;
        
        downLabel1.text = [approveDetailArray objectForKey:@"user_name"];
        downLabel2.text = [delegate appTimeFromDatabase:[approveDetailArray objectForKey:@"shift_date"]];
        downLabel3.text = [NSString stringWithFormat:@"%@ - %@",[approveDetailArray objectForKey:@"on_duty"],[approveDetailArray objectForKey:@"off_duty"]];
        
        downLabel5.text = [approveDetailArray objectForKey:@"reason"];
        downLabel5.hidden = NO;
    }
    else if ([mode isEqualToString:@"Time"]) {
        titleLabel.text = @"รายละเอียดคำขอปรับเวลา";
        
        upLabel1.text = @"ชื่อผู้ขอปรับเวลา";
        upLabel4.hidden = YES;
        downLabel4.hidden = YES;
        
        upLabel5.text = @"เหตุผล";
        upLabel5.hidden = NO;
        
        if ([[approveDetailArray objectForKey:@"clock_type"] isEqualToString:@"1"]) {
            titleLabel.text = @"คำขอปรับเวลาเข้างาน";
            upLabel2.text = @"เวลาเข้างานปกติ";
            upLabel3.text = @"เวลาที่มีการเข้างาน";
        }
        
        else if ([[approveDetailArray objectForKey:@"clock_type"] isEqualToString:@"2"]) {
            titleLabel.text = @"คำขอปรับเวลาออกงาน";
            upLabel2.text = @"เวลาออกงานปกติ";
            upLabel3.text = @"เวลาที่มีการออกงาน";
        }
        
        downLabel1.text = [approveDetailArray objectForKey:@"user_name"];
        downLabel2.text = [NSString stringWithFormat:@"วันที่ %@ เวลา %@ น.",[delegate appTimeFromDatabase:[approveDetailArray objectForKey:@"aft_adj_date"]],[approveDetailArray objectForKey:@"aft_adj_time"]];
        downLabel3.text = [NSString stringWithFormat:@"วันที่ %@ เวลา %@ น.",[delegate appTimeFromDatabase:[approveDetailArray objectForKey:@"bef_adj_date"]],[approveDetailArray objectForKey:@"bef_adj_time"]];
        
        downLabel5.text = [approveDetailArray objectForKey:@"reason"];
        downLabel5.hidden = NO;
    }
    else{
        [self loadList];
    }
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url;
    if ([mode isEqualToString:@"Leave"]) {
        url = [NSString stringWithFormat:@"%@getLeaveDetailAuthorize/%@",delegate.serverURL,approveID];
        titleLabel.text = @"รายละเอียดคำขอลางาน";
    }
    else if ([mode isEqualToString:@"OT"])
    {
        url = [NSString stringWithFormat:@"%@getOverTimeDetailAuthorize/%@",delegate.serverURL,approveID];
        titleLabel.text = @"รายละเอียดคำขอชั่วโมงสะสม";
    }
    else if ([mode isEqualToString:@"Swap"])
    {
        url = [NSString stringWithFormat:@"%@switchShiftDetailData/%@",delegate.serverURL,approveID];
        titleLabel.text = @"รายละเอียดคำขอแลกเวร";
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"ApproveJSON %@",responseObject);
         approveJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             
             NSDateFormatter *df = [[NSDateFormatter alloc] init];
             [df setDateFormat:@"yyyy-MM-dd"];
             [df setLocale:localeEN];
             NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
             [df2 setDateFormat:@"dd/MM/yyyy"];
             [df2 setLocale:localeEN];
             NSDate * startDate;
             NSDate * endDate;
             
             if ([mode isEqualToString:@"Leave"]) {
                 upLabel1.text = @"ชื่อผู้ขอ";
                 upLabel2.text = @"วันที่เริ่มต้น";
                 upLabel3.text = @"วันที่สิ้นสุด";
                 upLabel4.text = @"ประเภท";
                 upLabel5.text = @"เหตุผล";
                 upLabel5.hidden = NO;
                 
                 downLabel1.text = [approveJSON objectForKey:@"name"];
                 
                 startDate = [df dateFromString:[approveJSON objectForKey:@"start_date"]];
                 downLabel2.text = [df2 stringFromDate:startDate];
                 
                 endDate = [df dateFromString:[approveJSON objectForKey:@"end_date"]];
                 downLabel3.text = [df2 stringFromDate:endDate];
                 
                 downLabel4.text = [approveJSON objectForKey:@"leaveDetail"];
                 downLabel5.text = [approveJSON objectForKey:@"reason"];
                 downLabel5.hidden = NO;
             }
             else if ([mode isEqualToString:@"OT"])
             {
                 upLabel1.text = @"ชื่อผู้ขอ";
                 upLabel2.text = @"วันที่ขอชั่วโมงสะสม";
                 upLabel3.text = @"เวลาเริ่มต้นชั่วโมงสะสม";
                 upLabel4.text = @"เวลาสิ้นสุดชั่วโมงสะสม";
                 upLabel5.text = @"เหตุผล";
                 upLabel5.hidden = NO;
                 
                 downLabel1.text = [approveJSON objectForKey:@"name"];
                 
                 startDate = [df dateFromString:[approveJSON objectForKey:@"date"]];
                 downLabel2.text = [df2 stringFromDate:startDate];
                 
                 downLabel3.text = [approveJSON objectForKey:@"real_time_start"];
                 downLabel4.text = [approveJSON objectForKey:@"real_time_end"];
                 
                 /*
                 typePicker = [[UIPickerView alloc]init];
                 typePicker.delegate = self;
                 typePicker.dataSource = self;
                 [typePicker setShowsSelectionIndicator:YES];
                 typePicker.tag = 3;
                 [typePicker selectRow:0 inComponent:0 animated:YES];
                 
                 downField4.inputView = typePicker;
                 
                 downLabel4.text = [NSString stringWithFormat:@"%.2f",[[approveJSON objectForKey:@"time_limit"] floatValue]];
                 
                 for (float i=0; i<[downLabel4.text floatValue]; i++)
                 {
                     NSLog(@"i = %f",i);
                     if (i==0) {
                         
                     }
                     else{
                         [otHourArray addObject:[NSString stringWithFormat:@"%.2f",i+0.3]];
                     }
                     
                     if (i<[downLabel4.text floatValue]&&i+1<=[downLabel4.text floatValue]) {
                         [otHourArray addObject:[NSString stringWithFormat:@"%.2f",i+1]];
                     }
                     else{
                         
                     }
                 }
                 [typePicker reloadAllComponents];
                 
                 for (int i=0; i<[otHourArray count]; i++)
                 {
                     if ([downLabel4.text floatValue] == [[otHourArray objectAtIndex:i] floatValue]) {
                         [typePicker selectRow:i inComponent:0 animated:YES];
                     }
                     else{
                         
                     }
                 }
                 downField4.hidden = hideBtn;
                 downImage4.hidden = hideBtn;
                 
                 downLabel4.userInteractionEnabled = !hideBtn;
                 UITapGestureRecognizer *tapGesture =
                 [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)];
                 [downLabel4 addGestureRecognizer:tapGesture];
                 */
                 
                 downLabel5.text = [approveJSON objectForKey:@"reason"];
                 downLabel5.hidden = NO;
                 downLabel5.editable = !hideBtn;
             }
             else if ([mode isEqualToString:@"Swap"])
             {
                 upLabel1.text = @"ผู้ขอแลกเวร";
                 upLabel2.text = @"เวรของผู้ขอแลก";
                 upLabel3.text = @"ผู้เข้าเวรแทน";
                 upLabel4.text = @"เวรของผู้รับแลก";
                 
                 downLabel1.text = [approveJSON objectForKey:@"request_user_name"];
                 downLabel2.text = [approveJSON objectForKey:@"shift_detail_thai"];
                 downLabel3.text = [approveJSON objectForKey:@"response_user_name"];
                 downLabel4.text = [approveJSON objectForKey:@"response_shift_detail_thai"];
                 
                 errMSG = [approveJSON objectForKey:@"workrule"];
                 if ([errMSG isEqualToString:@""]) {
                     alertLabel.hidden = YES;
                     alertLabel.text = @"";
                 }
                 else{
                     alertLabel.hidden = NO;
                     alertLabel.text = [NSString stringWithFormat:@"หมายเหตุ: %@",errMSG];
                 }
             }
             
             [SVProgressHUD dismiss];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
             //[self alertTitle:@"Fail" detail:[responseObject objectForKey:@"message"]];
         }
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
{
         NSLog(@"Error %@",error);
         [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
     }];
}

- (void) labelTap
{
    [downField4 becomeFirstResponder];
}

- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    long rowNum = 0;
    
    if ([mode isEqualToString:@"OT"])
    {
        rowNum = [otHourArray count];
    }
    return rowNum;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowTitle;
    
    rowTitle = [otHourArray objectAtIndex:row];
    
    return rowTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([mode isEqualToString:@"OT"])
    {
        downLabel4.text = [otHourArray objectAtIndex:row];
    }
}

- (UILabel*)addbottomBorder:(UILabel*)label withColor:(UIColor*)color
{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,label.frame.size.height+6, self.view.frame.size.width*0.95, 1.0f);
    
    if (color == nil) {
        bottomBorder.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1].CGColor;
    }
    else{
        bottomBorder.backgroundColor = color.CGColor;
        //UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, userField.frame.size.width, 20)];
        //textField.rightView = paddingView;
        //textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    [label.layer addSublayer:bottomBorder];
    
    return label;
}

- (IBAction)approveClicked:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยืนยันอนุมัติคำขอ" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Confirm");
        if ([mode isEqualToString:@"Swap"])
        {
            NSString *urlString = [NSString stringWithFormat:@"%@switchShiftAnswerProcess/%@/2",delegate.serverURL,approveID];
            [self approveLoad:urlString];
        }
        else if ([mode isEqualToString:@"Leave_Ahead"])
        {
            NSString *encodeReason = [[approveDetailArray objectForKey:@"reason"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            
            NSString *urlString = [NSString stringWithFormat:@"%@leaveAheadModStatus/%@/%@/%@/%@/1",delegate.serverURL,approveID,[approveDetailArray objectForKey:@"start_date"],[approveDetailArray objectForKey:@"end_date"],encodeReason];
            [self approveLoad:urlString];
        }
        else if ([mode isEqualToString:@"Absence"])
        {
            NSString *urlString = [NSString stringWithFormat:@"%@modAbsenceRequestStatus/%@/%@/2",delegate.serverURL,[approveDetailArray objectForKey:@"user_id"],approveID];
            [self approveLoad:urlString];
        }
        else if ([mode isEqualToString:@"OT"])
        {
            NSString *encodeReason = [downLabel5.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            
            NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",[approveJSON objectForKey:@"Approve_link"],[approveJSON objectForKey:@"time_limit"],encodeReason];
            [self approveLoad:urlString];
        }
        else if ([mode isEqualToString:@"Time"])
        {
            NSString *urlString = [NSString stringWithFormat:@"%@adjustClockInClockOutStatus/%@/1",delegate.serverURL,approveID];
            [self approveLoad:urlString];
        }
        else {
            [self approveLoad:[approveJSON objectForKey:@"Approve_link"]];
        }
    }];
    [alertController addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)cancelClicked:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยืนยันไม่อนุมัติคำขอ" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Confirm");
        if ([mode isEqualToString:@"Swap"])
        {
            NSString *urlString = [NSString stringWithFormat:@"%@switchShiftAnswerProcess/%@/3",delegate.serverURL,approveID];
            [self approveLoad:urlString];
        }
        else if ([mode isEqualToString:@"Leave_Ahead"])
        {
            NSString *encodeReason = [[approveDetailArray objectForKey:@"reason"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            
            NSString *urlString = [NSString stringWithFormat:@"%@leaveAheadModStatus/%@/%@/%@/%@/2",delegate.serverURL,approveID,[approveDetailArray objectForKey:@"start_date"],[approveDetailArray objectForKey:@"end_date"],encodeReason];
            [self approveLoad:urlString];
        }
        else if ([mode isEqualToString:@"Absence"])
        {
            NSString *urlString = [NSString stringWithFormat:@"%@modAbsenceRequestStatus/%@/%@/3",delegate.serverURL,[approveDetailArray objectForKey:@"user_id"],approveID];
            [self approveLoad:urlString];
        }
        else if ([mode isEqualToString:@"Time"])
        {
            NSString *urlString = [NSString stringWithFormat:@"%@adjustClockInClockOutStatus/%@/2",delegate.serverURL,approveID];
            [self approveLoad:urlString];
        }
        else {
            [self approveLoad:[approveJSON objectForKey:@"Declined_link"]];
        }
    }];
    [alertController addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)approveLoad:(NSString *)urlString
{
    delegate.reloadProfile = YES;
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = urlString;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"LeaveJSON %@",responseObject);
         approveJSON = responseObject;
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
             
             Approve* viewController = (Approve*)[self backViewController];
             [viewController loadList];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
         }
         [SVProgressHUD dismissWithDelay:3];
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
{
         NSLog(@"Error %@",error);
         [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
     }];
}

- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}

- (IBAction)calendarClick:(id)sender
{
    UIViewController *viewController = [[Web alloc]initWithNibName:@"Web" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
