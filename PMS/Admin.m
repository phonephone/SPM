//
//  Admin.m
//  Mangkud
//
//  Created by Firststep Consulting on 21/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Admin.h"


@interface Admin ()

@end

@implementation Admin

@synthesize textLabel,webBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    textLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+1];
    webBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
    
    textLabel.text = @"แอปพลิเคชันนี้ ออกแบบมาสำหรับพนักงาน\n\nบัญชีผู้ดูแลระบบ\nกรุณาใช้งานผ่านทาง\nhttp://www.mangkud.co/\n\nขอบคุณค่ะ";
    webBtn.backgroundColor = delegate.mainThemeColor;
    //[signinBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    webBtn.layer.cornerRadius = webBtn.frame.size.height/2;
    webBtn.layer.masksToBounds = YES;
}

- (IBAction)webClick:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.mangkud.co/index.php"];
    //[[UIApplication sharedApplication] openURL:url];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
    
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
