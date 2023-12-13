//
//  MainMenu.m
//  PMS
//
//  Created by Truk Karawawattana on 29/1/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import "MainMenu.h"
#import "MainMenuCell.h"
#import "SubMenu.h"
#import "Login.h"
#import "Tabbar.h"
#import "Web.h"
#import "Profile.h"
#import "Setting.h"
#import "Approve.h"
#import "Leave_Left.h"
#import "WeLearn.h"
#import "RewardList.h"
#import "ActivityList.h"
#import "Agenda.h"
#import "ChatRoom.h"
#import "Navi.h"
#import "SDWebImage.h"

@interface MainMenu ()

@end

@implementation MainMenu

@synthesize myCollection,headerView,titleLabel,versionLabel,rightMenu,bannerView,bannerScroll,pageControl,versionBottomHeight;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    [self loadMenu];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    versionLabel.text = [NSString stringWithFormat:@"Version: %@ (%@)",appVersionString,appBuildString];
    versionLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    versionBottomHeight.constant = self.tabBarController.tabBar.frame.size.height+3;
    versionLabel.textColor = [UIColor grayColor];
    versionLabel.hidden = YES;
    
    rightMenu.layer.borderColor = [[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1] CGColor];
    rightMenu.layer.borderWidth = 1;
    rightMenu.layer.cornerRadius = rightMenu.frame.size.height/2;
    rightMenu.layer.masksToBounds = YES;
    
    bannerScroll.tag = 1;
    
    [myCollection setDataSource:self];
    [myCollection setDelegate:self];
    myCollection.tag = 2;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(10, 10)];
    flowLayout.minimumInteritemSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [myCollection setCollectionViewLayout:flowLayout];
    
//    headerView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tapGesture =
//    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTap)];
//    [headerView addGestureRecognizer:tapGesture];
//    picTapCount = 0;
}

- (void)picTap
{
    picTapCount++;
    if (picTapCount >= 5) {
        picTapCount = 0;
        [self logOut];
    }
}

- (void)reloadMainMenu
{
    [self loadMenu];
}

- (void)loadMenu
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    url = [NSString stringWithFormat:@"%@UserAuthorize/%@",delegate.serverURL,delegate.userID];
    
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString *token, NSError *error) {
        if (error != nil) {
            //NSLog(@"Error getting FCM registration token: %@", error);
            
            
        } else {
            //NSLog(@"FCM registration token: %@", token);
            url = [NSString stringWithFormat:@"%@UserAuthorize/%@/%@",delegate.serverURL,delegate.userID,token];
        }
        //NSLog(@"Url %@",url);
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
            NSLog(@"authorizeJSON %@",responseObject);
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"fail"])
            {
                [self logOut];
            }
            else if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
            {
                authorizeJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
                [self loadBanner];
                
                failCount = 0;
                [self performSelector:@selector(checkOfflineClockJSONFile) withObject:self afterDelay:0.0 ];
                
                delegate.userFullname = [authorizeJSON objectForKey:@"name"];
                delegate.userDepartment = [authorizeJSON objectForKey:@"designation_name"];
                delegate.userLogoUrl = [authorizeJSON objectForKey:@"logo"];
                
                delegate.leaveBtnShow = [[authorizeJSON objectForKey:@"leave_request_btn"] boolValue];
                delegate.otBtnShow = [[authorizeJSON objectForKey:@"ot_request_btn"] boolValue];
                delegate.wfhBtnShow = [[authorizeJSON objectForKey:@"wfh_status"] boolValue];
                
                delegate.userPicURL = [authorizeJSON objectForKey:@"photo"];
                
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[authorizeJSON objectForKey:@"photo"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if (image && finished) {
                        [rightMenu setImage:[delegate imageByCroppingImage:image toSize:CGSizeMake(image.size.width, image.size.width)] forState:UIControlStateNormal];
                    }}];
                
                if([self.menuContainerViewController.centerViewController isKindOfClass:[UITabBarController class]])
                {
                    UITabBarController *tabBarController = (UITabBarController*)self.menuContainerViewController.centerViewController;
                    
                    NSString *tabBadges = [authorizeJSON objectForKey:@"switch_shift_response_waiting_list_count"];
                    
                    if ([tabBadges isEqualToString:@"0"]) {
                        
                        [[tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
                    }
                    else
                    {
                        [[tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:tabBadges];
                    }
                }
                
                [UIApplication sharedApplication].applicationIconBadgeNumber = [[authorizeJSON objectForKey:@"summary_approve_waiting_list_count"] integerValue];
                
                
                [myCollection reloadData];
                [myCollection performBatchUpdates:^{}
                                       completion:^(BOOL finished) {
                    if (myCollection.frame.size.height >= myCollection.contentSize.height+50) {
                        versionLabel.hidden = NO;
                    }
                    
                }];
                
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

- (void)loadBanner
{
    [bannerTimer invalidate];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url2 = [authorizeJSON objectForKey:@"banner_full_url"];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url2 parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
        //(@"bannerJSON %@",responseObject);
        bannerJSON = [responseObject objectForKey:@"data"];
        
        long bannerCount = [bannerJSON count];
        
        int bannerWidth = bannerScroll.frame.size.width;
        int bannerHeight = bannerScroll.frame.size.height;
        [bannerScroll setContentSize: CGSizeMake(bannerCount*bannerWidth ,bannerHeight)];
        [bannerScroll setPagingEnabled : YES];
        bannerScroll.delegate = self;
        
        pageControl.numberOfPages = bannerCount;
        
        for( int i = 0; i < bannerCount; i++)
        {
            UIButton *bannerBtn = [[UIButton alloc] initWithFrame:CGRectMake(i*bannerWidth,0,bannerWidth,bannerHeight)];
            [bannerBtn.imageView setContentMode: UIViewContentModeScaleAspectFill];
            
            [bannerBtn sd_setImageWithURL:[NSURL URLWithString:[[bannerJSON objectAtIndex:i] objectForKey:@"cover_img"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo_square.png"] options:SDWebImageFromLoaderOnly];
            
            bannerBtn.tag = i;
            [bannerBtn addTarget:self action:@selector(bannerClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [bannerScroll addSubview:bannerBtn];
            
            /*
             UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*bannerWidth,0,bannerWidth,bannerHeight)];
             [imgView sd_setImageWithURL:[NSURL URLWithString:[[bannerJSON objectAtIndex:i] objectForKey:@"cover_img"]] placeholderImage:[UIImage imageNamed:@"logo_square.png"]];
             imgView.tag = i;
             [bannerScroll addSubview:imgView];
             */
        }
        
        bannerTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changePage:) userInfo:nil repeats:YES];
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
        NSLog(@"Error %@",error);
        //[SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1) {//Banner
        CGFloat pageWidth = bannerScroll.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = bannerScroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        pageControl.currentPage = page;
    }
    else if (scrollView.tag == 2) {//Menu
        
        CGFloat bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height-50+10;
        /*
         NSLog(@"Offset %f",scrollView.contentOffset.y);
         NSLog(@"height %f",scrollView.frame.size.height);
         NSLog(@"Bottom %f",bottomEdge);
         NSLog(@"Content %f",scrollView.contentSize.height);
         */
        if (bottomEdge >= scrollView.contentSize.height)
        {
            versionLabel.hidden = NO;
        }
        else{
            versionLabel.hidden = YES;
        }
    }
}

- (IBAction)changePage:(id)sender {
    NSInteger currentPage = pageControl.currentPage;
    currentPage++;
    if (currentPage > pageControl.numberOfPages-1) {
        currentPage = 0;
    }
    CGFloat x = currentPage * bannerScroll.frame.size.width;
    [bannerScroll setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (IBAction)bannerClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"Click %ld",button.tag);
    
    //Tabbar *tab = (Tabbar*)[[UIApplication sharedApplication].delegate.window.rootViewController.childViewControllers objectAtIndex:1];
    //Navi *navi = tab.selectedViewController;
    UINavigationController *navi = self.navigationController;
    
    Web *web = [[Web alloc]initWithNibName:@"Web" bundle:nil];
    web.urlStr = [[bannerJSON objectAtIndex:button.tag] objectForKey:@"url"];
    web.titleStr = [[bannerJSON objectAtIndex:button.tag] objectForKey:@"title"];
    [navi pushViewController:web animated:YES];
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}


#pragma mark - COLLECTIONVIEW
#pragma mark Collection View CODE

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[authorizeJSON objectForKey:@"new_main_menu"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainMenuCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MainMenuCell" forIndexPath:indexPath];
    
    NSDictionary *cellArray = [[authorizeJSON objectForKey:@"new_main_menu"] objectAtIndex:indexPath.item];
    
    cell.menuPic.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%@",[cellArray objectForKey:@"icon_image"]]];
    cell.menuTitle.text = [cellArray objectForKey:@"icon_name"];
    
    if ([[cellArray objectForKey:@"notification"] intValue] > 0) {
        cell.menuAlert.hidden = NO;
    }
    else{
        cell.menuAlert.hidden = YES;
    }
    
    //cell.backgroundColor = [UIColor greenColor];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Tabbar *tab = (Tabbar*)[[UIApplication sharedApplication].delegate.window.rootViewController.childViewControllers objectAtIndex:1];
    //Navi *navi = tab.selectedViewController;
    UINavigationController *navi = self.navigationController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    NSDictionary *cellArray = [[authorizeJSON objectForKey:@"new_main_menu"] objectAtIndex:indexPath.item];
    NSString* menuID = [cellArray objectForKey:@"menu_id"];
    NSString* menuName = [cellArray objectForKey:@"icon_name"];
    
    Web *web = [[Web alloc]initWithNibName:@"Web" bundle:nil];
    
    SubMenu *sub = [storyboard instantiateViewControllerWithIdentifier:@"SubMenu"];
    
    UIViewController *viewController;
    
    if ([menuID isEqualToString:@"1"]) {//We Dashboard
        web.urlStr = [authorizeJSON objectForKey:@"dashboard_url"];
        web.titleStr = menuName;
        web.menuID = menuID;
        [navi pushViewController:web animated:YES];
    }
    else if ([menuID isEqualToString:@"2"]) {//We News
        sub.subArray = [cellArray objectForKey:@"sub_menu"];
        sub.subMenuTitle = menuName;
        sub.mainMenuID = menuID;
        [navi pushViewController:sub animated:YES];
    }
    else if ([menuID isEqualToString:@"3"]) {//We Personal
        viewController = [[Profile alloc]initWithNibName:@"Profile" bundle:nil];
        [navi pushViewController:viewController animated:YES];
    }
    else if ([menuID isEqualToString:@"4"]) {//We Roster
        sub.subArray = [cellArray objectForKey:@"sub_menu"];
        sub.subMenuTitle = menuName;
        sub.mainMenuID = menuID;
        [navi pushViewController:sub animated:YES];
    }
    else if ([menuID isEqualToString:@"5"]) {//We Plan
        Leave_Left *lf = [storyboard instantiateViewControllerWithIdentifier:@"Leave_Left"];
        lf.mode = @"Leave_Ahead";
        [navi pushViewController:lf animated:YES];
    }
    else if ([menuID isEqualToString:@"6"]) {//We Learn
        sub.subArray = [cellArray objectForKey:@"sub_menu"];
        sub.subMenuTitle = menuName;
        sub.mainMenuID = menuID;
        [navi pushViewController:sub animated:YES];
    }
    else if ([menuID isEqualToString:@"7"]) {//We Rewards
        RewardList *rwl = [storyboard instantiateViewControllerWithIdentifier:@"RewardList"];
        [navi pushViewController:rwl animated:YES];
    }
    else if ([menuID isEqualToString:@"8"]) {//We Activities
        ActivityList *atv = [storyboard instantiateViewControllerWithIdentifier:@"ActivityList"];
        [navi pushViewController:atv animated:YES];
    }
    else if ([menuID isEqualToString:@"9"]) {//We Rules
        web.urlStr = [cellArray objectForKey:@"url_link"];
        web.titleStr = menuName;
        [navi pushViewController:web animated:YES];
    }
    else if ([menuID isEqualToString:@"10"]) {//We FAQ
        web.urlStr = [cellArray objectForKey:@"url_link"];//[NSString stringWithFormat:@"%@we_faq.pdf",delegate.serverURLshort];
        web.titleStr = menuName;
        [navi pushViewController:web animated:YES];
    }
    else if ([menuID isEqualToString:@"11"]) {//We Approve
        sub.subArray = [cellArray objectForKey:@"sub_menu"];
        sub.subMenuTitle = menuName;
        sub.mainMenuID = menuID;
        [navi pushViewController:sub animated:YES];
    }
    else if ([menuID isEqualToString:@"12"]) {//Setting
        Setting *st = [storyboard instantiateViewControllerWithIdentifier:@"Setting"];
        [navi pushViewController:st animated:YES];
    }
    else if ([menuID isEqualToString:@"13"]) {//We Chat
        ChatRoom *cr = [storyboard instantiateViewControllerWithIdentifier:@"ChatRoom"];
        cr.fromID = delegate.userID;
        [navi pushViewController:cr animated:YES];
    }
    else if ([menuID isEqualToString:@"14"]) {//We Happy
        web.urlStr = [cellArray objectForKey:@"url_link"];
        web.titleStr = menuName;
        [navi pushViewController:web animated:YES];
    }
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    float collectionWidth = myCollection.frame.size.width-40;
    float itemWidth = collectionWidth/3.1;
    float itemHeight = itemWidth*0.9;
    mElementSize=CGSizeMake(itemWidth, itemHeight);
    return mElementSize;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return myCollection.frame.size.height/35;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,20,40,20);  // top, left, bottom, right
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
    
    if ([[authorizeJSON objectForKey:@"leave_ot"] isEqualToString:@"1"]&&[[authorizeJSON objectForKey:@"swap_shift_status"] isEqualToString:@"1"]) {
        pf.givePointStatus = YES;
    }
    else
    {
        pf.givePointStatus = NO;
    }
    
    [self.navigationController pushViewController:pf animated:YES];
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

#pragma mark - OFFLINE Clock Upload
- (void)checkOfflineClockJSONFile
{
    [self JSONFromFile:^{
        //NSLog(@"offlineJSON %@",offlineJSON);
        
        if (offlineJSON.count > 0)
        {
            [SVProgressHUD showWithStatus:@"Uploading Offline Clock Data\nกรุณารอสักครู่"];
            [self uploadClockWithArray:[offlineJSON objectAtIndex:0]];
        }
        else{
            [SVProgressHUD dismiss];
        }
    }];
    
    /*
     for (id myArrayElement in offlineJSON) {
     NSLog(@"AAAAAAAAA %@",myArrayElement);
     }
     */
}

- (void)JSONFromFile:(void(^)(void))complete
{
    filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    fileName = @"offline.json";
    fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        NSLog(@"อ่าน ไม่เจอไม่ต้องอัพโหลด");
    }
    else
    {
        NSLog(@"อ่าน เจอเริ่มอัพโหลด");
        NSData *data = [NSData dataWithContentsOfFile:fileAtPath];
        offlineJSON = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] mutableCopy];
    }
    complete();
}

- (void)writeToJSON:(void(^)(void))complete
{
    NSData* data = [NSJSONSerialization dataWithJSONObject:offlineJSON
                                                   options:kNilOptions
                                                     error:nil];
    [data writeToFile:fileAtPath atomically:YES];
    complete();
}

- (void)deleteFromJSON:(void(^)(void))complete
{
    if (offlineJSON.count > 0) {
        //[offlineJSON removeLastObject];
        [offlineJSON removeObjectAtIndex:0];
    }
    
    [self writeToJSON:^{
        [self JSONFromFile:^{
            NSLog(@"afterDeleteJSON %@",offlineJSON);
        }];
    }];
    complete();
}

- (void)uploadClockWithArray:(NSMutableDictionary *)uploadJSON
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString * UUID =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString* url = [NSString stringWithFormat:@"%@clockInClockOutDataOffline/%@/%@/%@/%@/%@/%@/%@/%@/%@",delegate.serverURL,uploadJSON[@"userID"],uploadJSON[@"date"],uploadJSON[@"time"],uploadJSON[@"type"],@"0",@"0",UUID,uploadJSON[@"QR"],uploadJSON[@"internetStatus"]];
    
    NSLog(@"URL = %@\n\n",url);
    
    /*
     failCount++;
     if (failCount < 10) {
     [self deleteFromJSON:^{
     [self performSelector:@selector(checkOfflineClockJSONFile) withObject:self afterDelay:2.0 ];
     }];
     }
     else
     {
     //Fail > 5
     [SVProgressHUD dismiss];
     }
     */
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
        NSLog(@"ClockOfflineJSON %@",responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
            [self deleteFromJSON:^{
                [self performSelector:@selector(checkOfflineClockJSONFile) withObject:self afterDelay:0];
            }];
        }
        else{
            failCount++;
            if (failCount < 5) {
                [self performSelector:@selector(checkOfflineClockJSONFile) withObject:self afterDelay:2.0];
            }
            else//Fail > 5
            {
                [SVProgressHUD dismiss];
            }
            //[SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
        }
    }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
        NSLog(@"Error %@",error);
        failCount++;
        if (failCount < 5) {
            [self performSelector:@selector(checkOfflineClockJSONFile) withObject:self afterDelay:2.0 ];
        }
        else//Fail > 5
        {
            [SVProgressHUD dismiss];
        }
        //[SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
    }];
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
