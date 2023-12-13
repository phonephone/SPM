//
//  RewardHistory.m
//  PMS
//
//  Created by Truk Karawawattana on 8/3/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import "RewardHistory.h"
#import "RewardCell.h"

@interface RewardHistory ()

@end

@implementation RewardHistory

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
    
    NSString* url = [NSString stringWithFormat:@"http://spm-hero.thaidevelopers.com/api/history_user/%@",delegate.userID];
    
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
    
    rowHeight = (self.view.frame.size.width*0.3);
    
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RewardCell *cell = (RewardCell *)[tableView dequeueReusableCellWithIdentifier:@"RewardCell"];
    
    NSDictionary *cellArray = [listJSON objectAtIndex:indexPath.row];
    
    if ([[cellArray objectForKey:@"type"] isEqualToString:@"redeem"]) {
        cell.pointLabel.text = [NSString stringWithFormat:@"ใช้คะแนน %@ คะแนน",[cellArray objectForKey:@"score"]];
        cell.pointLabel.textColor = [UIColor redColor];
    }
    else if ([[cellArray objectForKey:@"type"] isEqualToString:@"event"]) {
        cell.pointLabel.text = [NSString stringWithFormat:@"ได้คะแนน %@ คะแนน",[cellArray objectForKey:@"score"]];
        cell.pointLabel.textColor = delegate.mainThemeColor;
    }
    else if ([[cellArray objectForKey:@"type"] isEqualToString:@"manager"]) {
        cell.pointLabel.text = [NSString stringWithFormat:@"ได้คะแนน %@ คะแนน",[cellArray objectForKey:@"score"]];
        cell.pointLabel.textColor = delegate.mainThemeColor;
    }
    
    cell.nameLabel.text = [cellArray objectForKey:@"name"];
    cell.detailLabel.text = [NSString stringWithFormat:@"เมื่อวันที่ %@",[cellArray objectForKey:@"date"]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
