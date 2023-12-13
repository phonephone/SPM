//
//  Approve.m
//  Mangkud
//
//  Created by Firststep Consulting on 5/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Approve.h"
#import "ApproveDetail.h"
#import "LeaveCell.h"
#import "FTPopOverMenu.h"
#import "LeftMenu.h"

@interface Approve ()

@end

@implementation Approve

@synthesize mode,titleLabel,myTable;

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
    
    if (!mode) {
        mode = @"Leave";
    }
    
    [self loadList];
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url;
    if ([mode isEqualToString:@"Leave"]) {
        url = [NSString stringWithFormat:@"%@getLeaveListAuthorize/%@",delegate.serverURL,delegate.userID];
        titleLabel.text = @"จัดการคำขอลางาน";
    }
    else if ([mode isEqualToString:@"Leave_Ahead"])
    {
        url = [NSString stringWithFormat:@"%@leaveAheadListForApprover/%@",delegate.serverURL,delegate.userID];
        titleLabel.text = @"จัดการคำขอหยุดงานล่วงหน้า";
    }
    else if ([mode isEqualToString:@"Absence"])
    {
        url = [NSString stringWithFormat:@"%@absenceRequestListForApprover/%@",delegate.serverURL,delegate.userID];
        titleLabel.text = @"จัดการคำขอหยุดงาน";
    }
    else if ([mode isEqualToString:@"OT"])
    {
        url = [NSString stringWithFormat:@"%@getOverTimeListAuthorize/%@",delegate.serverURL,delegate.userID];
        titleLabel.text = @"จัดการคำขอชั่วโมงสะสม";
    }
    else if ([mode isEqualToString:@"Swap"])
    {
        url = [NSString stringWithFormat:@"%@switchProcessListForApprover/%@",delegate.serverURL,delegate.userID];
        titleLabel.text = @"จัดการคำขอแลกเวร";
    }
    else if ([mode isEqualToString:@"Time"])
    {
        url = [NSString stringWithFormat:@"%@adjustClockInClockOutListForApprover/%@",delegate.serverURL,delegate.userID];
        titleLabel.text = @"จัดการคำขอปรับเวลา";
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"ApproveJSON %@",responseObject);
         approveJSON = responseObject;
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             [SVProgressHUD dismiss];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.view.frame.size.height/14;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LeaveCell *headerCell;
    
    if ([mode isEqualToString:@"Leave"]) {
        headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"LeaveHeader"];
        headerCell.Label1.text = @"ชื่อผู้ขอ";
        headerCell.Label2.text = @"วันที่เริ่มต้น";
        headerCell.Label3.text = @"วันที่สิ้นสุด";
        headerCell.Label4.text = @"ประเภท";
        headerCell.Label5.text = @"สถานะ";
    }
    else if ([mode isEqualToString:@"Leave_Ahead"])
    {
        headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeHeader"];
        headerCell.Label1.text = @"ชื่อผู้ขอ";
        headerCell.Label2.text = @"ตั้งแต่วันที่";
        headerCell.Label3.text = @"ถึงวันที่";
        headerCell.Label4.text = @"สถานะ";
    }
    else if ([mode isEqualToString:@"Absence"])
    {
        headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeHeader"];
        headerCell.Label1.text = @"วันที่";
        headerCell.Label2.text = @"ชื่อผู้ขอ";
        headerCell.Label3.text = @"เวรผู้ขอ";
        headerCell.Label4.text = @"สถานะ";
    }
    else if ([mode isEqualToString:@"OT"])
    {
        headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"OTHeader"];
        headerCell.Label1.text = @"ชื่อผู้ขอ";
        headerCell.Label2.text = @"วันที่";
        headerCell.Label3.text = @"เวลาเริ่ม";
        headerCell.Label4.text = @"เวลาสิ้นสุด";
        headerCell.Label5.text = @"สถานะ";
    }
    else if ([mode isEqualToString:@"Swap"])
    {
        headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"SwapHeader"];
        headerCell.Label1.text = @"วันที่แลกเวร";
        headerCell.Label2.text = @"ผู้ขอแลกเวร";
        headerCell.Label3.text = @"ผู้เข้าเวรแทน";
        headerCell.Label4.text = @"สถานะ";
    }
    else if ([mode isEqualToString:@"Time"])
    {
        headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeHeader"];
        headerCell.Label1.text = @"วันที่";
        headerCell.Label2.text = @"ชื่อผู้ขอ";
        headerCell.Label3.text = @"รูปแบบที่ขอ";
        headerCell.Label5.text = @"สถานะ";
    }
    
    NSString *fontName = delegate.fontSemibold;
    float fontSizeHeader = delegate.fontSize-1;
    headerCell.Label1.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    headerCell.Label2.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    headerCell.Label3.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    headerCell.Label4.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    headerCell.Label5.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    
    headerCell.Label1.textColor = [UIColor darkGrayColor];
    headerCell.Label2.textColor = [UIColor darkGrayColor];
    headerCell.Label3.textColor = [UIColor darkGrayColor];
    headerCell.Label4.textColor = [UIColor darkGrayColor];
    headerCell.Label5.textColor = [UIColor darkGrayColor];
    
    int sectionHeight = (self.view.frame.size.height/14);
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0,sectionHeight-1,self.view.frame.size.width,1)];
    separator.backgroundColor = [UIColor colorWithRed:232.0/255 green:232.0/255 blue:234.0/255 alpha:1];
    [headerCell addSubview:separator];
    
    return headerCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[approveJSON objectForKey:@"status"] isEqualToString:@"success"]) {
        return [[approveJSON objectForKey:@"data"] count];
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowHeight;
    
    rowHeight = (self.view.frame.size.height/15);
    
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaveCell *cell;
    
    float fontSizeCell = delegate.fontSize-3;
    
    NSDictionary *cellArray = [[approveJSON objectForKey:@"data"] objectAtIndex:indexPath.row];
    
    NSLocale *localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setLocale:localeEN];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"dd/MM/yyyy"];
    [df2 setLocale:localeEN];
    NSDate * tmpDate;
    
    if ([mode isEqualToString:@"Swap"])
    {
        cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"SwapCell"];
        
        tmpDate = [df dateFromString:[cellArray objectForKey:@"request_date"]];
        cell.Label1.text = [df2 stringFromDate:tmpDate];
        cell.Label2.text = [cellArray objectForKey:@"request_user_name"];
        cell.Label3.text = [cellArray objectForKey:@"response_user_name"];
        
        if([[cellArray objectForKey:@"status_text"] isEqualToString:@"รออนุมัติ"])
        {
            cell.Label4.text = @"รออนุมัติ";
            cell.Label4.textColor = [UIColor colorWithRed:161.0/255 green:130.0/255 blue:88.0/255 alpha:1];
        }
        else if([[cellArray objectForKey:@"status_text"] isEqualToString:@"อนุมัติ"])
        {
            cell.Label4.text = @"อนุมัติ";
            cell.Label4.textColor = [UIColor colorWithRed:49.0/255 green:107.0/255 blue:4.0/255 alpha:1];
        }
        else if([[cellArray objectForKey:@"status_text"] isEqualToString:@"ไม่อนุมัติ"])
        {
            cell.Label4.text = @"ไม่อนุมัติ";
            cell.Label4.textColor = delegate.cancelThemeColor;
        }
        else if([[cellArray objectForKey:@"status_text"] isEqualToString:@"รอการตอบรับ"])
        {
            cell.Label4.text = @"รอการตอบรับ";
            cell.Label4.textColor = [UIColor colorWithRed:161.0/255 green:130.0/255 blue:88.0/255 alpha:1];
        }
        
        cell.Label4.font = [UIFont fontWithName:delegate.fontBold size:fontSizeCell];
    }
    else {
        if ([mode isEqualToString:@"Leave"]) {
            cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"LeaveCell"];
            
            cell.Label1.text = [cellArray objectForKey:@"name"];
            tmpDate = [df dateFromString:[cellArray objectForKey:@"start_date"]];
            cell.Label2.text = [df2 stringFromDate:tmpDate];
            tmpDate = [df dateFromString:[cellArray objectForKey:@"end_date"]];
            cell.Label3.text = [df2 stringFromDate:tmpDate];
            cell.Label4.text = [cellArray objectForKey:@"leaveDetail"];
        }
        if ([mode isEqualToString:@"Leave_Ahead"]) {
            cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
            
            cell.Label1.text = [cellArray objectForKey:@"user_name"];
            tmpDate = [df dateFromString:[cellArray objectForKey:@"start_date"]];
            cell.Label2.text = [df2 stringFromDate:tmpDate];
            tmpDate = [df dateFromString:[cellArray objectForKey:@"end_date"]];
            cell.Label3.text = [df2 stringFromDate:tmpDate];
        }
        else if ([mode isEqualToString:@"Absence"])
        {
            cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
            
            tmpDate = [df dateFromString:[cellArray objectForKey:@"shift_date"]];
            cell.Label1.text = [df2 stringFromDate:tmpDate];
            cell.Label2.text = [cellArray objectForKey:@"user_name"];
            cell.Label3.text = [NSString stringWithFormat:@"%@ - %@",[cellArray objectForKey:@"on_duty"],[cellArray objectForKey:@"off_duty"]];
        }
        else if ([mode isEqualToString:@"OT"])
        {
            cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"OTCell"];
            
            cell.Label1.text = [cellArray objectForKey:@"name"];
            tmpDate = [df dateFromString:[cellArray objectForKey:@"date"]];
            cell.Label2.text = [df2 stringFromDate:tmpDate];
            cell.Label3.text = [cellArray objectForKey:@"real_time_start"];
            cell.Label4.text = [cellArray objectForKey:@"real_time_end"];
        }
        else if ([mode isEqualToString:@"Time"])
        {
            cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
            
            tmpDate = [df dateFromString:[cellArray objectForKey:@"aft_adj_date"]];
            cell.Label1.text = [df2 stringFromDate:tmpDate];
            cell.Label2.text = [cellArray objectForKey:@"user_name"];
            cell.Label3.text = [cellArray objectForKey:@"clock_type_name"];
        }
        
        if([[cellArray objectForKey:@"status_text"] isEqualToString:@"รออนุมัติ"])
        {
            cell.Label5.text = [cellArray objectForKey:@"status_text"];
            cell.Label5.textColor = [UIColor colorWithRed:161.0/255 green:130.0/255 blue:88.0/255 alpha:1];
        }
        else if([[cellArray objectForKey:@"status_text"] isEqualToString:@"อนุมัติ"])
        {
            cell.Label5.text = [cellArray objectForKey:@"status_text"];
            cell.Label5.textColor = [UIColor colorWithRed:49.0/255 green:107.0/255 blue:4.0/255 alpha:1];
        }
        else if([[cellArray objectForKey:@"status_text"] isEqualToString:@"ไม่อนุมัติ"])
        {
            cell.Label5.text = [cellArray objectForKey:@"status_text"];
            cell.Label5.textColor = delegate.cancelThemeColor;
        }
        else if([[cellArray objectForKey:@"status_text"] isEqualToString:@"รอดำเนินการ"])
        {
            cell.Label5.text = [cellArray objectForKey:@"status_text"];
            cell.Label5.textColor = [UIColor colorWithRed:161.0/255 green:130.0/255 blue:88.0/255 alpha:1];
        }
        
        cell.Label4.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
        cell.Label5.font = [UIFont fontWithName:delegate.fontBold size:fontSizeCell];
    }
    
    cell.Label1.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.Label2.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.Label3.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    
    if(indexPath.row % 2)
    {
        //cell.contentView.backgroundColor= [UIColor whiteColor];
        cell.contentView.backgroundColor= [delegate.mainThemeColor2 colorWithAlphaComponent:0.2f];
    }
    else
    {
        cell.contentView.backgroundColor= [delegate.mainThemeColor2 colorWithAlphaComponent:0.04f];
    }
    
    /*
     UIView *bgColorView = [[UIView alloc] init];
     bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];;
     [cell setSelectedBackgroundView:bgColorView];
     */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellArray = [[approveJSON objectForKey:@"data"] objectAtIndex:indexPath.row];
    
    ApproveDetail *viewController = [[ApproveDetail alloc]initWithNibName:@"ApproveDetail" bundle:nil];
    viewController.mode = mode;
    viewController.hideBtn = YES;
    
    if ([mode isEqualToString:@"Leave"]) {
        viewController.approveID = [cellArray objectForKey:@"leave_id"];
    }
    else if ([mode isEqualToString:@"Leave_Ahead"])
    {
        viewController.approveID = [cellArray objectForKey:@"la_id"];
        viewController.approveDetailArray = cellArray;
    }
    else if ([mode isEqualToString:@"Absence"])
    {
        viewController.approveID = [cellArray objectForKey:@"ab_id"];
        viewController.approveDetailArray = cellArray;
    }
    else if ([mode isEqualToString:@"OT"])
    {
        viewController.approveID = [cellArray objectForKey:@"id"];
    }
    else if ([mode isEqualToString:@"Swap"])
    {
        viewController.approveID = [cellArray objectForKey:@"id"];
    }
    else if ([mode isEqualToString:@"Time"])
    {
        viewController.approveID = [cellArray objectForKey:@"aj_id"];
        viewController.approveDetailArray = cellArray;
    }
    
    if([[cellArray objectForKey:@"status_text"] isEqualToString:@"รออนุมัติ"]||[[cellArray objectForKey:@"status_text"] isEqualToString:@"รอดำเนินการ"])
    {
        viewController.hideBtn = NO;
    }
    else
    {
        viewController.hideBtn = YES;
    }
    [self.navigationController pushViewController:viewController animated:YES];
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
