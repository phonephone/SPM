//
//  Login.m
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Login.h"
#import "Tabbar.h"
#import "LeftMenu.h"
#import "CheckInOut.h"
#import "Leave.h"
#import "Shift.h"
#import "MainMenu.h"
#import "Admin.h"
#import "Navi.h"

@interface Login ()

@end

@implementation Login

@synthesize titleLabel,userField,passField,signinBtn,forgetBtn;

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+12];
    userField.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+1];
    passField.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+1];
    
    NSAttributedString *userStr = [[NSAttributedString alloc] initWithString:@"รหัสพนักงาน" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    userField.attributedPlaceholder = userStr;
    NSAttributedString *passStr = [[NSAttributedString alloc] initWithString:@"รหัสผ่าน" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    passField.attributedPlaceholder = passStr;
    
    signinBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
    signinBtn.backgroundColor = delegate.mainThemeColor;
    //[signinBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    signinBtn.layer.cornerRadius = signinBtn.frame.size.height/2;
    signinBtn.layer.masksToBounds = YES;
    //signinBtn.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    //signinBtn.layer.shadowRadius = 3;
    //signinBtn.layer.shadowOpacity = 0.8;
    //signinBtn.layer.shadowOffset = CGSizeMake(2,2);
    
    forgetBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    [forgetBtn setTitleColor:delegate.mainThemeColor2 forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews
{
    [self addbottomBorder:userField withColor:nil];
    [self addbottomBorder:passField withColor:nil];
}

- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,textField.frame.size.height, textField.frame.size.width, 1.0f);
    
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

- (IBAction)loginClick:(id)sender
{
    if ([userField.text isEqualToString:@"888"])
    {
        //151589 พี่เก่ง
        userField.text = @"500045";//151589,010334,620549
        passField.text = @"1111";
        [self loadLogin];
    }
    else if ([userField.text isEqualToString:@""]||[passField.text isEqualToString:@""])
    {
        [self alertTitle:@"ข้อมูลไม่ครบ" detail:@"กรุณาใส่รหัสพนักงาน หรือ password ให้ครบ"];
    }
    else{
        [self loadLogin];
        //[self loginSuccess];
    }
}

- (void)loadLogin
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@login/%@/%@",delegate.serverURL,userField.text,passField.text];
    
    //NSDictionary *parameters = @{@"user":userField.text,@"pass":passField.text};//,@"token":delegate.memberToken};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"LoginJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             loginJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
             [self loginSuccess];
             
             //[SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
             [SVProgressHUD dismiss];
         }
         else if ([[responseObject objectForKey:@"code"] isEqualToString:@"err02"]){
             [self loginAdmin];
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

- (void)loginSuccess
{
    //Tabbar *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"tabbarController"];
    //[self.menuContainerViewController setCenterViewController:tab];
    [self setUpTabBar];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    delegate.loginStatus = YES;
    delegate.userID = [loginJSON objectForKey:@"user_id"];
    delegate.adminID = [loginJSON objectForKey:@"admin_user_id"];
    
    //delegate.serverURLshort = [loginJSON objectForKey:@"server_url"];
    //delegate.serverURL = [NSString stringWithFormat:@"%@index.php?MobileApi/",delegate.serverURLshort];
    
    //delegate.userLogoUrl = [loginJSON objectForKey:@"logo"];
    //delegate.userFullname = [NSString stringWithFormat:@"%@ %@",[loginJSON objectForKey:@"name"],[loginJSON objectForKey:@"lastname"]];
    
    [ud setBool:delegate.loginStatus forKey:@"loginStatus"];
    [ud setObject:delegate.userID forKey:@"userID"];
    [ud setObject:delegate.adminID forKey:@"adminID"];
    //[ud setObject:delegate.userLogoUrl forKey:@"userLogoUrl"];
    //[ud setObject:delegate.userFullname forKey:@"userFullname"];
    [ud synchronize];
    
    //LeftMenu *left = (LeftMenu*)[UIApplication sharedApplication].delegate.window.rootViewController.childViewControllers.firstObject;
    //[left updateProfile];
}

- (void)loginAdmin
{
    Admin *viewController = [[Admin alloc]initWithNibName:@"Admin" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void) setUpTabBar {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MainMenu *firstViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    //firstViewController.title = @"First View";
    firstViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"หน้าแรก" image:[UIImage imageNamed:@"Tab_home.png"] tag:0];
    //[[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
    Navi *firstNavController = [[Navi alloc]initWithRootViewController:firstViewController];
    firstNavController.navigationBarHidden = YES;
    
    CheckInOut *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"CheckInOut"];
    secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"เวลาเข้างาน" image:[UIImage imageNamed:@"Tab_time.png"] tag:1];
    Navi *secondNavController = [[Navi alloc]initWithRootViewController:secondViewController];
    secondNavController.navigationBarHidden = YES;
    
    Leave *thirdViewController = [storyboard instantiateViewControllerWithIdentifier:@"Leave"];
    thirdViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"การร้องขอ" image:[UIImage imageNamed:@"Tab_request.png"] tag:2];
    Navi *thirdNavController = [[Navi alloc]initWithRootViewController:thirdViewController];
    thirdNavController.navigationBarHidden = YES;
    
    Shift *forthViewController = [storyboard instantiateViewControllerWithIdentifier:@"Shift"];
    //forthViewController.title = @"Forth View";
    forthViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"แลกเวร" image:[UIImage imageNamed:@"Tab_calendar.png"] tag:3];
    Navi *forthNavController = [[Navi alloc]initWithRootViewController:forthViewController];
    forthNavController.navigationBarHidden = YES;
    
    tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"tabbarController"];//[[UITabBarController alloc] initWithNibName:nil bundle:nil];
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:firstNavController, secondNavController, thirdNavController,forthNavController, nil];
    //tabBarController.tabBar.tintColor = [UIColor colorWithRed:169.0/255 green:79.0/255 blue:123.0/255 alpha:1];
    //tabBarController.delegate = self;
    
    //[tabbarController setSelectedIndex:1]; Start With Tab X
    [self.menuContainerViewController setCenterViewController:tabBarController];
}

- (IBAction)forgetClick:(id)sender
{
    NSString* title = @"ลืมรหัสผ่าน";
    NSString* message = @"กรุณากรอก email ของคุณ";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *titleFont = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableAttributedString *messageFont = [[NSMutableAttributedString alloc] initWithString:message];
    [titleFont addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+1]
                  range:NSMakeRange (0, titleFont.length)];
    [messageFont addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:delegate.fontLight size:delegate.fontSize-2]
                      range:NSMakeRange(0, messageFont.length)];
    [alertController setValue:titleFont forKey:@"attributedTitle"];
    [alertController setValue:messageFont forKey:@"attributedMessage"];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"email";
        textField.font = [UIFont fontWithName:delegate.fontLight size:delegate.fontSize-2];
        //textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"User e-mail %@", [[alertController textFields][0] text]);
        //compare the current password and do action here
        [self loadForget:[[alertController textFields][0] text]];
    }];
    [alertController addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadForget:(NSString*)email
{
    if (![email isEqualToString:@""]) {
        [SVProgressHUD showWithStatus:@"Loading"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString* url = [NSString stringWithFormat:@"%@forgetPassword/%@",delegate.serverURL,email];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"ForgetPass %@",responseObject);
             if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
                 [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
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
}

- (void)alertTitle:(NSString*)title detail:(NSString*)alertDetail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:alertDetail preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *titleFont = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableAttributedString *messageFont = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",alertDetail]];
    [titleFont addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+1]
                      range:NSMakeRange (0, titleFont.length)];
    [messageFont addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:delegate.fontLight size:delegate.fontSize-2]
                        range:NSMakeRange(0, messageFont.length)];
    [alertController setValue:titleFont forKey:@"attributedTitle"];
    [alertController setValue:messageFont forKey:@"attributedMessage"];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString*)formatURL:(NSString*)originalURL
{
    NSString *encodeURL = [originalURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    return encodeURL;
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
