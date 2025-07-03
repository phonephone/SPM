//
//  AppDelegate.h
//  Mangkud
//
//  Created by Firststep Consulting on 21/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import <AFNetworking/AFNetworking.h>
#import "SVProgressHUD.h"
#import "MFSideMenuContainerViewController.h"
#import "Reachability.h"
#import <UserNotifications/UserNotifications.h>
#import <ISMessages/ISMessages.h>

@import Firebase;
@import GooglePlaces;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate,FIRMessagingDelegate>
{
    UIViewController *leftSideMenuViewController;
    MFSideMenuContainerViewController *container;
    UIStoryboard *storyboard;
    
    NSLocale *localeEN;
    NSDateFormatter *df;
    
    Reachability *internetReach;
    
    BOOL offlineStatus;
    BOOL serverNormal;
    BOOL serverDown;
    BOOL firstTime;
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) float fontSize;
@property (nonatomic) NSString *fontRegular;
@property (nonatomic) NSString *fontLight;
@property (nonatomic) NSString *fontMedium;
@property (nonatomic) NSString *fontSemibold;
@property (nonatomic) NSString *fontBold;

@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *adminID;
@property (nonatomic) NSString *userLogoUrl;
@property (nonatomic) NSString *userFullname;
@property (nonatomic) NSString *userDepartment;
@property (nonatomic) NSString *userPicURL;

@property (nonatomic) NSString *serverURL;
@property (nonatomic) NSString *serverURLshort;

@property (nonatomic) NSString *heroURL;
@property (nonatomic) NSString *heroURLshort;

@property (nonatomic) NSString *offlineBtnStatus;


@property (nonatomic) BOOL leaveBtnShow;
@property (nonatomic) BOOL otBtnShow;
@property (nonatomic) BOOL wfhBtnShow;

@property (strong, nonatomic) UIColor *mainThemeColor;
@property (strong, nonatomic) UIColor *mainThemeColor2;
@property (strong, nonatomic) UIColor *cancelThemeColor;

@property (nonatomic) BOOL loginStatus;
@property (nonatomic) BOOL mainTabStatus;
@property (nonatomic) BOOL reloadProfile;

- (NSString*)appTimeFromDatabase:(NSString*)dbTime;
- (NSString*)timeFromDatabase:(NSString*)dbTime toFormat:(NSString*)format withLocal:(NSString*)localCode;
- (NSString*)appTimeToDatabase:(NSDate*)appTime;

- (NSDate*)getFromServerDate:(NSString*)originalDate;
- (void)choosePhotoOnViewcontroller:(UIViewController*)viewCon;
- (void)selectImageOnViewcontroller:(UIViewController*)viewCon;
- (void)takePhotoOnViewcontroller:(UIViewController*)viewCon;
- (void)openSettingwithTiltle:(NSString*)title withMessage:(NSString*)message onViewcontroller:(UIViewController*)viewCon;

- (void)replaceLastNavStack:(UINavigationController*)naviCon withView:(UIViewController*)viewCon;

- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size;
@end

