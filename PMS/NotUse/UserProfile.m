//
//  UserProfile.m
//  Mangkud
//
//  Created by Firststep Consulting on 28/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "UserProfile.h"
#import "UIImageView+WebCache.h"
#import "UserAddress.h"

@interface UserProfile ()
{
    NSArray *genderArray;
    NSArray *marryArray;
}
@end

@implementation UserProfile

@synthesize titleLabel,firstnameLabel,lastnameLabel,idLabel,branchLabel,deptLabel,positionLabel,telLabel,emailLabel,picLabel,firstnameField,lastnameField,idField,branchField,deptField,positionField,telField,emailField,profilePic,cameraBtn,submitBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self loadProfile];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    genderArray = @[@"ชาย",@"หญิง"];
    marryArray = @[@"โสด",@"สมรส",@"หย่าร้าง"];//074271666 ขวัญนภา
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    NSString *fontName = delegate.fontBold;
    float fontSize = delegate.fontSize;
    firstnameLabel.font = [UIFont fontWithName:fontName size:fontSize];
    lastnameLabel.font = [UIFont fontWithName:fontName size:fontSize];
    idLabel.font = [UIFont fontWithName:fontName size:fontSize];
    branchLabel.font = [UIFont fontWithName:fontName size:fontSize];
    deptLabel.font = [UIFont fontWithName:fontName size:fontSize];
    positionLabel.font = [UIFont fontWithName:fontName size:fontSize];
    telLabel.font = [UIFont fontWithName:fontName size:fontSize];
    emailLabel.font = [UIFont fontWithName:fontName size:fontSize];
    picLabel.font = [UIFont fontWithName:fontName size:fontSize];
    
    NSString *fontName2 = delegate.fontRegular;
    firstnameField.font = [UIFont fontWithName:fontName2 size:fontSize];
    lastnameField.font = [UIFont fontWithName:fontName2 size:fontSize];
    idField.font = [UIFont fontWithName:fontName2 size:fontSize];
    branchField.font = [UIFont fontWithName:fontName2 size:fontSize];
    deptField.font = [UIFont fontWithName:fontName2 size:fontSize];
    positionField.font = [UIFont fontWithName:fontName2 size:fontSize];
    telField.font = [UIFont fontWithName:fontName2 size:fontSize];
    emailField.font = [UIFont fontWithName:fontName2 size:fontSize];
    
    submitBtn.titleLabel.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize+3];
    [submitBtn setTitleColor:delegate.mainThemeColor forState:UIControlStateNormal];
    /*
    [self addbottomBorder:firstnameField withColor:nil];
    [self addbottomBorder:lastnameField withColor:nil];
    [self addbottomBorder:idField withColor:nil];
    [self addbottomBorder:deptField withColor:nil];
    [self addbottomBorder:positionField withColor:nil];
    [self addbottomBorder:telField withColor:nil];
    */
    firstnameField.userInteractionEnabled = NO;
    lastnameField.userInteractionEnabled = NO;
    idField.userInteractionEnabled = NO;
    branchField.userInteractionEnabled = NO;
    deptField.userInteractionEnabled = NO;
    positionField.userInteractionEnabled = NO;
    telField.userInteractionEnabled = NO;
    emailField.userInteractionEnabled = NO;
    
    NSLocale *localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    dfTH = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [dfTH setLocale:localeTH];
    [dfTH setDateFormat:@"EEEE, dd MMM yyyy"];
    
    NSLocale *localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    dfEN = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [dfEN setLocale:localeEN];
    [dfEN setDateFormat:@"yyyy-MM-dd"];
    /*
    birthdayPicker = [[UIDatePicker alloc]init];
    [birthdayPicker setDatePickerMode:UIDatePickerModeDate];
    [birthdayPicker setMaximumDate: [NSDate date]];
    [birthdayPicker setLocale:localeTH];
    birthdayPicker.calendar = [localeTH objectForKey:NSLocaleCalendar];
    birthdayPicker.tag = 1;
    [birthdayPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    birthdayField.inputView = birthdayPicker;
    birthdayField.text = [dfTH stringFromDate:[NSDate date]];
    
    genderPicker = [[UIPickerView alloc]init];
    genderPicker.delegate = self;
    genderPicker.dataSource = self;
    [genderPicker setShowsSelectionIndicator:YES];
    genderPicker.tag = 2;
    [genderPicker selectRow:0 inComponent:0 animated:YES];
    
    genderField.inputView = genderPicker;
    genderField.text = [genderArray objectAtIndex:0];
    
    marryPicker = [[UIPickerView alloc]init];
    marryPicker.delegate = self;
    marryPicker.dataSource = self;
    [marryPicker setShowsSelectionIndicator:YES];
    marryPicker.tag = 3;
    [marryPicker selectRow:0 inComponent:0 animated:YES];
    
    marryField.inputView = marryPicker;
    marryField.text = [marryArray objectAtIndex:0];
    */
    submitBtn.hidden = YES;
}

- (void)viewDidLayoutSubviews
{
    //Border
    profilePic.layer.borderWidth = 1.5f;
    profilePic.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)loadProfile
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@empProfileDetail/%@",delegate.serverURL,delegate.userID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"ProfileJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             profileJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
             firstnameField.text = [profileJSON objectForKey:@"name"];
             lastnameField.text = [profileJSON objectForKey:@"lastname"];
             idField.text = [profileJSON objectForKey:@"ac_no"];
             branchField.text = [profileJSON objectForKey:@"department_branch"];
             deptField.text = [profileJSON objectForKey:@"department_name"];
             positionField.text = [profileJSON objectForKey:@"designation_name"];
             telField.text = [profileJSON objectForKey:@"phone"];
             emailField.text = [profileJSON objectForKey:@"email"];
             
             /*
             genderField.text = [profileJSON objectForKey:@"gender"];
             if ([genderField.text isEqualToString:@"male"]) {
                 genderField.text = @"ชาย";
                 [genderPicker selectRow:0 inComponent:0 animated:YES];
             }
             else if ([genderField.text isEqualToString:@"female"])
             {
                 genderField.text = @"หญิง";
                 [genderPicker selectRow:1 inComponent:0 animated:YES];
             }
             */
             
             
             /*
             marryField.text = [profileJSON objectForKey:@"martial_status"];
             if ([marryField.text isEqualToString:@"unmarried"]) {
                 marryField.text = @"โสด";
                 [marryPicker selectRow:0 inComponent:0 animated:YES];
             }
             else if ([marryField.text isEqualToString:@"married"])
             {
                 marryField.text = @"สมรส";
                 [marryPicker selectRow:1 inComponent:0 animated:YES];
             }
             else
             {
                 marryField.text = @"หย่าร้าง";
                 [marryPicker selectRow:2 inComponent:0 animated:YES];
             }
             */
             
             [profilePic sd_setImageWithURL:[NSURL URLWithString:[profileJSON objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"logo_square.png"]];
             
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Start");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"End");
    //submitBtn.hidden = NO;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
/*
- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    switch (datePicker.tag) {
        case 1://Birthday
            birthdayField.text = [dfTH stringFromDate:birthdayPicker.date];
            
            //[df setDateFormat:@"yyyy-MM-dd"];
            //goDate = [df stringFromDate:datePicker.date];
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
        case 2://Gender
            rowNum = [genderArray count];
            break;
            
        case 3://Marry
            rowNum = [marryArray count];
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
        case 2://Gender
            rowTitle = [genderArray objectAtIndex:row];
            break;
            
        case 3://Marry
            rowTitle = [marryArray objectAtIndex:row];
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
        case 2://Gender
            genderField.text = [genderArray objectAtIndex:row];
 
            break;
            
        case 3://Marry
            marryField.text = [marryArray objectAtIndex:row];
            break;
            
        default:
            break;
    }
}
*/
- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,textField.frame.size.height*1.1, textField.frame.size.width, 1.0f);
    
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
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

- (IBAction)cameraClick:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController  alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self selectImage:nil];
        
        //[self dismissViewControllerAnimated:YES completion:^{ }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
        [self takePhoto:nil];
        
        //[self dismissViewControllerAnimated:YES completion:^{ }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void) selectImage:(UIButton *) sender {
    NSLog(@"selectImage");
    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
    pickerViewController.allowsEditing = YES;
    pickerViewController.delegate = self;
    [pickerViewController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:pickerViewController animated:YES completion:nil];
}

- (void) takePhoto:(UIButton *) sender {
    NSLog(@"takePhoto");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pickerViewController =[[UIImagePickerController alloc]init];
        pickerViewController.allowsEditing = YES;
        pickerViewController.delegate = self;
        pickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerViewController animated:YES completion:nil];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Camera is not available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [profilePic setImage:image];
    [self dismissViewControllerAnimated:picker completion:nil];
}

- (IBAction)editLocal:(id)sender
{
    UserAddress *viewController = [[UserAddress alloc]initWithNibName:@"UserAddress" bundle:nil];
    viewController.mode = @"Local";
    viewController.addressNo = [profileJSON objectForKey:@"local_address"];
    viewController.addressTumbol = [profileJSON objectForKey:@"local_memberTumbon"];
    viewController.addressAmphor = [profileJSON objectForKey:@"local_memberAmphor"];
    viewController.addressCity = [profileJSON objectForKey:@"local_memberCity"];
    viewController.addressPostal = [profileJSON objectForKey:@"local_memberPostCode"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)editPermanent:(id)sender
{
    UserAddress *viewController = [[UserAddress alloc]initWithNibName:@"UserAddress" bundle:nil];
    viewController.mode = @"Permanent";
    viewController.addressNo = [profileJSON objectForKey:@"address_permanent"];
    viewController.addressTumbol = [profileJSON objectForKey:@"memberTumbon_permanent"];
    viewController.addressAmphor = [profileJSON objectForKey:@"memberAmphor_permanent"];
    viewController.addressCity = [profileJSON objectForKey:@"memberCity_permanent"];
    viewController.addressPostal = [profileJSON objectForKey:@"memberPostCode_permanent"];
    [self.navigationController pushViewController:viewController animated:YES];
}
/*
- (IBAction)submitClick:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    NSString *name = [firstnameField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *surname = [lastnameField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *birthday = [dfEN stringFromDate:birthdayPicker.date];
    
    NSString *gender;
    if ([genderField.text isEqualToString:@"ชาย"]) {
        gender = @"male";
    }
    else if ([genderField.text isEqualToString:@"หญิง"])
    {
        gender = @"female";
    }
    
    NSString *tel = [telField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *nationality = [nationalityField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *marital;
    if ([marryField.text isEqualToString:@"โสด"]) {
        marital = @"unmarried";
    }
    else if ([marryField.text isEqualToString:@"สมรส"])
    {
        marital = @"married";
    }
    else
    {
        marital = @"divorce";
    }
 
    NSString *gcID = idField.text;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@UpdateUserDetail/%@/%@/%@/%@/%@/%@/%@/%@/%@",delegate.serverURL,delegate.userID,name,surname,birthday,gender,tel,nationality,marital,gcID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"ProfileJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
             submitBtn.hidden = YES;
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
*/
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
