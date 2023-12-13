//
//  ResetPassword.m
//  Mangkud
//
//  Created by Firststep Consulting on 14/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "ResetPassword.h"

@interface ResetPassword ()

@end

@implementation ResetPassword
@synthesize titleLabel,oldpassLabel,newpassLabel,repassLabel,oldpassField,newpassField,repassField,submitBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    NSString *fontName = delegate.fontRegular;
    float fontSize = delegate.fontSize+1;
    oldpassLabel.font = [UIFont fontWithName:fontName size:fontSize];
    newpassLabel.font = [UIFont fontWithName:fontName size:fontSize];
    repassLabel.font = [UIFont fontWithName:fontName size:fontSize];
    
    oldpassField.font = [UIFont fontWithName:fontName size:fontSize];
    newpassField.font = [UIFont fontWithName:fontName size:fontSize];
    repassField.font = [UIFont fontWithName:fontName size:fontSize];
    
    submitBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
    submitBtn.backgroundColor = delegate.mainThemeColor;
    submitBtn.layer.cornerRadius = submitBtn.frame.size.height/2;
    submitBtn.layer.masksToBounds = YES;
    
    [self addbottomBorder:oldpassField withColor:nil];
    [self addbottomBorder:newpassField withColor:nil];
    [self addbottomBorder:repassField withColor:nil];
}

- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,textField.frame.size.height*0.9, textField.frame.size.width, 1.0f);
    
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

- (IBAction)submitClick:(id)sender
{
    if ([oldpassField.text isEqualToString:@""]||[newpassField.text isEqualToString:@""]||[repassField.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"กรุณากรอกข้อมูลให้ครบทุกช่อง"];
        [SVProgressHUD dismissWithDelay:3.0];
    }
    else if (![newpassField.text isEqualToString:repassField.text]) {
        [SVProgressHUD showErrorWithStatus:@"รหัสผ่านใหม่และยืนยันรหัสผ่านไม่ตรงกัน กรุณาพิมใหม่อีกครั้ง"];
        [SVProgressHUD dismissWithDelay:3.0];
    }
    else{
        [self loadResult];
    }
}

- (void)loadResult
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString* url = [NSString stringWithFormat:@"%@resetPassword/%@/%@/%@",delegate.serverURL,delegate.userID,oldpassField.text,newpassField.text];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"Change Password %@",responseObject);
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
