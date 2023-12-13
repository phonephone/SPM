//
//  CheckInOut.h
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CheckInOut : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *delegate;
    NSMutableDictionary *btnJSON;
    NSMutableDictionary *clockJSON;
    NSMutableDictionary *listJSON;
    
    CLLocationManager * locationManager;
    
    int syncCount;
    NSString *loadStatus; //loaded, not
    NSString *checkStatus; //in ,out
    NSString *clocktype; // 0 ,1 ,2
    
    CLLocationCoordinate2D userCoordinate;
    NSString *latitude;
    NSString *longitude;
    
    NSString *codeQR;
    
    BOOL clockIN;
    BOOL clockOUT;
    BOOL timeSync;
    
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *prevLayer;
    BOOL isFirst;
    UIButton *overlayButton;
    
    NSLocale *localeEN;
    NSLocale *localeTH;
    NSDateFormatter *df;
    UIDatePicker *datePicker;
    
    BOOL wfhMode;
    
    NSMutableArray *offlineJSON;
    int failCount;
    NSString *filePath;
    NSString *fileName;
    NSString* fileAtPath;
}

@property (weak, nonatomic) IBOutlet UIButton *checkInBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkOutBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *stampBtn;
@property (weak, nonatomic) IBOutlet UILabel *stampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stampIcon;

@property (weak, nonatomic) IBOutlet MKMapView *myMap;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;

@property (weak, nonatomic) IBOutlet UIView *qrView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

@property (retain, nonatomic) IBOutlet UITableView *myTable;

@property (retain, nonatomic) IBOutlet UIButton *lefttMenu;
@property (retain, nonatomic) IBOutlet UIButton *rightMenu;

@end
