//
//  GivePoint.h
//  PMS
//
//  Created by Truk Karawawattana on 9/4/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface GivePoint : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    AppDelegate *delegate;
    NSMutableArray *reasonJSON;
    NSMutableDictionary *pointJSON;
    NSMutableDictionary *profileJSON;
    
    UIPickerView *typePicker;
    UIPickerView *pointPicker;
    NSString *typeID;
    int remainPoint;
    
    NSString *managerID;
    
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *prevLayer;
    BOOL isFirst;
    NSString *qrString;
    NSString *qrID;
    UIButton *overlayButton;
}
@property (nonatomic) NSString *mode;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *qrBtn;

@property (weak, nonatomic) IBOutlet UILabel *idL;
@property (weak, nonatomic) IBOutlet UILabel *reasonL;
@property (weak, nonatomic) IBOutlet UILabel *remarkL;
@property (weak, nonatomic) IBOutlet UILabel *pointL;

@property (weak, nonatomic) IBOutlet UITextField *idR;
@property (weak, nonatomic) IBOutlet UITextField *reasonR;
@property (weak, nonatomic) IBOutlet UITextField *remarkR;
@property (weak, nonatomic) IBOutlet UITextField *pointR;

@property (weak, nonatomic) IBOutlet UILabel *warnLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end
