//
//  LeftMenu.h
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LeftMenu : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    AppDelegate *delegate;
    NSMutableIndexSet *expandedSections;
    
    UIViewController *viewController;
    BOOL permission;
    
    NSMutableDictionary *permissionJSON;
    
    NSMutableArray *approveArray;
    NSMutableArray *welearnArray;
    NSMutableArray *werosterArray;
    NSMutableArray *wenewsArray;
    
    UIDatePicker *dayPicker;
    NSDateFormatter *df;
    UITextField *dateField;
    
    NSLocale *localeTH;
    NSLocale *localeEN;
    
    NSString *happyPoint;
    
    int picTapCount;
    
    NSString* url;
}

@property (weak, nonatomic) IBOutlet UIImageView *companyPic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userDepartment;
@property (retain, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (void)updateProfile;
- (void)checkPermission;
@end
