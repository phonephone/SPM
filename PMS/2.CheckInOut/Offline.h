//
//  Offline.h
//  PMS
//
//  Created by Truk Karawawattana on 4/1/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Offline : UIViewController <UITableViewDelegate,UITableViewDataSource,AVCaptureMetadataOutputObjectsDelegate>
{
    AppDelegate *delegate;
    NSMutableArray *offlineJSON;
    
    NSString *clocktype;
    
    NSLocale *localeEN;
    NSLocale *localeTH;
    NSDateFormatter *df;
    NSDateFormatter *tf;
    
    NSString *filePath;
    NSString *fileName;
    NSString* fileAtPath;
    
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *prevLayer;
    BOOL isFirst;
    NSString *qrString;
    UIButton *overlayButton;
}
@property (nonatomic) NSString *internetStatus;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *inBtn;
@property (weak, nonatomic) IBOutlet UIButton *outBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (retain, nonatomic) IBOutlet UITableView *myTable;

@end

NS_ASSUME_NONNULL_END
