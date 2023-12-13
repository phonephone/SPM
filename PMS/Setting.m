//
//  Setting.m
//  PMS
//
//  Created by Truk Karawawattana on 14/3/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import "Setting.h"
#import "MenuCell.h"
#import "ResetPassword.h"

@interface Setting ()
{
    NSMutableArray *menuArray;
}
@end

@implementation Setting

@synthesize titleLabel,myTable;

- (void)viewWillLayoutSubviews
{
    //[myTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    menuArray = [NSMutableArray arrayWithObjects:
                 //@"ข้อมูลส่วนตัว (User Profile)",
                 @"Change Password",
                 @"Main Tab",
                 //@"การแจ้งเตือน (Notification)",
                 nil];
    //notification_ios
}

- (void)viewDidLayoutSubviews
{
    //Circle
    //companyPic.layer.cornerRadius = companyPic.frame.size.width/2;
    //companyPic.layer.masksToBounds = YES;
    
    //Border
    //profilePic.layer.borderWidth = 3.0f;
    //profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //[myTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    /*
     Navi *navi = (Navi*)[[UIApplication sharedApplication].delegate.window.rootViewController.childViewControllers objectAtIndex:2];
     homePage = (Home*)[navi.childViewControllers objectAtIndex:0];
     
     carbon = [homePage.childViewControllers objectAtIndex:0];
     */
    
    //NSLog(@"count %@",[carbon.viewControllers objectForKey:[NSNumber numberWithInt:0]]);
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    /*
    if ([[menuArray objectAtIndex:section] isEqualToString:@"We Approve"])//จัดการคำขอ
    {
        return YES;
    }
    */
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [menuArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            /*
            if ([[menuArray objectAtIndex:section] isEqualToString:@"We News"]) {//จัดการคำขอ
                return [wenewsArray count]+1;
            }
             */
        }
        return 1; // only top row showing
    }
    // Return the number of rows in other section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    int rowHeight;
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])//Expandable
    {
        if (!indexPath.row)//Main
        {
            rowHeight = (self.view.frame.size.height/18);
        }
        else//Sub
        {
            rowHeight = (self.view.frame.size.height/18);
        }
    }
    else//Can't Expand
    {
        rowHeight = (self.view.frame.size.height/18);
    }
    */
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];;
    //[cell setSelectedBackgroundView:bgColorView];
    
    cell.menuAlert.hidden = YES;
    cell.menuArrow.hidden = YES;
    cell.menuSwitch.hidden = YES;
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])//Expandable
    {
        //cell.menuLabel.text = @"";
        cell.menuArrow.hidden = NO;
        
        if (!indexPath.row)//Main
        {
            if ([expandedSections containsIndex:indexPath.section])//Now Expanded
            {
                cell.menuArrow.transform = CGAffineTransformIdentity;
            }
            else//Not Expanded
            {
                //float degrees = 90; //the value in degrees
                //cell.menuArrow.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
            }
        }
        else//Sub
        {
            cell.menuArrow.hidden = YES;
        }
    }
    else//Can't Expand
    {
        cell.menuLabel.text = [menuArray objectAtIndex:indexPath.section];
        cell.menuArrow.hidden = YES;
        
        if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"Change Password"]){//รายงานการเข้างาน
            cell.menuLabel.text = @"เปลี่ยนรหัสผ่าน (Change Password)";
            cell.menuIcon.image = [UIImage imageNamed:@"menu_padlock"];
            cell.menuArrow.hidden = NO;
        }
        else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"Main Tab"]){
            cell.menuLabel.text = @"หน้าหลักเมนู (ปิด) /\nหน้าหลักเข้างาน (เปิด)";
            cell.menuIcon.image = [UIImage imageNamed:@"setting_home"];
            cell.menuSwitch.hidden = NO;
            
            if (delegate.mainTabStatus)
            {
                cell.menuSwitch.on = YES;
            }
            else
            {
                cell.menuSwitch.on = NO;
            }
            [cell.menuSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        /*
        else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"ข้อมูลส่วนตัว (User Profile)"]) {
            cell.menuIcon.image = [UIImage imageNamed:@"menu_avatar"];
            cell.menuArrow.hidden = NO;
        }
        else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"การแจ้งเตือน (Notification)"]){
            cell.menuIcon.image = [UIImage imageNamed:@"menu_alarm"];
            cell.menuSwitch.hidden = NO;
            
            if ([[delegate.profileJSON objectForKey:@"notification_ios"] isEqualToString:@"1"])
            {
                cell.menuSwitch.on = YES;
            }else
            {
                cell.menuSwitch.on = NO;
            }
            [cell.menuSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        */
    }
    
    /*
    cell.menuAlert.layer.cornerRadius = cell.menuAlert.frame.size.height/2;
    cell.menuAlert.layer.masksToBounds = YES;
    cell.menuAlert.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)//Main Menu Click
        {
            // only first row toggles exapand/collapse
            //[tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
                MenuCell *cell = [myTable cellForRowAtIndexPath:indexPath];
                cell.menuArrow.transform = CGAffineTransformIdentity;
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
                
                float degrees = 90; //the value in degrees
                MenuCell *cell = [myTable cellForRowAtIndexPath:indexPath];
                cell.menuArrow.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
            }
            
            //Table row management
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                [myTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[tableView numberOfRowsInSection:section]-1 inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }
        else//Sub Menu Click
        {
            /*
             if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Approve"]) //จัดการคำขอ
             {
             Approve *ap = [self.storyboard instantiateViewControllerWithIdentifier:@"Approve"];
             ap.mode = [approveArray objectAtIndex:indexPath.row-1];
             [navi pushViewController:ap animated:YES];
             }
             */
            
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            [myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
        }
    }
    
    else // can't collapse
    {
        //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"Change Password"])
        {
            ResetPassword *rsp = [[ResetPassword alloc]initWithNibName:@"ResetPassword" bundle:nil];
            [self.navigationController pushViewController:rsp animated:YES];
        }
        /*
        else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"ข้อมูลส่วนตัว (User Profile)"]) {
            Register *rgt = [self.storyboard instantiateViewControllerWithIdentifier:@"Register"];
            rgt.mode = @"Edit";
            [self.navigationController pushViewController:rgt animated:YES];
        }
        else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"การแจ้งเตือน (Notification)"]){
        }
        */
        [myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
    }
}

- (void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    if (switchControl.on) {
        delegate.mainTabStatus = YES;
        [SVProgressHUD showSuccessWithStatus:@"หน้าหลักเปลี่ยนเป็น\n\"หน้าเข้างาน\""];
    }
    else
    {
        delegate.mainTabStatus = NO;
        [SVProgressHUD showSuccessWithStatus:@"หน้าหลักเปลี่ยนเป็น\n\"หน้าเมนู\""];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:delegate.mainTabStatus forKey:@"mainTabStatus"];
    [ud synchronize];
}

/*
- (void)loadNoti
{
    [SVProgressHUD setContainerView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString* url = [NSString stringWithFormat:@"%@notification_toggle",HOST_DOMAIN];
    
    [Singleton configManager:manager];
    [manager POST:url parameters:parameters headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
        NSLog(@"Noti %@",responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
            
            [SVProgressHUD showSuccessWithStatus:[[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"status"]];
            [SVProgressHUD dismissWithDelay:3];
        }
        else{
        }
    }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
        NSLog(@"Error %@",error);
    }];
}
*/

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

