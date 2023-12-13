//
//  Leave.m
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Leave.h"
#import "LeaveCell.h"
#import "LeaveForm.h"
#import "FTPopOverMenu.h"
#import "ChatRoom.h"
#import "MainMenu.h"
#import "Profile.h"
#import "Agenda.h"
#import "SDWebImage.h"

@interface Leave ()

@end

@implementation Leave

@synthesize mode,sumView,sumTitle,sumL1,sumL2,sumL3,sumR1,sumR2,sumR3,myTable,leaveBtn,otBtn,timeBtn,leftBtn,addBtn,rightMenu;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = YES;
    self.tabBarController.tabBar.hidden = NO;
    
    if (delegate.userPicURL != nil) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:delegate.userPicURL] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (image && finished) {
                    [rightMenu setImage:[delegate imageByCroppingImage:image toSize:CGSizeMake(image.size.width, image.size.width)] forState:UIControlStateNormal];
                }}];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    leaveBtn.titleLabel.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize-1];
    otBtn.titleLabel.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize-1];
    timeBtn.titleLabel.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize-1];
    
    [leftBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [leaveBtn setBackgroundColor:delegate.mainThemeColor];
    
    rightMenu.layer.borderColor = [[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1] CGColor];
    rightMenu.layer.borderWidth = 1;
    rightMenu.layer.cornerRadius = rightMenu.frame.size.height/2;
    rightMenu.layer.masksToBounds = YES;
    
    sumTitle.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize+2];
    sumL1.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    sumL2.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    sumL3.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    sumR1.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    sumR2.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    sumR3.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    
    [addBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    addBtn.backgroundColor = delegate.mainThemeColor;
    addBtn.layer.cornerRadius = addBtn.frame.size.width/2;
    //addBtn.layer.masksToBounds = YES;
    addBtn.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    addBtn.layer.shadowRadius = 3;
    addBtn.layer.shadowOpacity = 0.8;
    addBtn.layer.shadowOffset = CGSizeMake(2,2);
    
    localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    
    /*
    if (!mode) {
        mode = @"Absence";
        addBtn.hidden = !delegate.leaveBtnShow;
        [self loadList];
    }
    */
    
    if (!mode) {
        mode = @"Time";
        addBtn.hidden = YES;
        [self loadList];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineAction:) name:@"CheckConnection" object:nil];
    
    sumViewHeight0 = [sumView.heightAnchor constraintEqualToConstant:0];
    sumViewHeight1 = [sumView.heightAnchor constraintEqualToConstant:sumView.frame.size.height];
    
    sumViewHeight0.active = YES;
    sumViewHeight1.active = NO;
}

- (IBAction)leaveClick:(id)sender
{
    mode = @"Absence";
    
    sumViewHeight0.active = YES;
    sumViewHeight1.active = NO;
    
    [leaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leaveBtn setBackgroundColor:delegate.mainThemeColor];
    
    [otBtn setTitleColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1] forState:UIControlStateNormal];
    [otBtn setBackgroundColor:[UIColor whiteColor]];
    [timeBtn setTitleColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1] forState:UIControlStateNormal];
    [timeBtn setBackgroundColor:[UIColor whiteColor]];
    
    addBtn.hidden = YES;
    //[self loadSummary];
    [self loadList];
    
    //[sumView.heightAnchor constraintEqualToConstant:0].active = YES;
}

- (IBAction)otClick:(id)sender
{
    mode = @"OT";
    
    sumViewHeight0.active = NO;
    sumViewHeight1.active = YES;
    
    sumL3.hidden = YES;
    sumR3.hidden = YES;
    
    [otBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [otBtn setBackgroundColor:delegate.mainThemeColor];
    
    [leaveBtn setTitleColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1] forState:UIControlStateNormal];
    [leaveBtn setBackgroundColor:[UIColor whiteColor]];
    [timeBtn setTitleColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1] forState:UIControlStateNormal];
    [timeBtn setBackgroundColor:[UIColor whiteColor]];
    
    addBtn.hidden = !delegate.otBtnShow;
    [self loadSummary];
    [self loadList];
}

- (IBAction)timeClick:(id)sender
{
    mode = @"Time";
    
    sumViewHeight0.active = YES;
    sumViewHeight1.active = NO;
    //[sumView.heightAnchor constraintEqualToConstant:0].active = YES;
    
    [timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [timeBtn setBackgroundColor:delegate.mainThemeColor];
    
    [leaveBtn setTitleColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1] forState:UIControlStateNormal];
    [leaveBtn setBackgroundColor:[UIColor whiteColor]];
    [otBtn setTitleColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1] forState:UIControlStateNormal];
    [otBtn setBackgroundColor:[UIColor whiteColor]];
    
    addBtn.hidden = YES;
    //[self loadSummary];
    [self loadList];
}

-(void)onlineAction:(NSNotification *)noti
{
    [self loadList];
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
    
    NSString* url;
    if ([mode isEqualToString:@"OT"])
    {
        url = [NSString stringWithFormat:@"%@getOTSummaryDetail/%@/%@",delegate.serverURL,delegate.userID,todayString];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"summaryJSON %@",responseObject);
         summaryJSON = responseObject;
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             
             if ([mode isEqualToString:@"OT"])
             {
                 NSDictionary *cellArray = [[summaryJSON objectForKey:@"data"] objectAtIndex:0];
                 sumTitle.text = @"สรุปการขอชั่วโมงสะสม";
                 sumL1.text = [NSString stringWithFormat:@"เดือน%@ %@",[cellArray objectForKey:@"month_name"],[cellArray objectForKey:@"year"]];
                 sumR1.text = [NSString stringWithFormat:@"%@ ชั่วโมง",[cellArray objectForKey:@"worktime_must_work"]];
                 sumL2.text = @"ชั่วโมงทำงาน";
                 sumR2.text = [NSString stringWithFormat:@"%@ ชั่วโมง",[cellArray objectForKey:@"worktime_by_boss"]];
                 sumL3.text = @"ชั่วโมงสะสมปัจจุบัน";
                 sumR3.text = [NSString stringWithFormat:@"%@ ชั่วโมง",[cellArray objectForKey:@"worktime_clock_inout"]];
             }
             
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
    if ([mode isEqualToString:@"Absence"]) {
        url = [NSString stringWithFormat:@"%@absenceRequestList/%@",delegate.serverURL,delegate.userID];
    }
    else if ([mode isEqualToString:@"OT"])
    {
        url = [NSString stringWithFormat:@"%@getOverTimeListNew/%@",delegate.serverURL,delegate.userID];
    }
    else if ([mode isEqualToString:@"Time"])
    {
        url = [NSString stringWithFormat:@"%@clockInClockOutLateList/%@",delegate.serverURL,delegate.userID];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"LeaveJSON %@",responseObject);
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
    
    if ([mode isEqualToString:@"Absence"]) {
        headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"LeaveHeader"];
        
        headerCell.Label1.text = @"วันที่";
        headerCell.Label2.text = @"เข้างาน";
        headerCell.Label3.text = @"ออกงาน";
        headerCell.Label4.text = @"สถานะ";
        //headerCell.Label5.text = @"ทางเลือก";
    }
    else if ([mode isEqualToString:@"OT"])
    {
        headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"OTHeader"];
        
        headerCell.Label1.text = @"วันที่";
        headerCell.Label2.text = @"เวลาเริ่มต้น";
        headerCell.Label3.text = @"เวลาสิ้นสุด";
        headerCell.Label4.text = @"สถานะ";
        //headerCell.Label5.text = @"ทางเลือก";
    }
    else if ([mode isEqualToString:@"Time"])
    {
        headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"LeaveHeader"];
        
        headerCell.Label1.text = @"วันที่";
        headerCell.Label2.text = @"เวลา";
        headerCell.Label3.text = @"รูปแบบ";
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
    
    if ([mode isEqualToString:@"Absence"]) {
        cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"LeaveCell"];
        
        tmpDate = [df dateFromString:[cellArray objectForKey:@"shift_date"]];
        cell.Label1.text = [df2 stringFromDate:tmpDate];
        cell.Label2.text = [cellArray objectForKey:@"on_duty"];
        cell.Label3.text = [cellArray objectForKey:@"off_duty"];
    }
    else if ([mode isEqualToString:@"OT"])
    {
        cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"OTCell"];
        tmpDate = [df dateFromString:[cellArray objectForKey:@"date"]];
        cell.Label1.text = [df2 stringFromDate:tmpDate];
        cell.Label2.text = [cellArray objectForKey:@"real_time_start"];
        cell.Label3.text = [cellArray objectForKey:@"real_time_end"];
    }
    else if ([mode isEqualToString:@"Time"])
    {
        cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"LeaveCell"];
        tmpDate = [df dateFromString:[cellArray objectForKey:@"clock_date"]];
        cell.Label1.text = [df2 stringFromDate:tmpDate];
        cell.Label2.text = [cellArray objectForKey:@"clock"];
        cell.Label3.text = [cellArray objectForKey:@"clock_type_name"];
    }
    
    if([[cellArray objectForKey:@"status_text"] isEqualToString:@"สร้างคำขอ"])
    {
        cell.Label4.text = [cellArray objectForKey:@"status_text"];
        cell.Label4.textColor = [UIColor grayColor];
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
    if ([mode isEqualToString:@"Absence"]||[mode isEqualToString:@"OT"]||[mode isEqualToString:@"Time"]) {
        [self editClicked:cellArray];
    }
}
/*
- (IBAction)actionClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Action %ld",button.tag);
    
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuRowHeight = (self.view.frame.size.height/20);
    configuration.menuWidth = myTable.frame.size.width*0.2;
    configuration.textColor = [UIColor darkGrayColor];
    configuration.textFont = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-3];
    configuration.borderColor = [UIColor colorWithRed:232.0/255 green:232.0/255 blue:234.0/255 alpha:1];
    configuration.borderWidth = 1;
    configuration.tintColor = [UIColor whiteColor];
    //configuration.textAlignment = ...
    //configuration.ignoreImageOriginalColor = ...;// set 'ignoreImageOriginalColor' to YES, images color will be same as textColor
    ///configuration.allowRoundedArrow = ...;// Default is 'NO', if sets to 'YES', the arrow will be drawn with round corner.
    
    [FTPopOverMenu showForSender:sender withMenuArray:@[@" แก้ไข",@" ลบ"] doneBlock:^(NSInteger selectedIndex) {
        NSLog(@"Action %ld Menu %ld",button.tag,(long)selectedIndex);
        
        NSDictionary *cellArray = [[leaveJSON objectForKey:@"data"] objectAtIndex:button.tag];
        
        if (selectedIndex == 0) {
            //NSLog(@"Edit %@",[cellArray objectForKey:@"leave_id"]);
            [self editClicked:cellArray];
        }
        else if (selectedIndex == 1) {
            //NSLog(@"Delete %@",[cellArray objectForKey:@"leave_id"]);
            if ([mode isEqualToString:@"Absence"]) {
                [self deleteClicked:[cellArray objectForKey:@"leave_id"]];
            }
            else if ([mode isEqualToString:@"OT"])
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยืนยันการลบการขอชั่วโมงสะสม" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"Delete");
                    [self deleteClicked:[cellArray objectForKey:@"ot_id"]];
                }];
                [alertController addAction:confirmAction];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"Cancel");
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    } dismissBlock:^{
        NSLog(@"Close");
    }];
}

- (void)deleteClicked:(NSString*)leaveID
{
    [SVProgressHUD showWithStatus:@"Canceling Request"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url;
    if ([mode isEqualToString:@"Absence"]) {
        url = [NSString stringWithFormat:@"%@deleteLeaveData/%@",delegate.serverURL,leaveID];
    }
    else if ([mode isEqualToString:@"OT"])
    {
        url = [NSString stringWithFormat:@"%@deleteOvertimeData/%@",delegate.serverURL,leaveID];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"DeleteJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             [self loadList];
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
*/
- (void)editClicked:(NSDictionary*)leaveDetail
{
    LeaveForm *viewController = [[LeaveForm alloc]initWithNibName:@"LeaveForm" bundle:nil];
    viewController.mode = mode;
    viewController.action = @"edit";
    viewController.leaveTopicArray = [leaveTopicJSON objectForKey:@"data"];
    viewController.leaveDetailArray = leaveDetail;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)addClicked:(id)sender
{
    LeaveForm *viewController = [[LeaveForm alloc]initWithNibName:@"LeaveForm" bundle:nil];
    viewController.mode = mode;
    viewController.action = @"add";
    viewController.leaveTopicArray = [leaveTopicJSON objectForKey:@"data"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)leftMenuClick:(id)sender
{
    //[self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
    Agenda *ag = [self.storyboard instantiateViewControllerWithIdentifier:@"Agenda"];
    [self.navigationController pushViewController:ag animated:YES];
}

- (IBAction)rightMenuClick:(id)sender
{
    Profile *pf = [[Profile alloc]initWithNibName:@"Profile" bundle:nil];
    [self.navigationController pushViewController:pf animated:YES];
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
