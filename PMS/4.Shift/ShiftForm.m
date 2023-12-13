//
//  ShiftForm.m
//  PMS
//
//  Created by Firststep Consulting on 24/11/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "ShiftForm.h"
#import "Shift.h"
#import "LeftMenu.h"

@interface ShiftForm ()

@end

@implementation ShiftForm

@synthesize mode,action,shiftID,hideBtn,titleLabel,requestNameLabel,requestNameField,requestDateLabel,requestDateField,responseNameLabel,responseNameField,responseDateLabel,responseDateField,acceptBtn,cancelBtn,alertLabel;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"mode %@",mode);
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    requestNameLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    requestDateLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    responseNameLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    responseDateLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    
    requestNameField.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    requestDateField.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    responseNameField.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    responseDateField.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    
    [self addbottomBorder:requestNameField withColor:nil];
    [self addbottomBorder:requestDateField withColor:nil];
    [self addbottomBorder:responseNameField withColor:nil];
    [self addbottomBorder:responseDateField withColor:nil];
    
    acceptBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    acceptBtn.backgroundColor = delegate.mainThemeColor;
    acceptBtn.layer.cornerRadius = acceptBtn.frame.size.height/2;
    acceptBtn.layer.masksToBounds = YES;
    acceptBtn.tag = 1;
    
    cancelBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    cancelBtn.backgroundColor = delegate.cancelThemeColor;
    cancelBtn.layer.cornerRadius = acceptBtn.frame.size.height/2;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.tag = 2;
    
    alertLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    alertLabel.hidden = YES;
    
    errMSG = @"";
    
    NSLocale *localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:localeTH];
    [df setDateFormat:@"dd MMMM yyyy"];
    
    NSLocale *localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    df2 = [[NSDateFormatter alloc] init];
    [df2 setLocale:localeEN];
    [df2 setDateFormat:@"yyyy-MM-dd"];
    
    df3 = [[NSDateFormatter alloc] init];
    [df3 setLocale:localeEN];
    [df3 setDateFormat:@"dd/MM/yyyy"];
    
    requestNameLabel.text = @"ชื่อผู้ขอแลกเวร";
    requestDateLabel.text = @"เวรที่ต้องแลก";
    responseNameLabel.text = @"ชื่อผู้รับแลกเวร";
    responseDateLabel.text = @"เวรของผู้รับแลก";
    
    
    requestNameField.userInteractionEnabled = NO;
    
    if ([action isEqualToString:@"add"]) {
        titleLabel.text = @"สร้างคำขอแลกเวร";
        
        requestNameField.text = delegate.userFullname;
        
        requestDatePicker = [[UIPickerView alloc]init];
        requestDatePicker.delegate = self;
        requestDatePicker.dataSource = self;
        [requestDatePicker setShowsSelectionIndicator:YES];
        requestDatePicker.tag = 22;
        [requestDatePicker selectRow:0 inComponent:0 animated:YES];
        
        requestDateField.inputView = requestDatePicker;
        requestDateField.text = @"";
        requestDateField.placeholder = @"เลือกเวรที่ต้องการแลก";
        requestDateField.tag = 222;
        
        
        responseNamePicker = [[UIPickerView alloc]init];
        responseNamePicker.delegate = self;
        responseNamePicker.dataSource = self;
        [responseNamePicker setShowsSelectionIndicator:YES];
        responseNamePicker.tag = 33;
        [responseNamePicker selectRow:0 inComponent:0 animated:YES];
        
        responseNameField.inputView = responseNamePicker;
        responseNameField.text = @"";
        responseNameField.placeholder = @"เลือกชื่อผู้รับแลกเวร";
        responseNameField.tag = 333;
        
        
        responseDatePicker = [[UIPickerView alloc]init];
        responseDatePicker.delegate = self;
        responseDatePicker.dataSource = self;
        [responseDatePicker setShowsSelectionIndicator:YES];
        responseDatePicker.tag = 44;
        [responseDatePicker selectRow:0 inComponent:0 animated:YES];
        
        responseDateField.inputView = responseDatePicker;
        responseDateField.text = @"";
        responseDateField.placeholder = @"เลือกเวรของผู้รับแลก";
        responseDateField.tag = 444;
        
        [acceptBtn setTitle:@"ส่งคำขอแลกเวร" forState:UIControlStateNormal];
        
        responseNameLabel.hidden = YES;
        responseNameField.hidden = YES;
        responseDateLabel.hidden = YES;
        responseDateField.hidden = YES;
        acceptBtn.hidden = YES;
        cancelBtn.hidden = YES;
        
        [self loadShift:@"requestDate"];
    }
    else// action = "view"
    {
        requestDateField.userInteractionEnabled = NO;
        responseNameField.userInteractionEnabled = NO;
        responseDateField.userInteractionEnabled = NO;
        
        if([mode isEqualToString:@"Swap"])
        {
            titleLabel.text = @"รายละเอียดการขอแลกเวร";
            [cancelBtn setTitle:@"ยกเลิกคำขอแลกเวร" forState:UIControlStateNormal];
            acceptBtn.hidden = YES;
            cancelBtn.hidden = hideBtn;
        }
        else if ([mode isEqualToString:@"Accept"])
        {
            titleLabel.text = @"ตอบรับการขอแลกเวร";
            [acceptBtn setTitle:@"ยืนยันการแลกเวร" forState:UIControlStateNormal];
            [cancelBtn setTitle:@"ยกเลิกการแลกเวร" forState:UIControlStateNormal];
            acceptBtn.hidden = hideBtn;
            cancelBtn.hidden = hideBtn;
        }
        [self viewDetail];
    }
}

- (void)viewDetail
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString* url = [NSString stringWithFormat:@"%@switchShiftDetailData/%@",delegate.serverURL,shiftID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"shiftJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             shiftJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
             
             requestNameField.text = [shiftJSON objectForKey:@"request_user_name"];
             
             requestDateField.text = [shiftJSON objectForKey:@"shift_detail_thai"];
             
             responseNameField.text = [shiftJSON objectForKey:@"response_user_name"];
             
             responseDateField.text = [shiftJSON objectForKey:@"response_shift_detail_thai"];
             
             errMSG = [shiftJSON objectForKey:@"workrule"];
             if ([errMSG isEqualToString:@""]) {
                 alertLabel.hidden = YES;
                 alertLabel.text = @"";
             }
             else{
                 alertLabel.hidden = NO;
                 alertLabel.text = [NSString stringWithFormat:@"หมายเหตุ: %@",errMSG];
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

- (void)loadShift:(NSString*)type
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString* url;
    
    if ([type isEqualToString:@"requestDate"]) {
        url = [NSString stringWithFormat:@"%@switchShiftListForCreateRequest/%@",delegate.serverURL,delegate.userID];
    }
    else if ([type isEqualToString:@"responseName"])
    {
        url = [NSString stringWithFormat:@"%@responseSwitchShiftUserList/%@",delegate.serverURL,delegate.userID];
    }
    else if ([type isEqualToString:@"responseDate"])
    {
        url = [NSString stringWithFormat:@"%@switchShiftListForCreateResponse/%@/%@",delegate.serverURL,delegate.userID,responseID];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"%@ pickerJSON %@",type,responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             
             if ([type isEqualToString:@"requestDate"]) {
                 requestDateJSON = [responseObject objectForKey:@"data"];
                 [requestDatePicker reloadAllComponents];
                 [requestDatePicker selectRow:0 inComponent:0 animated:YES];
                 firstRequestDate = YES;
             }
             else if ([type isEqualToString:@"responseName"])
             {
                 responseNameJSON = [responseObject objectForKey:@"data"];
                 [responseNamePicker reloadAllComponents];
                 [responseNamePicker selectRow:0 inComponent:0 animated:YES];
                 responseNameField.text = @"";
                 responseNameLabel.hidden = NO;
                 responseNameField.hidden = NO;
                 firstResponseName = YES;
             }
             else if ([type isEqualToString:@"responseDate"])
             {
                 responseDateJSON = [responseObject objectForKey:@"data"];
                 [responseDatePicker reloadAllComponents];
                 [responseDatePicker selectRow:0 inComponent:0 animated:YES];
                 responseDateField.text = @"";
                 responseDateLabel.hidden = NO;
                 responseDateField.hidden = NO;
                 firstResponseDate = YES;
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 222) {//reqestDate
        if (firstRequestDate == YES) {
            firstRequestDate = NO;
            textField.text = [[requestDateJSON objectAtIndex:0] objectForKey:@"shift_detail_thai"];
            requestShiftID = [[requestDateJSON objectAtIndex:0] objectForKey:@"shift_employee_id"];
        }
        responseNameLabel.hidden = YES;
        responseNameField.hidden = YES;
        responseDateLabel.hidden = YES;
        responseDateField.hidden = YES;
        acceptBtn.hidden = YES;
        cancelBtn.hidden = YES;
        alertLabel.hidden = YES;
    }
    
    if (textField.tag == 333) {//responseName
        if (firstResponseName == YES) {
            firstResponseName = NO;
            textField.text = [NSString stringWithFormat:@"%@ %@",[[responseNameJSON objectAtIndex:0] objectForKey:@"name"],[[responseNameJSON objectAtIndex:0] objectForKey:@"last_name"]];
            responseID = [[responseNameJSON objectAtIndex:0] objectForKey:@"user_id"];
        }
        responseDateLabel.hidden = YES;
        responseDateField.hidden = YES;
        acceptBtn.hidden = YES;
        cancelBtn.hidden = YES;
        alertLabel.hidden = YES;
    }
    
    if (textField.tag == 444) {//responseDate
        if (firstResponseDate == YES) {
            firstResponseDate = NO;
            textField.text = [[responseDateJSON objectAtIndex:0] objectForKey:@"shift_detail_thai"];
            responseShiftID = [[responseDateJSON objectAtIndex:0] objectForKey:@"shift_employee_id"];
        }
        acceptBtn.hidden = YES;
        cancelBtn.hidden = YES;
        alertLabel.hidden = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 222) {
        if ([textField.text isEqualToString:@""]) {}
        else
        {
            [self loadShift:@"responseName"];
        }
    }
    if (textField.tag == 333) {
        if ([textField.text isEqualToString:@""]) {}
        else
        {
            [self loadShift:@"responseDate"];
        }
    }
    if (textField.tag == 444) {
        if ([textField.text isEqualToString:@""]) {}
        else
        {
            acceptBtn.hidden = NO;
            
            NSString* url = [NSString stringWithFormat:@"%@chkWorkRuleBefCreateSwitchShiftRequest/%@/%@/%@/%@",delegate.serverURL,delegate.userID,requestShiftID,responseID,responseShiftID];
            //NSString* url = [NSString stringWithFormat:@"%@chkWorkRuleBefCreateSwitchShiftRequest/90/10444/3/10478",delegate.serverURL];
            //IDเรา + ShiftID เรา + IDคนอื่น + ShiftID คนอื่น
            //NSLog(@"URL %@",url);
            
            [SVProgressHUD showWithStatus:@"Loading"];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
             {
                 NSLog(@"WorkRuleJSON %@",responseObject);
                 if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
                     
                     errMSG = [[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"errorMsg"];
                     if ([errMSG isEqualToString:@""]) {
                         alertLabel.hidden = YES;
                         alertLabel.text = @"";
                     }
                     else{
                         alertLabel.hidden = NO;
                         alertLabel.text = [NSString stringWithFormat:@"หมายเหตุ: %@",errMSG];
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"แจ้งเตือน" message:errMSG preferredStyle:UIAlertControllerStyleAlert];
                         
                         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                             NSLog(@"Cancel");
                         }];
                         [alertController addAction:cancelAction];
                         [self presentViewController:alertController animated:YES completion:nil];
                     }
                     [SVProgressHUD dismiss];
                 }
                 else{
                     [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
                     //[self alertTitle:@"Fail" detail:[responseObject objectForKey:@"message"]];
                     [SVProgressHUD dismissWithDelay:3];
                 }
             }
                  failure:^(NSURLSessionDataTask *task, NSError *error)
         {
                 NSLog(@"Error %@",error);
                 [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
             }];
        }
    }
    return YES;
}

- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    long rowNum = 0;
    
    switch (pickerView.tag)
    {
        case 22://Request Date
            rowNum = [requestDateJSON count];
            break;
            
        case 33://Response Name
            rowNum = [responseNameJSON count];
            break;
            
        case 44://Response Date
            rowNum = [responseDateJSON count];
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
        case 22://Request Date
            rowTitle = [[requestDateJSON objectAtIndex:row] objectForKey:@"shift_detail_thai"];
            break;
            
        case 33://Response Name
            rowTitle = [NSString stringWithFormat:@"%@ %@",[[responseNameJSON objectAtIndex:row] objectForKey:@"name"],[[responseNameJSON objectAtIndex:row] objectForKey:@"last_name"]];
            break;
            
        case 44://Response Date
            rowTitle = [[responseDateJSON objectAtIndex:row] objectForKey:@"shift_detail_thai"];
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
        case 22://Request Date
            requestDateField.text = [[requestDateJSON objectAtIndex:row] objectForKey:@"shift_detail_thai"];
            requestShiftID = [[requestDateJSON objectAtIndex:row] objectForKey:@"shift_employee_id"];
            break;
            
        case 33://Response Name
            responseNameField.text = [NSString stringWithFormat:@"%@ %@",[[responseNameJSON objectAtIndex:row] objectForKey:@"name"],[[responseNameJSON objectAtIndex:row] objectForKey:@"last_name"]];
            responseID = [[responseNameJSON objectAtIndex:row] objectForKey:@"user_id"];
            break;
            
        case 44://Response Date
            responseDateField.text = [[responseDateJSON objectAtIndex:row] objectForKey:@"shift_detail_thai"];
            responseShiftID = [[responseDateJSON objectAtIndex:row] objectForKey:@"shift_employee_id"];
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
- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,textField.frame.size.height+6, self.view.frame.size.width*0.95, 1.0f);
    
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

- (IBAction)actionClicked:(id)sender
{
    NSLog(@"XXX %@\n%@\n%@\n%@",delegate.userID,requestShiftID,responseID,responseShiftID);
    UIButton *button = (UIButton *)sender;
    
    NSString* url;
    NSString* alertTitle;
    
    if([action isEqualToString:@"add"])
    {
        NSString *encodeWarning = [errMSG stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        url = [NSString stringWithFormat:@"%@createSwitchShiftRequest/%@/%@/%@/%@/%@",delegate.serverURL,delegate.userID,requestShiftID,responseID,responseShiftID,encodeWarning];
        
        //url = [NSString stringWithFormat:@"%@createSwitchShiftRequest/90/10444/3/10478/%@",delegate.serverURL,encodeWarning];
        
        //IDเรา + ShiftID เรา + IDคนอื่น + ShiftID คนอื่น
        alertTitle = @"ยืนยันส่งคำขอ";
    }
    else //Accept
    {
        if (button.tag == 1) {//0 = รอการตอบรับ, 1 = รอการอนุมัติ, 2 = อนุมัติ, 3 = ไม่อนุมัติ, 4 = ไม่ตอบรับ
            answerStatus = @"1";//ยอมรับ >>> รออนุมัติต่อ
            alertTitle = @"ยืนยันยอมรับคำขอ";
        }
        else if (button.tag == 2){
            answerStatus = @"4";//ไม่ตอบรับ
            alertTitle = @"ยืนยันไม่ยอมรับคำขอ";
        }
        url = [NSString stringWithFormat:@"%@switchShiftAnswerProcess/%@/%@",delegate.serverURL,shiftID,answerStatus];
    }
    //NSLog(@"URL %@",url);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Confirm");
        
        [SVProgressHUD showWithStatus:@"Loading"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"JSON %@",responseObject);
             if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
                 [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
                 
                 Shift* viewController = (Shift*)[self.parentViewController.childViewControllers objectAtIndex:0];
                 [viewController loadList:[NSDate date]];
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
