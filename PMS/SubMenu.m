//
//  SubMenu.m
//  PMS
//
//  Created by Truk Karawawattana on 29/1/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import "SubMenu.h"
#import "MenuCell.h"
#import "Tabbar.h"
#import "Navi.h"
#import "Web.h"
#import "Approve.h"
#import "WeLearn.h"
#import "ActivityList.h"

@interface SubMenu ()

@end

@implementation SubMenu

@synthesize mainMenuID,subMenuTitle,subArray,myTable,titleLabel;

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSLog(@"SUB %@",subArray);
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.text = subMenuTitle;
    
    myTable.delegate = self;
    myTable.dataSource = self;
    
    rowHeight = 60;
    [myTable setContentInset:UIEdgeInsetsMake(20, 0, 20, 0)]; // top, left, bottom, right
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return subArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    cell.menuCellBg.layer.borderColor = [delegate.mainThemeColor2 CGColor];
    cell.menuCellBg.layer.borderWidth = 1;
    cell.menuCellBg.layer.cornerRadius = (rowHeight-5)/2;
    cell.menuCellBg.layer.masksToBounds = YES;
    
    NSDictionary *cellArray = [subArray objectAtIndex:indexPath.row];
    
    cell.menuTitle.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    
    if ([[cellArray objectForKey:@"notification"] intValue] > 0) {
        cell.menuAlert.hidden = NO;
    }
    else{
        cell.menuAlert.hidden = YES;
    }
    
    if ([mainMenuID isEqualToString:@"2"]) {//We News
        cell.menuTitle.text = [cellArray objectForKey:@"topic"];
        cell.menuPic.image = [UIImage imageNamed:@"menu_s_news"];
    }
    else if ([mainMenuID isEqualToString:@"4"]) {//We Roster
        cell.menuTitle.text = [cellArray objectForKey:@"department_code"];
        cell.menuPic.image = [UIImage imageNamed:@"menu_s_roster"];
    }
    else if ([mainMenuID isEqualToString:@"6"]) {//We Learn
        cell.menuTitle.text = [cellArray objectForKey:@"topic"];
        cell.menuPic.image = [UIImage imageNamed:@"menu_s_learn"];
    }
    else if ([mainMenuID isEqualToString:@"11"]) {//We Approve
        cell.menuTitle.text = [cellArray objectForKey:@"topic"];
        cell.menuPic.image = [UIImage imageNamed:@"menu_s_approve"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Tabbar *tab = (Tabbar*)[[UIApplication sharedApplication].delegate.window.rootViewController.childViewControllers objectAtIndex:1];
    //Navi *navi = tab.selectedViewController;
    UINavigationController *navi = self.navigationController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    NSDictionary *cellArray = [subArray objectAtIndex:indexPath.row];
    NSString* menuName = [cellArray objectForKey:@"topic"];
    
    Web *web = [[Web alloc]initWithNibName:@"Web" bundle:nil];
    
    if ([mainMenuID isEqualToString:@"2"]) {//We News
        if ([[cellArray objectForKey:@"sub_menu_id"] isEqualToString:@"3"]) {//Activities
            ActivityList *atv = [storyboard instantiateViewControllerWithIdentifier:@"ActivityList"];
            [navi pushViewController:atv animated:YES];
        }
        else{
            web.urlStr = [cellArray objectForKey:@"news_url"];
            web.titleStr = menuName;
            [navi pushViewController:web animated:YES];
        }
    }
    else if ([mainMenuID isEqualToString:@"4"]) {//We Roster
        WeLearn *wl = [self.storyboard instantiateViewControllerWithIdentifier:@"WeLearn"];
        wl.mode = @"We Roster";
        wl.titleStr = [cellArray objectForKey:@"department_code"];
        wl.weRosterArray = [cellArray mutableCopy];
        [navi pushViewController:wl animated:YES];
    }
    else if ([mainMenuID isEqualToString:@"6"]) {//We Learn
        
        NSDictionary *weLearnArray = [subArray objectAtIndex:indexPath.row];
        if ([[cellArray objectForKey:@"topic"] isEqualToString:@"Nurse Soulciety"]) {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:[weLearnArray objectForKey:@"news_url"]] options:@{} completionHandler:nil];
        }
        else {
            web.urlStr = [cellArray objectForKey:@"news_url"];
            web.titleStr = menuName;
            [navi pushViewController:web animated:YES];
        }
        
        /*
        WeLearn *wl = [self.storyboard instantiateViewControllerWithIdentifier:@"WeLearn"];
        wl.mode = @"We Learn";
        wl.titleStr = menuName;
        wl.weLearnID = [cellArray objectForKey:@"id"];
        [navi pushViewController:wl animated:YES];
        */
    }
    else if ([mainMenuID isEqualToString:@"7"]) {//We Rewards
        web.urlStr = [cellArray objectForKey:@"url"];
        web.titleStr = menuName;
        [navi pushViewController:web animated:YES];
    }
    else if ([mainMenuID isEqualToString:@"8"]) {//We Activities
        
    }
    else if ([mainMenuID isEqualToString:@"11"]) {//We Approve
        if ([[cellArray objectForKey:@"sub_menu_id"] isEqualToString:@"1"]) {//คำขอแลกเวร
            Approve *ap = [self.storyboard instantiateViewControllerWithIdentifier:@"Approve"];
            ap.mode = @"Swap";
            [navi pushViewController:ap animated:YES];
        }
        else if ([[cellArray objectForKey:@"sub_menu_id"] isEqualToString:@"2"]) {//คำขอปรับเวลา
            Approve *ap = [self.storyboard instantiateViewControllerWithIdentifier:@"Approve"];
            ap.mode = @"Time";
            [navi pushViewController:ap animated:YES];
        }
    }
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
