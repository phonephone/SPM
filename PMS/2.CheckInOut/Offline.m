//
//  Offline.m
//  PMS
//
//  Created by Truk Karawawattana on 4/1/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import "Offline.h"
#import "LeaveCell.h"

@interface Offline ()

@end

@implementation Offline

@synthesize internetStatus,timeLabel,inBtn,outBtn,deleteBtn,myTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Net = %@",internetStatus);
    deleteBtn.hidden = YES;
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    offlineJSON = [[NSMutableArray alloc] init];
    //pathJSON = [[NSBundle mainBundle] pathForResource:@"offline" ofType:@"json"];
    filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    fileName = @"offline.json";
    fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    delegate.offlineBtnStatus = [ud objectForKey:@"offlineBtnStatus"];
    NSLog(@"OfflineBtn = %@",delegate.offlineBtnStatus);
    
    [self showTime];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showTime) userInfo:nil repeats:YES];
    
    timeLabel.font = [UIFont fontWithName:delegate.fontMedium size:delegate.fontSize+80];
    
    inBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    
    outBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    
    inBtn.backgroundColor = delegate.mainThemeColor;
    inBtn.layer.cornerRadius = inBtn.frame.size.height/2;
    inBtn.layer.masksToBounds = YES;
    
    outBtn.backgroundColor = delegate.cancelThemeColor;
    outBtn.layer.cornerRadius = outBtn.frame.size.height/2;
    outBtn.layer.masksToBounds = YES;
    
    localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:localeEN];
    
    tf = [[NSDateFormatter alloc] init];
    [tf setDateFormat:@"HH:mm"];
    [tf setLocale:localeEN];
    
    if (!delegate.offlineBtnStatus) {
        delegate.offlineBtnStatus = @"1";
    }
    [self updateOfflineBtn];
    
    [self loadTable];
}

-(void)updateOfflineBtn
{
    if ([delegate.offlineBtnStatus isEqualToString:@"1"]) {
        inBtn.enabled = YES;
        inBtn.backgroundColor = delegate.mainThemeColor;
        
        outBtn.enabled = NO;
        outBtn.backgroundColor = [UIColor grayColor];
    }
    else if ([delegate.offlineBtnStatus isEqualToString:@"2"]) {
        inBtn.enabled = NO;
        inBtn.backgroundColor = [UIColor grayColor];
        
        outBtn.enabled = YES;
        outBtn.backgroundColor = delegate.cancelThemeColor;
    }
}

-(void)showTime{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:localeTH];
    [dateFormatter setDateFormat:@"HH : mm"];//@"dd.MM.YY HH:mm:ss"
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    timeLabel.text = dateString;
    timeLabel.textColor = [UIColor darkGrayColor];
}

- (void)loadTable
{
    [self JSONFromFile:^{
        NSLog(@"JSON %@",offlineJSON);
    }];
}

- (void)JSONFromFile:(void(^)(void))complete
{
    //ลบไฟล์ สำหรับเทส
    //[[NSFileManager defaultManager] removeItemAtPath:fileAtPath error:nil];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        NSLog(@"อ่าน ไม่เจอ");
    }
    else
    {
        NSLog(@"อ่าน เจอ");
        NSData *data = [NSData dataWithContentsOfFile:fileAtPath];
        offlineJSON = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] mutableCopy];
    }
    
    [myTable reloadData];
    complete();
}

- (void)writeToJSON:(void(^)(void))complete
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath])
    {
        NSLog(@"เขียน ไม่เจอ");
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    // The main act...
    NSData* data = [NSJSONSerialization dataWithJSONObject:offlineJSON
                                                       options:kNilOptions
                                                         error:nil];
    [data writeToFile:fileAtPath atomically:YES];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:delegate.offlineBtnStatus forKey:@"offlineBtnStatus"];
    [ud synchronize];
    [self updateOfflineBtn];
    
    complete();
}

- (void)addToJSON:(void(^)(void))complete
{
    NSString *idNum = [NSString stringWithFormat:@"%ld",offlineJSON.count];
    NSString *date = [df stringFromDate:[NSDate date]];
    NSString *time = [tf stringFromDate:[NSDate date]];
    
    NSMutableDictionary *addDict = [[NSMutableDictionary alloc] init];
    [addDict setValue:idNum forKey:@"id"];
    [addDict setValue:delegate.userID forKey:@"userID"];
    [addDict setValue:clocktype forKey:@"type"];
    [addDict setValue:date forKey:@"date"];
    [addDict setValue:time forKey:@"time"];
    [addDict setValue:internetStatus forKey:@"internetStatus"];
    [addDict setValue:qrString forKey:@"QR"];
    [offlineJSON addObject:addDict];
    
    NSLog(@"addDict %@",offlineJSON);
    
    [self writeToJSON:^{
        [self JSONFromFile:^{
            NSLog(@"afterAddJSON %@",offlineJSON);
        }];
    }];
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
    headerCell.Label1.font = [UIFont fontWithName:fontName size:fontSizeHeader+2];
    headerCell.Label2.font = [UIFont fontWithName:fontName size:fontSizeHeader+2];
    headerCell.Label3.font = [UIFont fontWithName:fontName size:fontSizeHeader+2];
    
    return headerCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return offlineJSON.count;
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
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setLocale:localeTH];
    [df2 setDateFormat:@"dd/MM/yyyy"];
    
    NSDictionary *cellArray = [[[offlineJSON reverseObjectEnumerator] allObjects] objectAtIndex:indexPath.row];
    
    if ([[cellArray objectForKey:@"type"] isEqualToString:@"1"]) {
        cell.Label1.text = @"เข้างาน";
        cell.Label1.textColor = delegate.mainThemeColor;
    }
    else if ([[cellArray objectForKey:@"type"] isEqualToString:@"2"]) {
        cell.Label1.text = @"ออกงาน";
        cell.Label1.textColor = delegate.cancelThemeColor;
    }
    
    NSDate* stampDate = [df dateFromString:[cellArray objectForKey:@"date"]];
    cell.Label2.text = [df2 stringFromDate:stampDate];
    
    cell.Label3.text = [cellArray objectForKey:@"time"];
    
    if(indexPath.row % 2)
    {
        //cell.contentView.backgroundColor= [UIColor whiteColor];
        cell.contentView.backgroundColor= [delegate.mainThemeColor2 colorWithAlphaComponent:0.2f];
    }
    else
    {
        cell.contentView.backgroundColor= [delegate.mainThemeColor2 colorWithAlphaComponent:0.04f];
    }
    
    float fontSizeCell = delegate.fontSize;
    cell.Label1.font = [UIFont fontWithName:delegate.fontSemibold size:fontSizeCell];
    cell.Label2.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.Label3.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)stampClicked
{
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
            } else {
                NSLog(@"Not granted access to %@", mediaType);
            }
        }];
    } else {
        // impossible, unknown authorization status
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
    
    [session startRunning];
}

- (IBAction)cameraClose:(id)sender
{
    isFirst = FALSE;
    [session stopRunning];
    [prevLayer removeFromSuperlayer];
    session = nil;
    prevLayer = nil;
    [overlayButton removeFromSuperview];
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
                
                //code7 ก่อน decode MTk5OTA5MDkwOTA5MDk=
                
                NSLog(@"QR1 = %@",detectionString);
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:detectionString options:0];
                NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
                NSLog(@"QR2 = %@",decodedString);
                
                //code7 หลัง decode 19990909090909
                
                if (decodedString.length == 14)
                {
                    isFirst = FALSE;
                    [session stopRunning];
                    [prevLayer removeFromSuperlayer];
                    session = nil;
                    prevLayer = nil;
                    [overlayButton removeFromSuperview];
                    
                    if ([decodedString isEqualToString:@"19990909090909"]) {
                        qrString = @"";
                        [self alertTitle:@"Code 7 ใช้ในกรณีฉุกเฉิน" alertDetail:@"สำหรับระบบ Online เท่านั้น !"];
                    }
                    else
                    {
                        qrString = decodedString;
                        [self addToJSON:^{
                            
                        }];
                    }
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

- (IBAction)inClicked:(id)sender
{
    clocktype = @"1";//IN
    
    delegate.offlineBtnStatus = @"2";
    
    qrString = @"";
    [self stampClicked];
    /*
    [self addToJSON:^{
        
    }];
     */
}

- (IBAction)outClicked:(id)sender
{
    clocktype = @"2";//OUT
    
    delegate.offlineBtnStatus = @"1";
    
    qrString = @"";
    [self stampClicked];
    /*
    [self addToJSON:^{
        
    }];
     */
}

- (IBAction)delete:(id)sender
{
    [self deleteFromJSON:^{
        
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
