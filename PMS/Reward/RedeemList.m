//
//  RedeemList.m
//  PMS
//
//  Created by Truk Karawawattana on 2/3/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import "RedeemList.h"
#import "RewardCell.h"
#import "RewardQR.h"
#import "UIImageView+WebCache.h"

@interface RedeemList ()

@end

@implementation RedeemList

@synthesize myTable,titleLabel;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    
    myTable.delegate = self;
    myTable.dataSource = self;
    
    [self loadList];
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"http://spm-hero.thaidevelopers.com/api/redeem_user/%@",delegate.userID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"ListJSON %@",responseObject);
        listJSON = [[responseObject objectForKey:@"data"] mutableCopy];
        [myTable reloadData];
        [SVProgressHUD dismiss];
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"Error %@",error);
        [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listJSON count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowHeight;
    
    rowHeight = (self.view.frame.size.width*0.4);
    
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RewardCell *cell = (RewardCell *)[tableView dequeueReusableCellWithIdentifier:@"RewardCell"];
    
    NSDictionary *cellArray = [listJSON objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [cellArray objectForKey:@"redeem"];
    [cell.rewardPic sd_setImageWithURL:[NSURL URLWithString:[cellArray objectForKey:@"cover_img"]] placeholderImage:[UIImage imageNamed:@"logo_square.png"]];
    cell.rewardBtn.tag = indexPath.row;
    [cell.rewardBtn addTarget:self action:@selector(tableClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithData:[[cellArray objectForKey:@"content"] dataUsingEncoding:NSUnicodeStringEncoding]
                                            options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                         documentAttributes:nil error:nil];
    
    UIFont *replacementFont =  [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    [attString addAttribute:NSFontAttributeName value:replacementFont range:NSMakeRange(0,attString.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,attString.length)];
    
    cell.detailLabel.attributedText = attString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RewardQR *rwd = [[RewardQR alloc]initWithNibName:@"RewardQR" bundle:nil];
    rwd.mode = @"QR";
    rwd.redeemArray = [listJSON objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:rwd animated:YES];
}

- (IBAction)tableClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    RewardQR *rwd = [[RewardQR alloc]initWithNibName:@"RewardQR" bundle:nil];
    rwd.mode = @"QR";
    rwd.redeemArray = [listJSON objectAtIndex:button.tag];
    [self.navigationController pushViewController:rwd animated:YES];
}

- (IBAction)userClick:(id)sender
{
    
}

- (IBAction)redeemClick:(id)sender
{
    
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
