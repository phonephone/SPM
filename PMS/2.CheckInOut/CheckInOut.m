//
//  CheckInOut.m
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "CheckInOut.h"
#import "LeaveCell.h"
#import "NHNetworkTime.h"
#import "ChatRoom.h"
#import "MainMenu.h"
#import "Profile.h"
#import "Agenda.h"
#import "SDWebImage.h"

@interface CheckInOut ()

@end

@implementation CheckInOut

@synthesize checkInBtn,checkOutBtn,timeLabel,stampBtn,stampLabel,stampIcon,warnLabel,myMap,qrView,dateLabel,dateField,dateBtn,myTable,lefttMenu,rightMenu;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = YES;
    self.tabBarController.tabBar.hidden = NO;
    
    [self cameraCloseAll];

    clockIN = NO;
    clockOUT = NO;
    
    if(![[NHNetworkClock sharedNetworkClock]isSynchronized])
    {
        stampBtn.enabled = NO;
        [[NHNetworkClock sharedNetworkClock] synchronize];
        warnLabel.text = @"Synchronizing time...";
        warnLabel.textColor = [UIColor grayColor];
        syncCount = 0;
    }
    
    loadStatus = @"not";//loadStatus = @"loaded"; อย่าลืมเปลี่ยนเป็น not
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    [self loadClock:@""];
    
    if (delegate.userPicURL != nil) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:delegate.userPicURL] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (image && finished) {
                    [rightMenu setImage:[delegate imageByCroppingImage:image toSize:CGSizeMake(image.size.width, image.size.width)] forState:UIControlStateNormal];
                }}];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    checkStatus = @"in";
    
    myMap.delegate = self;
    
    rightMenu.layer.borderColor = [[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1] CGColor];
    rightMenu.layer.borderWidth = 1;
    rightMenu.layer.cornerRadius = rightMenu.frame.size.height/2;
    rightMenu.layer.masksToBounds = YES;
    
    [self showTime];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showTime) userInfo:nil repeats:YES];
    
    timeLabel.font = [UIFont fontWithName:delegate.fontMedium size:delegate.fontSize+80];
    
    //stampBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+4];
    stampLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+5];
    
    warnLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    
    stampBtn.backgroundColor = [UIColor grayColor];
    stampBtn.layer.cornerRadius = stampBtn.frame.size.height/2;
    stampBtn.layer.masksToBounds = YES;

    if (delegate.wfhBtnShow)
    {
        stampIcon.image = [UIImage imageNamed:@"wfh_icon"];
    }
    else{
        stampIcon.image = [UIImage imageNamed:@"qr_icon"];
    }
    
    localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    
    NSDate *today = [[NSDate alloc] init];
    localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:localeTH];
    
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setMaximumDate: [NSDate date]];
    [datePicker setDate:today];
    [datePicker setLocale:localeTH];
    datePicker.calendar = [localeTH objectForKey:NSLocaleCalendar];
    datePicker.tag = 1;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 13.4, *)) {
        datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    
    dateField.inputView = datePicker;
    [df setDateFormat:@"MMMM yyyy"];
    dateField.text = [df stringFromDate:today];
    
    dateLabel.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize+1];
    dateField.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize+1];
    
    [self loadTable:today];
    
    /*decimal
     places   degrees          distance
     -------  -------          --------
     0        1                111.32  km
     1        0.1              11.132 km
     2        0.01             1.1132 km
     3        0.001            111.32  m
     4        0.0001           11.132 m
     5        0.00001          1.1132 m
     6        0.000001         11.132 cm
     7        0.0000001        1.1132 cm
     8        0.00000001       1.1132 mm
     9        0.000000001      111.32  μm
     10       0.0000000001     11.132 μm
     11       0.00000000001    1.1132 μm
     12       0.000000000001   111.32  nm
     13       0.0000000000001  11.132 nm
     */
    
    failCount = 0;
    [self performSelector:@selector(checkOfflineClockJSONFile) withObject:self afterDelay:0.0 ];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self cameraCloseAll];
}

-(void)showTime{
    syncCount++;
    
    if  ([checkStatus isEqualToString:@"in"]) {
        [self checkInClicked:nil];
    }
    else if ([checkStatus isEqualToString:@"out"]) {
        [self checkOutClicked:nil];
    }
}

- (IBAction)checkInClicked:(id)sender
{
    checkStatus = @"in";
    [checkInBtn setImage:[UIImage imageNamed:@"Check_in_on"] forState:UIControlStateNormal];
    [checkOutBtn setImage:[UIImage imageNamed:@"Check_out_off"] forState:UIControlStateNormal];
    
    if (delegate.wfhBtnShow)
    {
        stampLabel.text = @"เข้างาน Work from Home";
    }
    else{
        stampLabel.text = @"เข้างานด้วย QR Code";
    }
    
    if (clockIN == YES && timeSync == YES) {
        
        stampBtn.enabled = YES;
        stampBtn.backgroundColor = delegate.mainThemeColor;
    }
    else {
        stampBtn.enabled = NO;
        stampBtn.backgroundColor = [UIColor grayColor];
    }
    [self updateTime];
}

- (IBAction)checkOutClicked:(id)sender
{
    checkStatus = @"out";
    [checkInBtn setImage:[UIImage imageNamed:@"Check_in_off"] forState:UIControlStateNormal];
    [checkOutBtn setImage:[UIImage imageNamed:@"Check_out_on"] forState:UIControlStateNormal];
    
    if (delegate.wfhBtnShow)
    {
        stampLabel.text = @"ออกงาน Work from Home";
    }
    else{
        stampLabel.text = @"ออกงานด้วย QR Code";
    }
    
    if (clockOUT == YES && timeSync == YES) {
        stampBtn.enabled = YES;
        stampBtn.backgroundColor = delegate.cancelThemeColor;
    }
    else {
        stampBtn.enabled = NO;
        stampBtn.backgroundColor = [UIColor grayColor];
    }
    [self updateTime];
}

- (void)updateTime
{
    if(![[NHNetworkClock sharedNetworkClock]isSynchronized])
    {
        if(syncCount >= 10)
        {
            timeSync = NO;
            warnLabel.text = @"Time Sync Error";
            warnLabel.textColor = delegate.cancelThemeColor;
        }
    }
    else
    {
        timeSync = YES;
        warnLabel.text = @"Time Synced";
        warnLabel.textColor = delegate.mainThemeColor;
    }
    
    NSDate *currDate = [NSDate networkDate];//[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:localeTH];
    [dateFormatter setDateFormat:@"HH : mm"];//@"dd.MM.YY HH:mm:ss"
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    timeLabel.text = dateString;
    timeLabel.textColor = [UIColor darkGrayColor];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    }
    else if (status == kCLAuthorizationStatusDenied) {
        // The user denied authorization
        NSLog(@"Denied");
        [self locationService];
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        // The user accepted authorization
        NSLog(@"Allow");
        [self locationService];
    }
}

- (void)locationService
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location Services was disable" message:@"อนุญาตให้แอพเข้าถึงตำแหน่งปัจจุบันของคุณเพื่อใช้งานฟังก์ชั่นนี้" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        //TODO if user has not given permission to device
                                        if (![CLLocationManager locationServicesEnabled])
                                        {
                                            CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
                                            if (systemVersion < 10) {
                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                            }else{
                                                if (@available(iOS 10.0, *)) {
                                                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                                                                      options:[NSDictionary dictionary]
                                                                            completionHandler:nil];
                                                } else {
                                                    // Fallback on earlier versions
                                                }
                                            }
                                        }
                                        //TODO if user has not given permission to particular app
                                        else
                                        {
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                        }
                                        
                                        [self.tabBarController setSelectedIndex:0];
                                    }];
    [alertController addAction:settingAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
        //[self locationService];
        [self.tabBarController setSelectedIndex:0];
    }];
    [alertController addAction:cancelAction];
    
    if(![CLLocationManager locationServicesEnabled]){
        //ปิด Location Service
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
        //ปิด Location Service เฉพาะแอพ
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        //เปิด Location Service
        
        userCoordinate = [self getLocation];
        latitude = [NSString stringWithFormat:@"%f", userCoordinate.latitude];
        longitude = [NSString stringWithFormat:@"%f", userCoordinate.longitude];
        
        NSLog(@"lat = %@",latitude);
        NSLog(@"long = %@",longitude);
        
        //delegate.latitude = @"13.7370";
        //delegate.longitude = @"100.5604";
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userCoordinate, 300, 300);
        MKCoordinateRegion adjustedRegion = [myMap regionThatFits:viewRegion];
        [myMap setRegion:adjustedRegion animated:YES];
    }
}

-(CLLocationCoordinate2D) getLocation{
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    [locationManager stopUpdatingLocation];
    return coordinate;
}

- (void)loadTable:(NSDate*)date
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setLocale:localeEN];
    [df2 setDateFormat:@"dd-MM-yyyy"];
    NSString *tableDate = [df2 stringFromDate:date];
    NSString* url = [NSString stringWithFormat:@"%@getClockInOutUserDetail/%@/%@",delegate.serverURL,delegate.userID,tableDate];
    //NSLog(@"URL = %@",url);
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"listJSON %@",responseObject);
         listJSON = responseObject;
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             [SVProgressHUD dismiss];
             [myTable reloadData];
         }
         else{
             listJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
             [SVProgressHUD dismissWithDelay:1.5];
             [myTable reloadData];
         }
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
{
         NSLog(@"Error %@",error);
         [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.view.frame.size.height/16;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LeaveCell *headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"ClockHeader"];
    
    NSString *fontName = delegate.fontSemibold;
    float fontSizeHeader = delegate.fontSize-1;
    headerCell.Label1.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    headerCell.Label2.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    headerCell.Label3.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    headerCell.Label4.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    
    return headerCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[listJSON objectForKey:@"status"] isEqualToString:@"success"]) {
        return [[listJSON objectForKey:@"data"] count];
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowHeight;
    
    rowHeight = (self.view.frame.size.height/16);
    
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaveCell *cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"ClockCell"];
    
    NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
    [df3 setLocale:localeEN];
    [df3 setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *df4 = [[NSDateFormatter alloc] init];
    [df4 setLocale:localeEN];
    [df4 setDateFormat:@"dd/MM/yyyy"];
    
    NSDictionary *cellArray = [[listJSON objectForKey:@"data"] objectAtIndex:indexPath.row];
    
    NSDate* inDate = [df3 dateFromString:[cellArray objectForKey:@"clock_in_date"]];
    cell.Label1.text = [df4 stringFromDate:inDate];
    cell.Label2.text = [cellArray objectForKey:@"clock_in"];
    
    NSString *colorCode = [cellArray objectForKey:@"clock_in_color"];
    NSArray *listItems = [colorCode componentsSeparatedByString:@", "];
    float red = [[listItems objectAtIndex:0] floatValue];
    float green = [[listItems objectAtIndex:1] floatValue];
    float blue = [[listItems objectAtIndex:2] floatValue];
    cell.Label1.textColor = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
    cell.Label2.textColor = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
    
    
    NSDate* outDate = [df3 dateFromString:[cellArray objectForKey:@"clock_out_date"]];
    cell.Label3.text = [df4 stringFromDate:outDate];
    cell.Label4.text = [cellArray objectForKey:@"clock_out"];
    
    colorCode = [cellArray objectForKey:@"clock_out_color"];
    listItems = [colorCode componentsSeparatedByString:@", "];
    red = [[listItems objectAtIndex:0] floatValue];
    green = [[listItems objectAtIndex:1] floatValue];
    blue = [[listItems objectAtIndex:2] floatValue];
    cell.Label3.textColor = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
    cell.Label4.textColor = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
    
    if(indexPath.row % 2)
    {
        //cell.contentView.backgroundColor= [UIColor whiteColor];
        cell.contentView.backgroundColor= [delegate.mainThemeColor2 colorWithAlphaComponent:0.2f];
    }
    else
    {
        cell.contentView.backgroundColor= [delegate.mainThemeColor2 colorWithAlphaComponent:0.04f];
    }
    
    float fontSizeCell = delegate.fontSize-3;
    cell.Label1.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.Label2.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.Label3.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.Label4.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    switch (datePicker.tag) {
        case 1://Start Date
            [df setDateFormat:@"MMMM yyyy"];
            dateField.text = [df stringFromDate:datePicker.date];
            [self loadTable:datePicker.date];
            
            //[df setDateFormat:@"yyyy-MM-dd"];
            //goDate = [df stringFromDate:datePicker.date];
            break;
    }
}

- (IBAction)dateClicked:(id)sender
{
    [dateField becomeFirstResponder];
}

- (IBAction)stampClicked:(id)sender
{
    if (delegate.wfhBtnShow)
    {
        wfhMode = YES;
        [self loadClock:@"9999"];
    }
    else
    {
        wfhMode = NO;
        
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusAuthorized) {
            // do your logic
            NSLog(@"Allow");
            [self showQR];
            
        } else if(authStatus == AVAuthorizationStatusDenied){
            // denied
            NSLog(@"Not Allow");
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Camera access was disable" message:@"อนุญาตให้แอพเข้าถึงกล้องถ่ายรูปของคุณเพื่อใช้งานฟังก์ชั่นนี้" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                            {
                                                //TODO if user has not given permission to device
                                                if (![CLLocationManager locationServicesEnabled])
                                                {
                                                    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
                                                    if (systemVersion < 10) {
                                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                    }else{
                                                        if (@available(iOS 10.0, *)) {
                                                            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                                                                              options:[NSDictionary dictionary]
                                                                                    completionHandler:nil];
                                                        } else {
                                                            // Fallback on earlier versions
                                                        }
                                                    }
                                                }
                                                //TODO if user has not given permission to particular app
                                                else
                                                {
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                }
                                            }];
            [alertController addAction:settingAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Canelled");
            }];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else if(authStatus == AVAuthorizationStatusRestricted){
            // restricted, normally won't happen
            NSLog(@"Restricted");
        } else if(authStatus == AVAuthorizationStatusNotDetermined){
            // not determined?!
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if(granted){
                    NSLog(@"Granted access to %@", mediaType);
                    [self showQR];
                } else {
                    NSLog(@"Not granted access to %@", mediaType);
                }
            }];
        } else {
            // impossible, unknown authorization status
        }
    }
}

- (void)showQR
{
    isFirst = TRUE;
    session = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (input) {
        [session addInput:input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    
    output.metadataObjectTypes = [output availableMetadataObjectTypes];
    
    prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    prevLayer.frame = self.view.bounds;//qrView.frame;
    prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:prevLayer];
    
    overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [overlayButton setImage:[UIImage imageNamed:@"btn_x_qr"] forState:UIControlStateNormal];
      [overlayButton setFrame:CGRectMake(20, 50, 50, 50)];
    [overlayButton addTarget:self action:@selector(cameraClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:overlayButton];
    [self.view bringSubviewToFront:overlayButton];
    
    [session startRunning];
    lefttMenu.userInteractionEnabled = NO;
    rightMenu.userInteractionEnabled = NO;
    checkInBtn.userInteractionEnabled = NO;
    checkOutBtn.userInteractionEnabled = NO;
    stampBtn.userInteractionEnabled = NO;
    dateBtn.userInteractionEnabled = NO;
    dateField.userInteractionEnabled = NO;
}

- (IBAction)cameraClose:(id)sender
{
    [self cameraCloseAll];
}

- (void)cameraCloseAll
{
    isFirst = FALSE;
    [session stopRunning];
    [prevLayer removeFromSuperlayer];
    session = nil;
    prevLayer = nil;
    [overlayButton removeFromSuperview];
    
    lefttMenu.userInteractionEnabled = YES;
    rightMenu.userInteractionEnabled = YES;
    checkInBtn.userInteractionEnabled = YES;
    checkOutBtn.userInteractionEnabled = YES;
    stampBtn.userInteractionEnabled = YES;
    dateBtn.userInteractionEnabled = YES;
    dateField.userInteractionEnabled = YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            if (isFirst) {//1st Time
                NSLog(@"QR1 = %@",detectionString);
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:detectionString options:0];
                NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
                NSLog(@"QR2 = %@",decodedString);
                
                if (decodedString.length == 14) {
                    [self cameraCloseAll];
                    
                    [self loadClock:decodedString];
                }
                else
                {
                    [self alertTitle:@"QR Code ไม่ถูกต้อง" alertDetail:@"ไม่สามารถใช้ในการเข้าหรือออกงานได้"];
                }
                
                break;
            }
        }
        else
            NSLog(@"Not found QR");
    }
    
    //highlightView.frame = highlightViewRect;
}

- (IBAction)wfhClicked:(id)sender
{
    wfhMode = YES;
    [self loadClock:@"9999"];
}

- (void)loadClock:(NSString *)stringQR
{
    NSDate *currDate = [NSDate networkDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:localeEN];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeString = [dateFormatter stringFromDate:currDate];
    
    NSString *title;
    NSString *message;
    
    if  ([checkStatus isEqualToString:@"in"]) {
        clocktype = @"1";
        title = [NSString stringWithFormat:@"บันทึกการเข้างาน"];
        message = [NSString stringWithFormat:@"\nวันที่ %@\nเข้างานเวลา %@",dateString,timeString];
    }
    else if ([checkStatus isEqualToString:@"out"]) {
        clocktype = @"2";
        title = [NSString stringWithFormat:@"บันทึกการออกงาน"];
        message = [NSString stringWithFormat:@"\nวันที่ %@\nออกงานเวลา %@",dateString,timeString];
    }
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *clockDate = [dateFormatter stringFromDate:currDate];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *clockTime = [dateFormatter stringFromDate:currDate];
    
    NSString * UUID =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString* url;
    if  ([loadStatus isEqualToString:@"not"]) {
        url = [NSString stringWithFormat:@"%@clockInClockOutData/%@/%@",delegate.serverURL,delegate.userID,clockDate];
    }
    else {
        if (wfhMode) {
            url = [NSString stringWithFormat:@"%@clockInClockOutDataWFH/%@/%@/%@/%@/%@/%@/%@/%@",delegate.serverURL,delegate.userID,clockDate,clockTime,clocktype,latitude,longitude,UUID,@"9999"];
        }
        else
        {
            url = [NSString stringWithFormat:@"%@clockInClockOutData/%@/%@/%@/%@/%@/%@/%@/%@",delegate.serverURL,delegate.userID,clockDate,clockTime,clocktype,latitude,longitude,UUID,stringQR];
        }
    }

    //NSLog(@"URL = %@",url);
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"ClockJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             clockJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
             
             clockIN = [[clockJSON objectForKey:@"clock_in_btn"] boolValue];
             clockOUT = [[clockJSON objectForKey:@"clock_out_btn"] boolValue];
             
             if  ([loadStatus isEqualToString:@"not"]) {
                 loadStatus = @"loaded";//โหลดสถานะปุ่ม รอบแรกสุด
             }
             else {
                 [self alertTitle:title alertDetail:message];
             }
             
             NSDate *today = [[NSDate alloc] init];
             [self loadTable:today];
             dateField.text = [df stringFromDate:today];
             [datePicker setDate:today];
             
             //สำหรับ Offline
             if (clockIN) {
                 delegate.offlineBtnStatus = @"1";
             }
             else if (clockOUT) {
                 delegate.offlineBtnStatus = @"2";
             }
             NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
             [ud setObject:delegate.offlineBtnStatus forKey:@"offlineBtnStatus"];
             [ud synchronize];
             
             [SVProgressHUD dismiss];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
             //[self alertTitle:@"Fail" detail:[responseObject objectForKey:@"message"]];
         }
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
{
         NSLog(@"Error %@",error);
         [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
     }];
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
    [self.navigationController pushViewController:pf animated:YES];
}

- (void)alertTitle:(NSString*)title alertDetail:(NSString*)detail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *titleFont = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableAttributedString *messageFont = [[NSMutableAttributedString alloc] initWithString:detail];
    [titleFont addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+1]
                      range:NSMakeRange (0, titleFont.length)];
    [messageFont addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:delegate.fontLight size:delegate.fontSize-2]
                        range:NSMakeRange(0, messageFont.length)];
    [alertController setValue:titleFont forKey:@"attributedTitle"];
    [alertController setValue:messageFont forKey:@"attributedMessage"];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
