//
//  ActivityDetail.m
//  PMS
//
//  Created by Truk Karawawattana on 8/3/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import "ActivityDetail.h"
#import "ActivityJoinList.h"
#import "UIImageView+WebCache.h"

@interface ActivityDetail ()

@end

@implementation ActivityDetail

@synthesize rewardID,rewardPic,nameLabel,detailLabel,amountLabel,pointLabel,expireLabel,scrollDetail,submitBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    
    submitBtn.userInteractionEnabled = NO;
    [submitBtn setTitle:@"" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor lightGrayColor]];
    
    scrollDetail.delegate = self;
    
    [self loadList];
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"http://spm-hero.thaidevelopers.com/api/event_info/%@/%@",rewardID,delegate.userID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"ListJSON %@",responseObject);
        listJSON = [[responseObject objectForKey:@"data"] mutableCopy];
        
        [rewardPic sd_setImageWithURL:[NSURL URLWithString:[listJSON objectForKey:@"cover_img"]] placeholderImage:[UIImage imageNamed:@"logo_square.png"]];
        nameLabel.text = [listJSON objectForKey:@"title"];
        
        NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithData:[[listJSON objectForKey:@"content"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                             documentAttributes:nil error:nil];
        
        UIFont *replacementFont =  [UIFont fontWithName:delegate.fontLight size:delegate.fontSize+2];
        [attString addAttribute:NSFontAttributeName value:replacementFont range:NSMakeRange(0,attString.length)];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,attString.length)];
        
        detailLabel.attributedText = attString;
        
        amountLabel.text = [NSString stringWithFormat:@"จำนวนผู้ร่วมงาน : %@ / %@",[[listJSON objectForKey:@"register"] stringValue],[listJSON objectForKey:@"amount"]];
        pointLabel.text = [NSString stringWithFormat:@"คะแนนที่ได้รับ : %@ คะแนน",[listJSON objectForKey:@"score"]];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSLocale *localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        [df setLocale:localeEN];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
        NSLocale *localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
        [df2 setLocale:localeTH];
        [df2 setDateFormat:@"dd MMM yyyy HH:mm"];
        
        NSDate *expireDate = [df dateFromString:[listJSON objectForKey:@"date_end"]];
        
        expireLabel.text = [NSString stringWithFormat:@"วันสิ้นสุดร่วมงาน : %@",[df2 stringFromDate:expireDate]];
        
        if ([[[listJSON objectForKey:@"user_register"] stringValue] isEqualToString:@"0"]) {
            submitBtn.userInteractionEnabled = YES;
            [submitBtn setTitle:@"เข้าร่วมกิจกรรม" forState:UIControlStateNormal];
            [submitBtn setBackgroundColor:delegate.mainThemeColor];
        }
        else{
            submitBtn.userInteractionEnabled = NO;
            [submitBtn setTitle:@"เข้าร่วมกิจกรรมแล้ว" forState:UIControlStateNormal];
            [submitBtn setBackgroundColor:[UIColor lightGrayColor]];
        }
        
        if ([[listJSON objectForKey:@"user_register"] intValue] >= [[listJSON objectForKey:@"amount"] intValue]) {
            submitBtn.userInteractionEnabled = NO;
            [submitBtn setTitle:@"ผู้เข้าร่วมเต็มแล้ว" forState:UIControlStateNormal];
            [submitBtn setBackgroundColor:[UIColor lightGrayColor]];
        }
        
        [SVProgressHUD dismiss];
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"Error %@",error);
        [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.contentOffset = CGPointMake(0, scrollDetail.contentOffset.y);
}

- (IBAction)submitClick:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยืนยันการเข้าร่วมกิจกรรม" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self submitJoin];
    }];
    [alertController addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)submitJoin
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"http://spm-hero.thaidevelopers.com/api/event_booking"];
    
    NSDictionary *parameters = @{@"id_user":delegate.userID,
                                 @"id_event":[listJSON objectForKey:@"id"]
    };
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"RedeemJSON %@",responseObject);
        //redeemJSON = [[responseObject objectForKey:@"data"] mutableCopy];
        
        [SVProgressHUD showSuccessWithStatus:@"เข้าร่วมกิจกรรมเรียบร้อยแล้ว"];
        [SVProgressHUD dismissWithDelay:2 completion:^
        {
            ActivityJoinList *ajl = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ActivityJoinList"];
            [delegate replaceLastNavStack:self.navigationController withView:ajl];
        }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

