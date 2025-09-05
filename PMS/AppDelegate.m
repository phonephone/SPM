//
//  AppDelegate.m
//  Mangkud
//
//  Created by Firststep Consulting on 21/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "AppDelegate.h"
#import <Photos/Photos.h>
#import "CheckInOut.h"
#import "Leave.h"
#import "Shift.h"
#import "MainMenu.h"
#import "Offline.h"
#import "Navi.h"
#import "Tabbar.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

@synthesize fontSize,fontRegular,fontLight,fontMedium,fontSemibold,fontBold,mainThemeColor,mainThemeColor2,cancelThemeColor;

@synthesize loginStatus,mainTabStatus,userID,adminID,userFullname,userLogoUrl,userDepartment,serverURL,serverURLshort,offlineBtnStatus,leaveBtnShow,otBtnShow,wfhBtnShow,heroURL,heroURLshort;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;
    
    if ([UNUserNotificationCenter class] != nil) {
      // iOS 10 or later
      // For iOS 10 display notification (sent via APNS)
      [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
          UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
      [[UNUserNotificationCenter currentNotificationCenter]
          requestAuthorizationWithOptions:authOptions
          completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // ...
          }];
    } else {
      // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        /*
      UIUserNotificationType allNotificationTypes =
      (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
      UIUserNotificationSettings *settings =
      [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
      [application registerUserNotificationSettings:settings];
         */
    }

    [application registerForRemoteNotifications];
    
    [self needsUpdate];
    
    localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setLocale:localeEN];
    
    NSDictionary *keysDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"keys" ofType:@"plist"]];
    [GMSPlacesClient provideAPIKey:[keysDict objectForKey:@"GMSPlace_provideAPIKey"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"th", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    loginStatus = [ud boolForKey:@"loginStatus"];
    userID = [ud objectForKey:@"userID"];
    adminID = [ud objectForKey:@"adminID"];
    mainTabStatus = [ud boolForKey:@"mainTabStatus"];

    serverURLshort = @"http://m.mangkud.co/";
    serverURL = @"http://m.mangkud.co/index.php?MobileApi/";
    
    heroURLshort = @"http://spm-hero.mangkud.co/";
    heroURL = @"http://spm-hero.mangkud.co/api/";
    
    //loginStatus = YES;
    //userID = @"87";// พี่เก่ง รหัสพยาบาล 151589
    
    mainThemeColor = [UIColor colorWithRed:0.0/255 green:70.0/255 blue:42.0/255 alpha:1];
    mainThemeColor2 = [UIColor colorWithRed:178.0/255 green:143.0/255 blue:80.0/255 alpha:1];
    cancelThemeColor = [UIColor colorWithRed:194.0/255 green:56.0/255 blue:37.0/255 alpha:1];
    
    fontRegular = @"Kanit-Regular";
    fontLight = @"Kanit-Light";
    fontMedium = @"Kanit-Medium";
    fontSemibold = @"Kanit-SemiBold";
    fontBold = @"Kanit-Bold";
    
    [SVProgressHUD setBorderColor:[UIColor lightGrayColor]];
    [SVProgressHUD setBorderWidth:1.0];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];//Disable Touch
    [SVProgressHUD setMaximumDismissTimeInterval:2.0];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(handleNetworkChange:) name:kReachabilityChangedNotification object: nil];
    [self checkServer];//อย่าลืมเปิด
    
    sleep(2);
    return YES;
}

- (void)checkInternet
{
    internetReach = [Reachability reachabilityForInternetConnection];
    //[internetReach startNotifier];

    /*
    NetworkStatus internetStatus = [internetReach currentReachabilityStatus];
    if(internetStatus == NotReachable)
    {
        NSLog(@"No Internet");
        onlineStatus = NO;
        [self setUpRootOffline:YES withStatus:@"2"];//2 = ไม่มีเนต
    }
    else if (internetStatus == ReachableViaWiFi||internetStatus == ReachableViaWWAN)
    {
        NSLog(@"Wifi or Cell");
        onlineStatus = YES;
    }
    */
    [self checkServer];
}

- (void)checkServer
{
    if (!firstTime) {
        firstTime = YES;
        
        Reachability *serverReach = [Reachability reachabilityWithHostname:@"m.mangkud.co"];
        
        // Web is reachable
        serverReach.reachableBlock = ^(Reachability*reach)
        {
            // Update the UI on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Server ปกติ");
                
                if (!serverNormal) {
                    //NSLog(@"XXX");
                    offlineStatus = NO;
                    serverNormal = YES;
                    serverDown = NO;
                    [self setUpRootOffline:NO withStatus:@""];
                }
            });
        };

        // Web is not reachable
        serverReach.unreachableBlock = ^(Reachability*reach)
        {
            // Update the UI on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Server เข้าไม่ได้");
                
                internetReach = [Reachability reachabilityForInternetConnection];
                NetworkStatus remoteInternetStatus = [internetReach currentReachabilityStatus];
                if(remoteInternetStatus == NotReachable)
                {
                    //NSLog(@"ไม่มีเนต");
                    if (!offlineStatus) {
                        //NSLog(@"YYY");
                        offlineStatus = YES;
                        serverNormal = NO;
                        serverDown = NO;
                        [SVProgressHUD showErrorWithStatus:@"No Internet"];
                        [self setUpRootOffline:YES withStatus:@"2"];//2 = ไม่มีเนต
                    }
                }
                else if (remoteInternetStatus == ReachableViaWiFi||remoteInternetStatus == ReachableViaWWAN)
                {
                    //NSLog(@"เซิฟล่ม");
                    if (!serverDown) {
                        //NSLog(@"ZZZ");
                        offlineStatus = NO;
                        serverNormal = NO;
                        serverDown = YES;
                        [SVProgressHUD showErrorWithStatus:@"Server Down"];
                        [self setUpRootOffline:YES withStatus:@"1"];//1 = server ล่ม
                    }
                }
            });
        };
        [serverReach startNotifier];
    }
}

- (void) handleNetworkChange:(NSNotification *)notice
{
    /*
    NetworkStatus remoteInternetStatus = [internetReach currentReachabilityStatus];
    
    if(remoteInternetStatus == NotReachable)
    {
        NSLog(@"Change to Not Connect");
        if (onlineStatus) {
            NSLog(@"ZZZ");
            onlineStatus = NO;
            serverChecked = NO;
            serverNormal = NO;
            serverDown = NO;
            [self setUpRootOffline:YES withStatus:@"2"];//2 = ไม่มีเนต
        }
    }
    else if (remoteInternetStatus == ReachableViaWiFi||remoteInternetStatus == ReachableViaWWAN)
    {
        NSLog(@"Change to Wifi or Cell");
        if (!onlineStatus) {
            NSLog(@"AAA");
            onlineStatus = YES;
        }
    }
     */
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  // If you are receiving a notification message while your app is in the background,
  // this callback will not be fired till the user taps on the notification launching the application.
  // TODO: Handle data of notification

  // With swizzling disabled you must let Messaging know about the message, for Analytics
  // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

  // Print full message.
    NSLog(@"%@", userInfo);
    
    [ISMessages showCardAlertWithTitle:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"]
                               message:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"]
                              duration:3.f
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:ISAlertTypeInfo
                         alertPosition:ISAlertPositionTop
                               didHide:^(BOOL finished) {
                                   NSLog(@"Alert did hide.");
                               }];
    
    if([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
    {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
    else
    {
        AudioServicesPlayAlertSound (kSystemSoundID_Vibrate);
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)setUpRootOffline:(BOOL)offline withStatus:(NSString*)internetStatus
{
    container = (MFSideMenuContainerViewController *)self.window.rootViewController;
    
    if (IS_IPHONE) {
        [container setLeftMenuWidth:[UIScreen mainScreen].bounds.size.width*1.0];
        //[container setRightMenuWidth:[UIScreen mainScreen].bounds.size.width*0.80];
        //NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
        float factor = [UIScreen mainScreen].bounds.size.width/320;
        fontSize = 13*factor;
    }
    if (IS_IPAD) {
        [container setLeftMenuWidth:[UIScreen mainScreen].bounds.size.width*0.4];
        float factor = [UIScreen mainScreen].bounds.size.width/768;
        fontSize = 25*factor;
    }
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
    //leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    //UIViewController *rightSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rightSideMenuViewController"];
    
        if (loginStatus == YES)
        {
            if (offline) {//อย่าลืมเอา ! ออก
                Offline *off = [storyboard instantiateViewControllerWithIdentifier:@"Offline"];
                off.internetStatus = internetStatus;
                //[container setLeftMenuViewController:leftSideMenuViewController];
                [container setCenterViewController:off];
            }
            else{
                [self setUpTabBar];
            }
        }
        else{
            UIViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
            //[container setLeftMenuViewController:leftSideMenuViewController];
            [container setCenterViewController:login];
        }
}

- (void) setUpTabBar
{
    MainMenu *firstViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    //firstViewController.title = @"First View";
    firstViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"หน้าแรก" image:[UIImage imageNamed:@"Tab_home.png"] tag:0];
    //[[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
    Navi *firstNavController = [[Navi alloc]initWithRootViewController:firstViewController];
    firstNavController.navigationBarHidden = YES;
    
    CheckInOut *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"CheckInOut"];
   secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"เวลาเข้างาน" image:[UIImage imageNamed:@"Tab_time.png"] tag:1];
    Navi *secondNavController = [[Navi alloc]initWithRootViewController:secondViewController];
    secondNavController.navigationBarHidden = YES;
    
    Leave *thirdViewController = [storyboard instantiateViewControllerWithIdentifier:@"Leave"];
    thirdViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"การร้องขอ" image:[UIImage imageNamed:@"Tab_request.png"] tag:2];
    Navi *thirdNavController = [[Navi alloc]initWithRootViewController:thirdViewController];
    thirdNavController.navigationBarHidden = YES;
    
    Shift *forthViewController = [storyboard instantiateViewControllerWithIdentifier:@"Shift"];
    //forthViewController.title = @"Forth View";
    forthViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"แลกเวร" image:[UIImage imageNamed:@"Tab_calendar.png"] tag:3];
    Navi *forthNavController = [[Navi alloc]initWithRootViewController:forthViewController];
    forthNavController.navigationBarHidden = YES;
    
    Tabbar *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"tabbarController"];//[[UITabBarController alloc] initWithNibName:nil bundle:nil];
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:firstNavController, secondNavController, thirdNavController,forthNavController, nil];
    //tabBarController.tabBar.tintColor = [UIColor colorWithRed:169.0/255 green:79.0/255 blue:123.0/255 alpha:1];
    //tabBarController.delegate = self;
    
    if (mainTabStatus) {
        [tabBarController setSelectedIndex:1];
    }
    else{
        [tabBarController setSelectedIndex:0];//Start With Tab X
    }
     
    //[container setLeftMenuViewController:leftSideMenuViewController];
    //[container setRightMenuViewController:rightSideMenuViewController];
    [container setCenterViewController:tabBarController];
}

#pragma mark - Version update check

-(BOOL) needsUpdate{

    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/th/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    if (data != nil) {
        NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([lookup[@"resultCount"] integerValue] == 1){
            NSString* appStoreVersion = lookup[@"results"][0][@"version"];
            NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
            
            /*
             if (![appStoreVersion isEqualToString:currentVersion]){
             NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
             return YES;
             }
             */
            if ([appStoreVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
                NSLog(@"Need to update [%@ > %@]", appStoreVersion, currentVersion);
                [self versionUpdate:lookup[@"results"][0][@"trackViewUrl"] withName:lookup[@"results"][0][@"trackName"]];
                return YES;
            }
        }
    }
    return NO;
}

- (void)versionUpdate:(NSString *)appstoreID withName:(NSString *)appstoreName
{
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"เวอร์ชั่นใหม่" message:[NSString stringWithFormat:@"กรุณาอัพเดทแอพ %@ เป็นเวอร์ชั่นล่าสุด",appstoreName] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"อัพเดทตอนนี้" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreID]];
        
        [self versionUpdate:appstoreID withName:appstoreName];
        
        // important to hide the window after work completed.
        // this also keeps a reference to the window until the action is invoked.
        topWindow.hidden = YES; // if you want to hide the topwindow then use this
        //topWindow = nil; // if you want to remove the topwindow then use this
    }]];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }];
    [alert addAction:cancelAction];
    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark Time Format Methods
- (NSString*)appTimeFromDatabase:(NSString*)dbTime
{
    //DB Time
    NSDate * tmpDate = [df dateFromString:dbTime];
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"dd/MM/yyyy"];
    [df2 setLocale:localeEN];
    
    NSString *dateString = [df2 stringFromDate:tmpDate];
    return dateString;
}

- (NSString*)timeFromDatabase:(NSString*)dbTime toFormat:(NSString*)format withLocal:(NSString*)localCode
{
    //DB Time
    NSDate * tmpDate = [df dateFromString:dbTime];
    
    NSLocale *localeTo = [[NSLocale alloc] initWithLocaleIdentifier:localCode];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:format];//[df2 setDateFormat:@"dd MMM yy"];
    [df2 setLocale:localeTo];
    
    NSString *dateString = [df2 stringFromDate:tmpDate];
    
    return dateString;
}

- (NSString*)appTimeToDatabase:(NSDate*)appTime
{
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"yyyy-MM-dd"];
    [df2 setLocale:localeEN];
    
    NSString *dateString = [df2 stringFromDate:appTime];
    
    return dateString;
}

- (NSDate*)getFromServerDate:(NSString*)originalDate
{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:locale];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *convertDate = [df dateFromString:originalDate];
    
    return convertDate;
}

- (void)choosePhotoOnViewcontroller:(UIViewController*)viewCon
{
    UIAlertController *actionSheet = [UIAlertController  alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"เลือกรูปจากอัลบั้ม" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized) {
            // Access has been granted.
            [self selectImageOnViewcontroller:viewCon];
        } else if (status == PHAuthorizationStatusDenied) {
            // Access has been denied.
            [self openSettingwithTiltle:@"Photo Library access was disable" withMessage:@"อนุญาตให้แอพเข้าถึงอัลบัมรูปภาพเพื่อใช้งาน" onViewcontroller:viewCon];
        } else if (status == PHAuthorizationStatusRestricted) {
            // Restricted access - normally won't happen.
        } else if (status == PHAuthorizationStatusNotDetermined) {
            // Access has not been determined.
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    // Access has been granted.
                    [self selectImageOnViewcontroller:viewCon];
                } else {
                    // Access has been denied.
                }
            }];
        }
        //[self dismissViewControllerAnimated:YES completion:^{ }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"กล้องถ่ายรูป" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusAuthorized) {
            // Access has been granted.
            [self takePhotoOnViewcontroller:viewCon];
        } else if(authStatus == AVAuthorizationStatusDenied){
            // Access has been denied.
            [self openSettingwithTiltle:@"Camera access was disable" withMessage:@"อนุญาตให้แอพเข้าถึงกล้องถ่ายรูปเพื่อใช้งาน" onViewcontroller:viewCon];
        } else if(authStatus == AVAuthorizationStatusRestricted){
            // Restricted access - normally won't happen.
        } else if(authStatus == AVAuthorizationStatusNotDetermined){
            // Access has not been determined.
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    // Access has been granted.
                    [self takePhotoOnViewcontroller:viewCon];
                } else {
                    // Access has been denied.
                }
            }];
        } else {
            // impossible, unknown authorization status
        }
        //[self dismissViewControllerAnimated:YES completion:^{ }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [viewCon dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [viewCon presentViewController:actionSheet animated:YES completion:nil];
}

- (void)selectImageOnViewcontroller:(UIViewController*)viewCon {
    NSLog(@"selectImage");
    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
    //pickerViewController.allowsEditing = YES;
    pickerViewController.delegate = (id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)viewCon;
    [pickerViewController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewCon presentViewController:pickerViewController animated:YES completion:nil];
    });
}

- (void)takePhotoOnViewcontroller:(UIViewController*)viewCon {
    NSLog(@"takePhoto");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pickerViewController =[[UIImagePickerController alloc]init];
        //pickerViewController.allowsEditing = YES;
        pickerViewController.delegate = (id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)viewCon;
        pickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewCon presentViewController:pickerViewController animated:YES completion:nil];
        });
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Camera is not available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewCon presentViewController:alert animated:YES completion:nil];
        });
    }
}

- (void)openSettingwithTiltle:(NSString*)title withMessage:(NSString*)message onViewcontroller:(UIViewController*)viewCon
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
        //TODO if user has not given permission to device
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                          options:[NSDictionary dictionary]
                                completionHandler:nil];
    }];
    [alertController addAction:settingAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    [alertController addAction:cancelAction];
    
    [viewCon presentViewController:alertController animated:YES completion:nil];
}

- (void)replaceLastNavStack:(UINavigationController*)naviCon withView:(UIViewController*)viewCon
{
    NSArray *viewControllersStack = [naviCon viewControllers];
    NSMutableArray *editableViewControllers = [NSMutableArray arrayWithArray:viewControllersStack];
    [editableViewControllers removeLastObject];
    [editableViewControllers addObject:viewCon];
    [naviCon setViewControllers:editableViewControllers];
}

- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(image.CGImage);
    //double refHeight = CGImageGetHeight(image.CGImage);

    double x = (refWidth - size.width) / 2.0;
    double y = 0;//(refHeight - size.height) / 2.0;

    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);

    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);

    return cropped;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //NSLog(@"Reload");
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"CheckConnection" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
