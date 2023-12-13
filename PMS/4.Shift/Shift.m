//
//  Shift.m
//  PMS
//
//  Created by Firststep Consulting on 24/11/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Shift.h"
#import "LeaveCell.h"
#import "ShiftForm.h"
#import "FTPopOverMenu.h"
#import "ChatRoom.h"
#import "MainMenu.h"
#import "Profile.h"
#import "Agenda.h"
#import "SDWebImage.h"

@interface Shift ()

@end

@implementation Shift

@synthesize mode,sumTitle,dateField,dateBtn,sumL1,sumL2,sumL3,sumR1,sumR2,sumR3,myTable,swapBtn,acceptBtn,leftBtn,addBtn,rightMenu;

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
    
    swapBtn.titleLabel.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize-1];
    acceptBtn.titleLabel.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize-1];
    
    [leftBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [swapBtn setBackgroundColor:delegate.mainThemeColor];
    
    sumTitle.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize+2];
    sumL1.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    sumR1.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    
    rightMenu.layer.borderColor = [[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1] CGColor];
    rightMenu.layer.borderWidth = 1;
    rightMenu.layer.cornerRadius = rightMenu.frame.size.height/2;
    rightMenu.layer.masksToBounds = YES;
    
    NSDate *today = [[NSDate alloc] init];
    localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    
    dfTH = [[NSDateFormatter alloc] init];
    //dfTH.dateStyle = NSDateFormatterShortStyle;
    [dfTH setLocale:localeTH];
    
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setMaximumDate: [NSDate date]];
    [datePicker setDate:today];
    [datePicker setLocale:localeTH];
    datePicker.calendar = [localeTH objectForKey:NSLocaleCalendar];
    datePicker.tag = 1;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 13.4, *)) {
        datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    
    dateField.inputView = datePicker;
    [dfTH setDateFormat:@"MMMM yyyy"];
    dateField.text = [dfTH stringFromDate:today];
    
    dateField.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize+1];
    
    [addBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    addBtn.backgroundColor = delegate.mainThemeColor;
    addBtn.layer.cornerRadius = addBtn.frame.size.width/2;
    //addBtn.layer.masksToBounds = YES;
    addBtn.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    addBtn.layer.shadowRadius = 3;
    addBtn.layer.shadowOpacity = 0.8;
    addBtn.layer.shadowOffset = CGSizeMake(2,2);
    
    if (!mode) {
        mode = @"Swap";
        addBtn.hidden = NO;
        showDate = today;
        [self loadList:showDate];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineAction:) name:@"CheckConnection" object:nil];
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    switch (datePicker.tag) {
        case 1://Start Date
            dateField.text = [dfTH stringFromDate:datePicker.date];
            showDate = datePicker.date;
            [self loadList:showDate];
            
            //[df setDateFormat:@"yyyy-MM-dd"];
            //goDate = [df stringFromDate:datePicker.date];
            break;
    }
}

- (IBAction)dateClicked:(id)sender
{
    [dateField becomeFirstResponder];
}

- (IBAction)swapClick:(id)sender
{
    mode = @"Swap";
    [swapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [swapBtn setBackgroundColor:delegate.mainThemeColor];
    [acceptBtn setTitleColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1] forState:UIControlStateNormal];
    [acceptBtn setBackgroundColor:[UIColor whiteColor]];
    
    addBtn.hidden = NO;
    [self loadList:showDate];
}

- (IBAction)acceptClick:(id)sender
{
    mode = @"Accept";
    [acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [acceptBtn setBackgroundColor:delegate.mainThemeColor];
    [swapBtn setTitleColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1] forState:UIControlStateNormal];
    [swapBtn setBackgroundColor:[UIColor whiteColor]];
    
    addBtn.hidden = YES;
    [self loadList:showDate];
}

-(void)onlineAction:(NSNotification *)noti
{
    [self loadList:showDate];
}

- (void)loadList:(NSDate*)date
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDateFormatter *tmpdf = [[NSDateFormatter alloc] init];
    [tmpdf setLocale:localeEN];
    [tmpdf setDateFormat:@"dd-MM-yyyy"];
    NSString *tableDate = [tmpdf stringFromDate:date];
    
    NSString* url;
    if ([mode isEqualToString:@"Swap"]) {
        url = [NSString stringWithFormat:@"%@switchProcessListForRequest/%@/%@",delegate.serverURL,delegate.userID,tableDate];//dd-mm-yyyy
    }
    else if ([mode isEqualToString:@"Accept"])
    {
        url = [NSString stringWithFormat:@"%@switchProcessListForResponse/%@/%@",delegate.serverURL,delegate.userID,tableDate];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"listJSON %@",responseObject);
         listJSON = responseObject;
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             
             if ([mode isEqualToString:@"Swap"]) {
                 NSDictionary *cellArray = [[listJSON objectForKey:@"data"] objectAtIndex:0];
                 
                 sumL1.text = @"การเข้างานรวม";
                 sumR1.text = [NSString stringWithFormat:@"%@ ชั่วโมง %@ นาที",[cellArray objectForKey:@"summary_work_hours"],[cellArray objectForKey:@"summary_work_minutes"]];
             }
             else if ([mode isEqualToString:@"Accept"])
             {
                 
             }
             [myTable reloadData];
             [SVProgressHUD dismissWithDelay:0.5];
         }
         else{
             [myTable reloadData];
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
    
    if ([mode isEqualToString:@"Swap"]) {
        headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"SwapHeader"];
        
        headerCell.Label1.text = @"วันที่แลกเวร";
        headerCell.Label2.text = @"ผู้เข้าเวรแทน";
        headerCell.Label3.text = @"สถานะ";
    }
    else if ([mode isEqualToString:@"Accept"])
    {
        headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"SwapHeader"];
        
        headerCell.Label1.text = @"วันที่แลกเวร";
        headerCell.Label2.text = @"ผู้ขอแลกเวร";
        headerCell.Label3.text = @"สถานะ";
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
    if ([[listJSON objectForKey:@"status"] isEqualToString:@"success"]) {
        return [[listJSON objectForKey:@"data"] count];
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
    
    NSDictionary *cellArray = [[listJSON objectForKey:@"data"] objectAtIndex:indexPath.row];
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    [df1 setLocale:localeEN];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"dd/MM/yyyy"];//[df2 setDateFormat:@"dd MMM yy"];
    [df2 setLocale:localeEN];
    NSDate * tmpDate;
    
    if ([mode isEqualToString:@"Swap"]) {
        cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"SwapCell"];
        tmpDate = [df1 dateFromString:[cellArray objectForKey:@"request_date"]];
        cell.Label1.text = [df2 stringFromDate:tmpDate];
        
        cell.Label2.text = [cellArray objectForKey:@"response_user_name"];
        
    }
    else if ([mode isEqualToString:@"Accept"])
    {
        cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"SwapCell"];
        tmpDate = [df1 dateFromString:[cellArray objectForKey:@"request_date"]];
        cell.Label1.text = [df2 stringFromDate:tmpDate];
        
        cell.Label2.text = [cellArray objectForKey:@"request_user_name"];
    }
    
    
    if([[cellArray objectForKey:@"status_text"] isEqualToString:@"รอการตอบรับ"])
    {
        cell.Label3.text = [cellArray objectForKey:@"status_text"];
        cell.Label3.textColor = [UIColor colorWithRed:161.0/255 green:130.0/255 blue:88.0/255 alpha:1];
        cell.actionBtn.hidden = NO;
        cell.dropdownBtn.hidden = NO;
    }
    else if([[cellArray objectForKey:@"status_text"] isEqualToString:@"รออนุมัติ"])
    {
        cell.Label3.text = [cellArray objectForKey:@"status_text"];
        cell.Label3.textColor = [UIColor colorWithRed:161.0/255 green:130.0/255 blue:88.0/255 alpha:1];
        cell.actionBtn.hidden = NO;
        cell.dropdownBtn.hidden = NO;
    }
    else if([[cellArray objectForKey:@"status_text"] isEqualToString:@"อนุมัติ"])
    {
        cell.Label3.text = [cellArray objectForKey:@"status_text"];
        cell.Label3.textColor = [UIColor colorWithRed:49.0/255 green:107.0/255 blue:4.0/255 alpha:1];
        cell.actionBtn.hidden = YES;
        cell.dropdownBtn.hidden = YES;
    }
    else
    {
        cell.Label3.text = @"ไม่อนุมัติ";
        cell.Label3.textColor = delegate.cancelThemeColor;
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
    cell.Label3.font = [UIFont fontWithName:delegate.fontBold size:fontSizeCell];
    cell.Label4.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.actionBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    
    [cell.actionBtn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.actionBtn.tag = indexPath.row;
    
    [cell.dropdownBtn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.dropdownBtn.tag = indexPath.row;
    
    /*
     UIView *bgColorView = [[UIView alloc] init];
     bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];;
     [cell setSelectedBackgroundView:bgColorView];
     */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellArray = [[listJSON objectForKey:@"data"] objectAtIndex:indexPath.row];
    
    [self viewDetailClicked:cellArray];
}


- (void)viewDetailClicked:(NSDictionary*)shiftDetail
{
    ShiftForm *viewController = [[ShiftForm alloc]initWithNibName:@"ShiftForm" bundle:nil];
    viewController.mode = mode;
    viewController.action = @"view";
    viewController.shiftID = [shiftDetail objectForKey:@"id"];
    
    if([[shiftDetail objectForKey:@"status_text"] isEqualToString:@"รอการตอบรับ"])
    {
        viewController.hideBtn = NO;
    }
    else
    {
        viewController.hideBtn = YES;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)addClicked:(id)sender
{
    ShiftForm *viewController = [[ShiftForm alloc]initWithNibName:@"ShiftForm" bundle:nil];
    viewController.mode = mode;
    viewController.action = @"add";
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
