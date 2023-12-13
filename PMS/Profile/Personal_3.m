//
//  Personal_3.m
//  PMS
//
//  Created by Truk Karawawattana on 14/2/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import "Personal_3.h"

@interface Personal_3 ()

@end

@implementation Personal_3

@synthesize nameL,surnameL,idL,birthdayL,branchL,departmentL,positionL,telL,emailL,nameR,surnameR,idR,birthdayR,branchR,departmentR,positionR,telR,emailR;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    float fontSize = delegate.fontSize;
    nameL.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    surnameL.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    idL.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    birthdayL.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    branchL.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    departmentL.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    positionL.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    telL.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    emailL.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    
    nameR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    surnameR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    idR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    birthdayR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    branchR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    departmentR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    positionR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    telR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    emailR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    
    [self addbottomBorder:nameR withColor:nil];
    [self addbottomBorder:surnameR withColor:nil];
    [self addbottomBorder:idR withColor:nil];
    [self addbottomBorder:birthdayR withColor:nil];
    [self addbottomBorder:branchR withColor:nil];
    [self addbottomBorder:departmentR withColor:nil];
    [self addbottomBorder:positionR withColor:nil];
    [self addbottomBorder:telR withColor:nil];
    [self addbottomBorder:emailR withColor:nil];
    
    [self loadProfile];
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
             nameR.text = [profileJSON objectForKey:@"name"];
             surnameR.text = [profileJSON objectForKey:@"lastname"];
             idR.text = [profileJSON objectForKey:@"ac_no"];
             birthdayR.text = [profileJSON objectForKey:@"phone"];
             branchR.text = [profileJSON objectForKey:@"department_branch"];
             departmentR.text = [profileJSON objectForKey:@"department_name"];
             positionR.text = [profileJSON objectForKey:@"designation_name"];
             telR.text = [profileJSON objectForKey:@"phone"];
             emailR.text = [profileJSON objectForKey:@"email"];
             
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

- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.userInteractionEnabled = NO;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
