//
//  Leave_Left.m
//  PMS
//
//  Created by Firststep Consulting on 20/2/19.
//  Copyright © 2019 TMA Digital Company Limited. All rights reserved.
//

#import "Leave_Left.h"
#import "LeaveCell.h"
#import "LeaveForm.h"
#import "FTPopOverMenu.h"
#import "ChatRoom.h"

@interface Leave_Left ()

@end

@implementation Leave_Left

@synthesize mode,sumView,sumTitle,sumL1,sumL2,sumL3,sumR1,sumR2,sumR3,myTable,leftBtn,addBtn,titleLabel;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    if ([mode isEqualToString:@"Leave"]) {
        titleLabel.text = @"ลางาน";
        addBtn.hidden = !delegate.leaveBtnShow;
        sumViewHeight0.active = NO;
        sumViewHeight1.active = YES;
        [self loadTopic];
    }
    else //Leave_Ahead
    {
        titleLabel.text = @"ขอหยุดงานล่วงหน้า";
        addBtn.hidden = NO;
        sumViewHeight0.active = YES;
        sumViewHeight1.active = NO;
        [self loadList];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [leftBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    sumTitle.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize+2];
    sumL1.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    sumL2.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    sumL3.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    sumR1.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    sumR2.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    sumR3.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    
    [addBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    addBtn.backgroundColor = delegate.mainThemeColor;
    addBtn.layer.cornerRadius = addBtn.frame.size.width/2;
    //addBtn.layer.masksToBounds = YES;
    addBtn.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    addBtn.layer.shadowRadius = 3;
    addBtn.layer.shadowOpacity = 0.8;
    addBtn.layer.shadowOffset = CGSizeMake(2,2);
    
    localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineAction:) name:@"CheckConnection" object:nil];
    
    sumViewHeight0 = [sumView.heightAnchor constraintEqualToConstant:0];
    sumViewHeight1 = [sumView.heightAnchor constraintEqualToConstant:sumView.frame.size.height];
}

-(void)onlineAction:(NSNotification *)noti
{
    [self loadTopic];
}

- (void)loadTopic
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@getLeaveTopicList/%@",delegate.serverURL,delegate.adminID];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"LeaveJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             leaveTopicJSON = responseObject;
             
             [self loadSummary];
             [self loadList];
         }
         else{
             [self loadTopic];
         }
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
{
         [self loadTopic];
     }];
}

- (void)loadSummary
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDate *today = [[NSDate alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:localeEN];
    [df setDateFormat:@"dd-MM-yyyy"];
    NSString *todayString = [df stringFromDate:today];
    
    NSString* url = [NSString stringWithFormat:@"%@getLeaveSummaryDetail/%@/%@",delegate.serverURL,delegate.userID,todayString];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"summaryJSON %@",responseObject);
         summaryJSON = responseObject;
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             
             NSDictionary *cellArray = [[summaryJSON objectForKey:@"data"] objectAtIndex:0];
             sumTitle.text = [NSString stringWithFormat:@"สรุปวันลาประจำปี %@",[cellArray objectForKey:@"year"]];
             sumL1.text = [cellArray objectForKey:@"leave_detail"];
             sumR1.text = [NSString stringWithFormat:@"%@ วัน",[cellArray objectForKey:@"leave_use_date"]];
             
             cellArray = [[summaryJSON objectForKey:@"data"] objectAtIndex:1];
             sumL2.text = [cellArray objectForKey:@"leave_detail"];
             sumR2.text = [NSString stringWithFormat:@"%@ วัน",[cellArray objectForKey:@"leave_use_date"]];
             
             cellArray = [[summaryJSON objectForKey:@"data"] objectAtIndex:2];
             sumL3.text = [cellArray objectForKey:@"leave_detail"];
             sumR3.text = [NSString stringWithFormat:@"%@ วัน",[cellArray objectForKey:@"leave_use_date"]];
             
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

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url;
    
    if ([mode isEqualToString:@"Leave"]) {
        url = [NSString stringWithFormat:@"%@getLeaveList/%@",delegate.serverURL,delegate.userID];
    }
    else if ([mode isEqualToString:@"Leave_Ahead"])
    {
        url = [NSString stringWithFormat:@"%@leaveAheadList/%@",delegate.serverURL,delegate.userID];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"LeaveJSON %@",responseObject);
         leaveJSON = responseObject;
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
    
    headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"LeaveHeader"];
    
    if ([mode isEqualToString:@"Leave"]) {
        headerCell.Label1.text = @"วันที่เริ่มต้น";
        headerCell.Label2.text = @"วันที่สิ้นสุด";
        headerCell.Label3.text = @"ประเภท";
        headerCell.Label4.text = @"สถานะ";
        //headerCell.Label5.text = @"ทางเลือก";
    }
    else if ([mode isEqualToString:@"Leave_Ahead"])
    {
        headerCell.Label1.text = @"ชื่อผู้ขอ";
        headerCell.Label2.text = @"ตั้งแต่วันที่";
        headerCell.Label3.text = @"ถึงวันที่";
        headerCell.Label4.text = @"สถานะ";
        //headerCell.Label5.text = @"ทางเลือก";
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
    if ([[leaveJSON objectForKey:@"status"] isEqualToString:@"success"]) {
        return [[leaveJSON objectForKey:@"data"] count];
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
    
    NSDictionary *cellArray = [[leaveJSON objectForKey:@"data"] objectAtIndex:indexPath.row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setLocale:localeEN];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"dd/MM/yyyy"];//[df2 setDateFormat:@"dd MMM yy"];
    [df2 setLocale:localeEN];
    NSDate * tmpDate;
    
    cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"LeaveCell"];
    
    if ([mode isEqualToString:@"Leave"]) {
        tmpDate = [df dateFromString:[cellArray objectForKey:@"start_date"]];
        cell.Label1.text = [df2 stringFromDate:tmpDate];
        tmpDate = [df dateFromString:[cellArray objectForKey:@"end_date"]];
        cell.Label2.text = [df2 stringFromDate:tmpDate];
        for (int i=0; i<3; i++)
        {
            NSMutableDictionary *topicArray = [[leaveTopicJSON objectForKey:@"data"] objectAtIndex:i];
            if ([[cellArray objectForKey:@"leave_detail_id"] isEqualToString:[topicArray objectForKey:@"leave_detail_id"]]) {
                cell.Label3.text = [topicArray objectForKey:@"leave_detail"];
            }
            else{
                
            }
        }
    }
    else if ([mode isEqualToString:@"Leave_Ahead"])
    {
        cell.Label1.text = [cellArray objectForKey:@"user_name"];
        tmpDate = [df dateFromString:[cellArray objectForKey:@"start_date"]];
        cell.Label2.text = [df2 stringFromDate:tmpDate];
        tmpDate = [df dateFromString:[cellArray objectForKey:@"end_date"]];
        cell.Label3.text = [df2 stringFromDate:tmpDate];
    }
    
    if([[cellArray objectForKey:@"status_text"] isEqualToString:@"สร้างคำขอ"])
    {
        cell.Label4.text = [cellArray objectForKey:@"status_text"];
        cell.Label4.textColor = [UIColor grayColor];
        cell.actionBtn.hidden = YES;
        cell.dropdownBtn.hidden = YES;
    }
    else if([[cellArray objectForKey:@"status_text"] isEqualToString:@"รอดำเนินการ"])
    {
        cell.Label4.text = [cellArray objectForKey:@"status_text"];
        cell.Label4.textColor = [UIColor colorWithRed:161.0/255 green:130.0/255 blue:88.0/255 alpha:1];
        cell.actionBtn.hidden = YES;
        cell.dropdownBtn.hidden = YES;
    }
    else if([[cellArray objectForKey:@"status_text"] isEqualToString:@"รออนุมัติ"])
    {
        cell.Label4.text = [cellArray objectForKey:@"status_text"];
        cell.Label4.textColor = [UIColor colorWithRed:161.0/255 green:130.0/255 blue:88.0/255 alpha:1];
        cell.actionBtn.hidden = YES;
        cell.dropdownBtn.hidden = YES;
    }
    else if([[cellArray objectForKey:@"status_text"] isEqualToString:@"อนุมัติ"])
    {
        cell.Label4.text = [cellArray objectForKey:@"status_text"];
        cell.Label4.textColor = [UIColor colorWithRed:49.0/255 green:107.0/255 blue:4.0/255 alpha:1];
        cell.actionBtn.hidden = YES;
        cell.dropdownBtn.hidden = YES;
    }
    else if([[cellArray objectForKey:@"status_text"] isEqualToString:@"ไม่อนุมัติ"])
    {
        cell.Label4.text = [cellArray objectForKey:@"status_text"];
        cell.Label4.textColor = delegate.cancelThemeColor;
        cell.actionBtn.hidden = YES;
        cell.dropdownBtn.hidden = YES;
    }
    
    if(indexPath.row % 2)
    {
        //cell.contentView.backgroundColor= [UIColor whiteColor];
        cell.contentView.backgroundColor= [delegate.mainThemeColor2 colorWithAlphaComponent:0.2f];
    }
    else
    {
        cell.contentView.backgroundColor= [delegate.mainThemeColor2 colorWithAlphaComponent:0.04f];
    }
    
    float fontSizeCell = delegate.fontSize-3;
    cell.Label1.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.Label2.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.Label3.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.Label4.font = [UIFont fontWithName:delegate.fontBold size:fontSizeCell];
    cell.actionBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    
    /*
     [cell.actionBtn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
     cell.actionBtn.tag = indexPath.row;
     
     [cell.dropdownBtn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
     cell.dropdownBtn.tag = indexPath.row;
     
     UIView *bgColorView = [[UIView alloc] init];
     bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];;
     [cell setSelectedBackgroundView:bgColorView];
     */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellArray = [[leaveJSON objectForKey:@"data"] objectAtIndex:indexPath.row];
    [self editClicked:cellArray];
}

- (void)editClicked:(NSDictionary*)leaveDetail
{
    LeaveForm *viewController = [[LeaveForm alloc]initWithNibName:@"LeaveForm" bundle:nil];
    viewController.mode = mode;
    viewController.action = @"edit";
    viewController.leaveTopicArray = [leaveTopicJSON objectForKey:@"data"];
    viewController.leaveDetailArray = leaveDetail;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)addClicked:(NSDictionary*)leaveDetail
{
    LeaveForm *viewController = [[LeaveForm alloc]initWithNibName:@"LeaveForm" bundle:nil];
    viewController.mode = mode;
    viewController.action = @"add";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightMenu:(id)sender {
    ChatRoom *cr = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatRoom"];
    cr.fromID = delegate.userID;
    //cr.toID = [[listJSON objectAtIndex:indexPath.row] objectForKey:@"user"];
    [self.navigationController pushViewController:cr animated:YES];
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
