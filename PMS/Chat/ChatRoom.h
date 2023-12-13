//
//  ChatRoom.h
//  PMS
//
//  Created by Truk Karawawattana on 7/2/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface ChatRoom : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    AppDelegate *delegate;
    IQKeyboardManager *keyboardManager;
    
    NSMutableArray *chatJSON;
    UIRefreshControl *refreshController;
    
    NSTimer *timer;
    CGRect keyboardRect;
    BOOL keyboardReady;
    
    UIFont *messageFont;
    UIFont *timeFont;
    
    NSData *imageData;
    NSURL *imagePath;
    NSString *imageName;
    NSString *imageType;
    
    BOOL imageExisted;
    BOOL firstTime;
    BOOL scrollToBottom;
}
@property (nonatomic) NSString *fromID;
@property (nonatomic) NSString *toID;
@property (nonatomic) NSString *companyID;
@property (nonatomic) NSString *adminName;

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;
@property (weak, nonatomic) IBOutlet UIButton *headerRBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *myTable;

@property(weak, nonatomic) IBOutlet UIView *chatView;
@property(weak, nonatomic) IBOutlet UIView *chatBox;
@property (weak, nonatomic) IBOutlet UITextField *chatField;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintContentViewBottomWithSendMessageViewBottom;

@end
