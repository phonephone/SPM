//
//  LeftMenu.m
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "LeftMenu.h"
#import "MenuCell.h"
#import "Login.h"
#import "UIImageView+WebCache.h"
#import "Tabbar.h"
#import "UserReport.h"
#import "UserProfile.h"
#import "UserAddress.h"
#import "UserBank.h"
#import "UserDocument.h"
#import "ResetPassword.h"
#import "Approve.h"
#import "Web.h"
#import "Leave_Left.h"
#import "WeLearn.h"
#import "Navi.h"

@interface LeftMenu ()
{
    NSMutableArray *menuArray;
}
@end

@implementation LeftMenu

@synthesize companyPic,userName,userDepartment,myTable,versionLabel;

- (void)viewWillLayoutSubviews
{
    [myTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    userName.font = [UIFont fontWithName:delegate.fontMedium size:delegate.fontSize+4];
    userDepartment.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    //NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    versionLabel.text = [NSString stringWithFormat:@"Version: %@",appVersionString];
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    [self updateProfile];
    
    welearnArray = [[NSMutableArray alloc] init];
    werosterArray = [[NSMutableArray alloc] init];
    wenewsArray = [[NSMutableArray alloc] init];
    
    companyPic.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTap)];
    [companyPic addGestureRecognizer:tapGesture];
    picTapCount = 0;
}

- (void)picTap
{
    picTapCount++;
    if (picTapCount >= 5) {
        picTapCount = 0;
        [self logOut];
    }
}

- (void)viewDidLayoutSubviews
{
    //Circle
    //companyPic.layer.cornerRadius = companyPic.frame.size.width/2;
    //companyPic.layer.masksToBounds = YES;
    
    //Border
    //profilePic.layer.borderWidth = 3.0f;
    //profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [myTable reloadData];
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

- (void)updateProfile
{
    [companyPic sd_setImageWithURL:[NSURL URLWithString:delegate.userLogoUrl] placeholderImage:[UIImage imageNamed:@"icon1024.png"]];
    userName.text = delegate.userFullname;
    userDepartment.text = delegate.userDepartment;
}

- (void)checkPermission
{
    [menuArray removeAllObjects];
    menuArray = [NSMutableArray arrayWithObjects:
                 @"We News",
                 @"We Dashboard",
                 @"We Personal",
                 @"We Roster",
                 @"We Approve",
                 //@"We Leave",
                 @"We Plan",
                 @"We Learn",
                 @"We Rewards",
                 @"We Rules",
                 @"We FAQ",
                 @"Change Password",
                 //@"Log Out",
                 nil];
    //[SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    url = [NSString stringWithFormat:@"%@UserAuthorize/%@",delegate.serverURL,delegate.userID];
    
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString *token, NSError *error) {
        if (error != nil) {
            //NSLog(@"Error getting FCM registration token: %@", error);
            
            
        } else {
            //NSLog(@"FCM registration token: %@", token);
            url = [NSString stringWithFormat:@"%@UserAuthorize/%@/%@",delegate.serverURL,delegate.userID,token];
        }
        NSLog(@"Url %@",url);
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
            NSLog(@"Permisson %@",responseObject);
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"fail"])
            {
                [self logOut];
            }
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
                permissionJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
                delegate.userFullname = [permissionJSON objectForKey:@"name"];
                delegate.userDepartment = [permissionJSON objectForKey:@"designation_name"];//[NSString stringWithFormat:@"%@\n%@ %@",[permissionJSON objectForKey:@"designation_name"],[permissionJSON objectForKey:@"department_branch"],[permissionJSON objectForKey:@"department_name"]];
                delegate.userLogoUrl = [permissionJSON objectForKey:@"logo"];
                
                delegate.leaveBtnShow = [[permissionJSON objectForKey:@"leave_request_btn"] boolValue];
                delegate.otBtnShow = [[permissionJSON objectForKey:@"ot_request_btn"] boolValue];
                delegate.wfhBtnShow = [[permissionJSON objectForKey:@"wfh_status"] boolValue];
                
                delegate.userPicURL = [permissionJSON objectForKey:@"photo"];
                
                if([self.menuContainerViewController.centerViewController isKindOfClass:[UITabBarController class]])
                {
                    UITabBarController *tabBarController = (UITabBarController*)self.menuContainerViewController.centerViewController;
                    
                    NSString *tabBadges = [permissionJSON objectForKey:@"switch_shift_response_waiting_list_count"];
                    
                    if ([tabBadges isEqualToString:@"0"]) {
                        
                        [[tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
                    }
                    else
                    {
                        [[tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:tabBadges];
                    }
                }
                
                [UIApplication sharedApplication].applicationIconBadgeNumber = [[permissionJSON objectForKey:@"summary_approve_waiting_list_count"] integerValue];
                
                [self updateProfile];
                
                permission = NO;
                approveArray = [[NSMutableArray alloc] init];
                if ([[permissionJSON objectForKey:@"leave_ot"] isEqualToString:@"1"]) {
                    permission = YES;
                    //[approveArray addObject:@"Leave"];
                    //[approveArray addObject:@"OT"];
                }
                if ([[permissionJSON objectForKey:@"swap_shift_status"] isEqualToString:@"1"]) {
                    permission = YES;
                    [approveArray addObject:@"Swap"];
                    [approveArray addObject:@"Time"];
                    //[approveArray addObject:@"Absence"];
                    //[approveArray addObject:@"Leave_Ahead"];
                }
                
                welearnArray = [[permissionJSON objectForKey:@"we_learn_menu"] mutableCopy];
                werosterArray = [[permissionJSON objectForKey:@"we_roster_menu"] mutableCopy];
                wenewsArray = [[permissionJSON objectForKey:@"we_news_menu"] mutableCopy];
                
                happyPoint = [NSString stringWithFormat:@"(%@ Scores)",[permissionJSON objectForKey:@"reward_point"]];
                
                //Remove Menu
                if ([[permissionJSON objectForKey:@"leave_ot"] isEqualToString:@"0"]&&[[permissionJSON objectForKey:@"swap_shift_status"] isEqualToString:@"0"]) {
                    
                    [self removeMenu:@"We Dashboard"];
                    [self removeMenu:@"We Approve"];
                }
                
                if ([[permissionJSON objectForKey:@"parttime"] isEqualToString:@"1"]) {
                    
                    [self removeMenu:@"We Learn"];
                    [self removeMenu:@"We Rewards"];
                }
                
                [myTable reloadData];
                //[SVProgressHUD dismiss];
            }
            else{
                //[SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
            }
        }
              failure:^(NSURLSessionDataTask *task, NSError *error)
         {
            NSLog(@"Error %@",error);
            //[SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
        }];
    }];
}

- (void)removeMenu:(NSString*)menuName
{
    for (int i = 0; i < [menuArray count]; i++) {
        if ([[menuArray objectAtIndex:i] isEqualToString:menuName]) {
            [menuArray removeObjectAtIndex:i];
        }
    }
    //NSLog(@"%@",menuArray);
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if ([[menuArray objectAtIndex:section] isEqualToString:@"We Approve"] && permission == YES)//จัดการคำขอ
    {
        return YES;
    }
    if ([[menuArray objectAtIndex:section] isEqualToString:@"We News"]||[[menuArray objectAtIndex:section] isEqualToString:@"We Roster"]||[[menuArray objectAtIndex:section] isEqualToString:@"We Learn"]||[[menuArray objectAtIndex:section] isEqualToString:@"We Rewards"])//we learn
    {
        return YES;
    }
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
            if ([[menuArray objectAtIndex:section] isEqualToString:@"We News"]) {//จัดการคำขอ
                return [wenewsArray count]+1;
            }
            if ([[menuArray objectAtIndex:section] isEqualToString:@"We Approve"]) {//จัดการคำขอ
                return [approveArray count]+1;
            }
            if ([[menuArray objectAtIndex:section] isEqualToString:@"We Roster"])//we roster
            {
                return [werosterArray count]+1;
            }
            if ([[menuArray objectAtIndex:section] isEqualToString:@"We Learn"])//we learn
            {
                return [welearnArray count]+1;
            }
            if ([[menuArray objectAtIndex:section] isEqualToString:@"We Rewards"])//we learn
            {
                return 2+1;
            }
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
    return self.view.frame.size.height/17;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];;
    //[cell setSelectedBackgroundView:bgColorView];
    
    cell.menuAlert.hidden = YES;
    cell.scoreLabel.hidden = YES;
    /*
     if ([self tableView:tableView canCollapseSection:indexPath.section])//Expandable
     {
     if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Approve"])
     {
     //cell.backgroundColor = [UIColor colorWithRed:206.0/255 green:206.0/255 blue:206.0/255 alpha:1];
     
     if (indexPath.row == 0) {//การจัดการคำขอ
     cell.menuLabel.text = [menuArray objectAtIndex:indexPath.section];
     bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
     [cell setSelectedBackgroundView:bgColorView];
     }
     else if ([[approveArray objectAtIndex:indexPath.row-1] isEqualToString:@"Leave"]) {
     cell.menuLabel.text = @"   - คำขอลางาน";
     cell.menuAlert.hidden = YES;
     }
     else if ([[approveArray objectAtIndex:indexPath.row-1] isEqualToString:@"OT"]) {
     cell.menuLabel.text = @"   - คำขอชั่วโมงสะสม";
     cell.menuAlert.text = [permissionJSON objectForKey:@"ot_approve_waiting_list_count"];
     cell.menuAlert.hidden = NO;
     }
     else if ([[approveArray objectAtIndex:indexPath.row-1] isEqualToString:@"Swap"]) {
     cell.menuLabel.text = @"   - คำขอแลกเวร";
     cell.menuAlert.text = [permissionJSON objectForKey:@"switch_shift_approve_waiting_list_count"];
     cell.menuAlert.hidden = NO;
     }
     else if ([[approveArray objectAtIndex:indexPath.row-1] isEqualToString:@"Time"]) {
     cell.menuLabel.text = @"   - คำขอปรับเวลา";
     cell.menuAlert.text = [permissionJSON objectForKey:@"adjust_clocktime_approve_waiting_list_count"];
     cell.menuAlert.hidden = NO;
     }
     else if ([[approveArray objectAtIndex:indexPath.row-1] isEqualToString:@"Absence"]) {
     cell.menuLabel.text = @"   - คำขอหยุดงาน";
     cell.menuAlert.text = [permissionJSON objectForKey:@"absence_approve_waiting_list_count"];
     cell.menuAlert.hidden = NO;
     }
     else if ([[approveArray objectAtIndex:indexPath.row-1] isEqualToString:@"Leave_Ahead"]) {
     cell.menuLabel.text = @"   - คำขอหยุดงานล่วงหน้า";
     cell.menuAlert.text = [permissionJSON objectForKey:@"leave_ahead_approve_waiting_list_count"];
     cell.menuAlert.hidden = NO;
     }
     
     if ([cell.menuAlert.text isEqualToString:@"0"]) {
     cell.menuAlert.hidden = YES;
     }
     }
     else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We News"]) {
     
     if (indexPath.row == 0) {
     cell.menuLabel.text = [menuArray objectAtIndex:indexPath.section];
     bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
     [cell setSelectedBackgroundView:bgColorView];
     }
     else
     {
     cell.menuLabel.text = [NSString stringWithFormat:@"   - %@",[[wenewsArray objectAtIndex:indexPath.row-1] objectForKey:@"topic"]];
     }
     }
     else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Roster"]) {
     
     if (indexPath.row == 0) {
     cell.menuLabel.text = [menuArray objectAtIndex:indexPath.section];
     bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
     [cell setSelectedBackgroundView:bgColorView];
     }
     else
     {
     cell.menuLabel.text = [NSString stringWithFormat:@"   - %@",[[werosterArray objectAtIndex:indexPath.row-1] objectForKey:@"department_code"]];
     }
     }
     else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Learn"]) {
     
     if (indexPath.row == 0) {
     cell.menuLabel.text = [menuArray objectAtIndex:indexPath.section];
     bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
     [cell setSelectedBackgroundView:bgColorView];
     }
     else
     {
     cell.menuLabel.text = [NSString stringWithFormat:@"   - %@",[[welearnArray objectAtIndex:indexPath.row-1] objectForKey:@"topic"]];
     }
     }
     else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Rewards"]) {
     
     if (indexPath.row == 0) {
     cell.menuLabel.text = [menuArray objectAtIndex:indexPath.section];
     bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
     [cell setSelectedBackgroundView:bgColorView];
     //cell.scoreLabel.hidden = NO;
     //cell.scoreLabel.text = happyPoint;
     }
     else if (indexPath.row == 1)
     {
     cell.menuLabel.text = @"   - Happy Any day";
     }
     else if (indexPath.row == 2)
     {
     cell.menuLabel.text = @"   - Happy Rewards";
     }
     }
     
     cell.menuLabel.font = [UIFont fontWithName:delegate.fontLight size:delegate.fontSize+2];
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
     cell.menuLabel.font = [UIFont fontWithName:delegate.fontLight size:delegate.fontSize+2];
     cell.menuArrow.hidden = YES;
     }
     }
     else//Can't Expand
     {
     cell.menuLabel.text = [menuArray objectAtIndex:indexPath.section];
     
     cell.menuLabel.font = [UIFont fontWithName:delegate.fontLight size:delegate.fontSize+2];
     cell.scoreLabel.font = [UIFont fontWithName:delegate.fontLight size:delegate.fontSize+2];
     cell.menuArrow.hidden = YES;
     }
     
     cell.menuAlert.layer.cornerRadius = cell.menuAlert.frame.size.height/2;
     cell.menuAlert.layer.masksToBounds = YES;
     cell.menuAlert.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
     */
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Tabbar *tab = (Tabbar*)[[UIApplication sharedApplication].delegate.window.rootViewController.childViewControllers objectAtIndex:1];
    //Navi *navi = tab.selectedViewController;// [tab.childViewControllers objectAtIndex:1];
    UINavigationController *navi = self.navigationController;
    
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
            if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Approve"]) //จัดการคำขอ
            {
                Approve *ap = [self.storyboard instantiateViewControllerWithIdentifier:@"Approve"];
                ap.mode = [approveArray objectAtIndex:indexPath.row-1];
                [navi pushViewController:ap animated:YES];
            }
            else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We News"]) {//we learn
                Web *web = [[Web alloc]initWithNibName:@"Web" bundle:nil];
                web.urlStr = [[wenewsArray objectAtIndex:indexPath.row-1] objectForKey:@"news_url"];
                web.titleStr = @"We News";
                
                [navi pushViewController:web animated:YES];
            }
            else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Roster"]) {//we learn
                WeLearn *wl = [self.storyboard instantiateViewControllerWithIdentifier:@"WeLearn"];
                wl.mode = @"We Roster";
                wl.weRosterArray = [[werosterArray objectAtIndex:indexPath.row-1] mutableCopy];
                
                [navi pushViewController:wl animated:YES];
            }
            else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Learn"]) {//we learn
                WeLearn *wl = [self.storyboard instantiateViewControllerWithIdentifier:@"WeLearn"];
                wl.mode = @"We Learn";
                wl.weLearnID = [[welearnArray objectAtIndex:indexPath.row-1] objectForKey:@"id"];
                
                [navi pushViewController:wl animated:YES];
            }
            else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Rewards"]) {//Happy Reward
                Web *web = [[Web alloc]initWithNibName:@"Web" bundle:nil];
                if (indexPath.row ==1) {
                    web.urlStr = [permissionJSON objectForKey:@"happy_anyday_url"];
                    web.titleStr = @"Happy Any Day";
                }
                else if (indexPath.row ==2) {
                    web.urlStr = [permissionJSON objectForKey:@"happy_reward_url"];
                    web.titleStr = @"Happy Rewards";
                }
                [navi pushViewController:web animated:YES];
            }
            
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            [myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
        }
    }
    
    else // can't collapse
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Dashboard"]) {//Dashboard
            Web *web = [[Web alloc]initWithNibName:@"Web" bundle:nil];
            web.urlStr = [permissionJSON objectForKey:@"dashboard_url"];
            web.titleStr = @"We Dashboard";
            [navi pushViewController:web animated:YES];
        }
        else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Personal"]){//รายงานการเข้างาน
            viewController = [[UserProfile alloc]initWithNibName:@"UserProfile" bundle:nil];
            [navi pushViewController:viewController animated:YES];
        }
        else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Leave"]) {//ลางาน
            Leave_Left *lf = [storyboard instantiateViewControllerWithIdentifier:@"Leave_Left"];
            lf.mode = @"Leave";
            [navi pushViewController:lf animated:YES];
        }
        else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Plan"]) {//ขอหยุดล่วงหน้า
            Leave_Left *lf = [storyboard instantiateViewControllerWithIdentifier:@"Leave_Left"];
            lf.mode = @"Leave_Ahead";
            [navi pushViewController:lf animated:YES];
        }
        /*
         else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Rewards"]) {//Happy Reward
         NSString *customURL = @"happyReward://";
         UIApplication *application = [UIApplication sharedApplication];
         NSURL *URL = [NSURL URLWithString:@"happyReward://"];
         if ([application respondsToSelector:@selector(openURL:options:completionHandler:)])
         {
         if (@available(iOS 10.0, *)) {
         [application openURL:URL options:@{}
         completionHandler:^(BOOL success) {
         NSLog(@"Open %@: %d",customURL,success);
         
         if (!success) {
         //[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://www.google.com"]];
         [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1482085331"]];
         }
         }];
         } else {
         // Fallback on earlier versions
         }
         }
         else {
         
         }
         }
         */
        else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We Rules"]) {//ตารางเวร
            Web *web = [[Web alloc]initWithNibName:@"Web" bundle:nil];
            web.urlStr = @"We Rules";
            web.titleStr = web.urlStr;
            [navi pushViewController:web animated:YES];
            
        }
        else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"We FAQ"]) {//ตารางเวร
            Web *web = [[Web alloc]initWithNibName:@"Web" bundle:nil];
            web.urlStr = @"We FAQ";
            web.titleStr = web.urlStr;
            [navi pushViewController:web animated:YES];
            
        }
        else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"Change Password"]) {//เปลี่ยนรหัสผ่าน
            viewController = [[ResetPassword alloc]initWithNibName:@"ResetPassword" bundle:nil];
            [navi pushViewController:viewController animated:YES];
        }
        else if ([[menuArray objectAtIndex:indexPath.section] isEqualToString:@"Log Out"]){//ออกจากระบบ
            [self logOut];
        }
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
    }
}

-(void)logOut
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    delegate.loginStatus = NO;
    delegate.userID = @"";
    delegate.adminID = @"";
    delegate.userLogoUrl = @"";
    delegate.userFullname = @"";
    
    [ud setBool:delegate.loginStatus forKey:@"loginStatus"];
    [ud setObject:delegate.userID forKey:@"userID"];
    [ud setObject:delegate.adminID forKey:@"adminID"];
    //[ud setObject:delegate.userLogoUrl forKey:@"userLogoUrl"];
    //[ud setObject:delegate.userFullname forKey:@"userFullname"];
    [ud synchronize];
    
    Login *log = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.menuContainerViewController setCenterViewController:log];
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (void)clearToken
{
    /*
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     NSString* url = [NSString stringWithFormat:@"%@logout",delegate.serverURL];
     NSDictionary *parameters = @{@"userEmail":delegate.memberEmail
     };
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
     [manager GET:url parameters:parameters headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
     //NSLog(@"logoutJSON %@",responseObject);
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
     NSLog(@"Error %@",error);
     }];
     */
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
