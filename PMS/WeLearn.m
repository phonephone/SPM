//
//  WeLearn.m
//  PMS
//
//  Created by Truk Karawawattana on 14/6/2562 BE.
//  Copyright © 2562 TMA Digital Company Limited. All rights reserved.
//

#import "WeLearn.h"
#import "LeaveCell.h"
#import "Web.h"

@interface WeLearn ()

@end

@implementation WeLearn

@synthesize mode,weLearnID,weRosterArray,titleStr,titleLabel,myTable;

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
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.text = titleStr;
    
    if ([mode isEqualToString:@"We Roster"]) {
        //titleLabel.text = mode;
        [myTable reloadData];
    }
    else if ([mode isEqualToString:@"We Learn"])
    {
        [self loadList];
    }
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@weLearnMenuList/%@",delegate.serverURL,weLearnID];
    //titleLabel.text = @"การเรียนแบบออนไลน์ (We learn)";
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"weLearnJSON %@",responseObject);
         
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             [SVProgressHUD dismiss];
             welearnJSON = [responseObject objectForKey:@"data"];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
             //[self alertTitle:@"Fail" detail:[responseObject objectForKey:@"message"]];
         }
         [myTable reloadData];
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
    if ([mode isEqualToString:@"We Roster"]) {
        return 3;
    }
    else{// We Learn
        return [welearnJSON count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowHeight;
    
    rowHeight = (self.view.frame.size.height/12);
    
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellArray = [welearnJSON objectAtIndex:indexPath.row];
    
    LeaveCell *cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"LeaveCell"];
    
    NSString *dateString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if ([mode isEqualToString:@"We Roster"]) {
        
        if (indexPath.row == 0) {
            dateString = [weRosterArray objectForKey:@"monthPrev"];
        }
        else if (indexPath.row == 1) {
            dateString = [weRosterArray objectForKey:@"monthNow"];
        }
        else if (indexPath.row == 2) {
            dateString = [weRosterArray objectForKey:@"monthNext"];
        }
        NSLog(@"XXX %@",dateString);
        
        [dateFormatter setDateFormat:@"MM-yyyy"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
        NSDate *myDate = [dateFormatter dateFromString:dateString];
        NSLog(@"YYY %@",myDate);
        
        [dateFormatter setDateFormat:@"MMMM yyyy"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"th"]];
        NSString *dateStringTH = [dateFormatter stringFromDate:myDate];
        
        //NSLog(@"ZZZ %@",dateStringTH);
        
        //cell.Label1.text = dateString;//[weRosterArray objectForKey:@"department_name"];
        cell.Label1.text = [NSString stringWithFormat:@"%@ (เดือน%@)",[weRosterArray objectForKey:@"department_code"],dateStringTH];
    }
    else{// We Learn
        cell.Label1.text = [cellArray objectForKey:@"topic"];
    }
    
    cell.Label1.font = [UIFont fontWithName:delegate.fontMedium size:delegate.fontSize+2];
    
    if(indexPath.row % 2)
    {
        //cell.contentView.backgroundColor= [UIColor whiteColor];
        cell.contentView.backgroundColor= [delegate.mainThemeColor2 colorWithAlphaComponent:0.2f];
    }
    else
    {
        cell.contentView.backgroundColor= [delegate.mainThemeColor2 colorWithAlphaComponent:0.04f];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([mode isEqualToString:@"We Roster"]) {
        
        NSString *dateString;
        if (indexPath.row == 0) {
            dateString = [weRosterArray objectForKey:@"monthPrev"];
        }
        else if (indexPath.row == 1) {
            dateString = [weRosterArray objectForKey:@"monthNow"];
        }
        else if (indexPath.row == 2) {
            dateString = [weRosterArray objectForKey:@"monthNext"];
        }
        
        Web *web = [[Web alloc]initWithNibName:@"Web" bundle:nil];
        web.urlStr = [NSString stringWithFormat:@"%@index.php?MobileWebView/viewShiftTable/%@/%@/%@",delegate.serverURLshort,delegate.userID,dateString,[weRosterArray objectForKey:@"department_id"]];
        web.titleStr = @"We Roster";
        [self.navigationController pushViewController:web animated:YES];
    }
    else{// We Learn
        NSDictionary *cellArray = [welearnJSON objectAtIndex:indexPath.row];
        NSString *linkID = [cellArray objectForKey:@"id"];
        NSString *linkURL = [cellArray objectForKey:@"link"];
        [self updatePointBeforeOpenLink:linkID withURL:linkURL];
    }
}

- (void)updatePointBeforeOpenLink:(NSString*)linkID withURL:(NSString*)linkURL
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@updatePointWeLearnMenu/%@/%@/1",delegate.serverURL,delegate.userID,linkID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"updatePointJSON %@",responseObject);
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkURL]];
         [SVProgressHUD dismiss];
         /*
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             [SVProgressHUD dismiss];
             
         }
         else{
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
         }
          */
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

