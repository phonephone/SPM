//
//  UserDocument.m
//  Mangkud
//
//  Created by Firststep Consulting on 14/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "UserDocument.h"

@interface UserDocument ()

@end

@implementation UserDocument
@synthesize titleLabel,resumeLabel,offerLetterLabel,joiningLetterLabel,contractLabel,otherLabel,chooseBtn1,chooseBtn2,chooseBtn3,chooseBtn4,chooseBtn5,downloadBtn,downloadLabel,submitBtn;

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
    
    NSString *fontName = delegate.fontRegular;
    float fontSize = delegate.fontSize+1;
    resumeLabel.font = [UIFont fontWithName:fontName size:fontSize];
    offerLetterLabel.font = [UIFont fontWithName:fontName size:fontSize];
    joiningLetterLabel.font = [UIFont fontWithName:fontName size:fontSize];
    contractLabel.font = [UIFont fontWithName:fontName size:fontSize];
    otherLabel.font = [UIFont fontWithName:fontName size:fontSize];
    
    [chooseBtn1.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [chooseBtn2.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [chooseBtn3.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [chooseBtn4.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [chooseBtn5.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [downloadBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    downloadLabel.font = [UIFont fontWithName:fontName size:fontSize-3];
    
    submitBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
}

- (IBAction)resumeClick:(id)sender
{
    
}

- (IBAction)offerClick:(id)sender
{
    
}

- (IBAction)joiningClick:(id)sender
{
    
}

- (IBAction)contractClick:(id)sender
{
    
}

- (IBAction)otherClick:(id)sender
{
    
}

- (IBAction)downloadClick:(id)sender
{
    
}

- (IBAction)submitClick:(id)sender
{
    
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
