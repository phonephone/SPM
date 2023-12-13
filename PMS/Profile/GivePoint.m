//
//  GivePoint.m
//  PMS
//
//  Created by Truk Karawawattana on 9/4/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import "GivePoint.h"

@interface GivePoint ()

@end

@implementation GivePoint

@synthesize titleLabel,qrBtn,idL,reasonL,remarkL,pointL,idR,reasonR,remarkR,pointR,warnLabel,sendBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
    /*
    if ([mode isEqualToString:@"Leave"]||[mode isEqualToString:@"Leave_Ahead"]) {
        self.tabBarController.tabBar.hidden = YES;
        
    }
    else
    {
        self.tabBarController.tabBar.hidden = NO;
    }
    */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    [self addbottomBorder:idR withColor:nil];
    [self addbottomBorder:reasonR withColor:nil];
    [self addbottomBorder:remarkR withColor:nil];
    [self addbottomBorder:pointR withColor:nil];
    
    sendBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
    sendBtn.backgroundColor = delegate.mainThemeColor;
    sendBtn.layer.cornerRadius = sendBtn.frame.size.height/2;
    sendBtn.layer.masksToBounds = YES;
    
    remarkL.hidden = YES;
    remarkR.hidden = YES;
    warnLabel.hidden = YES;
    
    /*
    qrString = @"https://spm-hero.thaidevelopers.com/namecard/spm/2671";
    NSArray *qrArray = [qrString componentsSeparatedByString:@"/"];
    qrID = [qrArray lastObject];
    [self loadNurseID:qrID];
    */
    
    [self loadReason];
}

- (void)loadReason
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@we_gifts_reason_list",delegate.serverURL];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
        //NSLog(@"reasonJSON %@",responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
            
            reasonJSON = [[responseObject objectForKey:@"data"] mutableCopy];
            
            typePicker = [[UIPickerView alloc]init];
            typePicker.delegate = self;
            typePicker.dataSource = self;
            typePicker.tag = 0;
            [typePicker selectRow:0 inComponent:0 animated:YES];
            
            reasonR.inputView = typePicker;
            
            reasonR.text = [[reasonJSON objectAtIndex:0] objectForKey:@"reason"];
            typeID = [[reasonJSON objectAtIndex:0] objectForKey:@"id"];
            [typePicker reloadAllComponents];
            
            remarkL.hidden = YES;
            remarkR.hidden = YES;
            remarkR.text = @"";
            
            [self loadPoint];
            //[SVProgressHUD dismiss];
            
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

- (void)loadPoint
{
    //[SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@manager_we_gifts_remain_point/%@",delegate.serverURL,delegate.userID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"PointJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             
             pointJSON = [[[responseObject objectForKey:@"data"] objectAtIndex:0] mutableCopy];
             
             pointPicker = [[UIPickerView alloc]init];
             pointPicker.delegate = self;
             pointPicker.dataSource = self;
             pointPicker.tag = 1;
             [pointPicker selectRow:0 inComponent:0 animated:YES];
             
             pointR.inputView = pointPicker;
             
             
             remainPoint = [[pointJSON objectForKey:@"remain_point"] intValue];
             [pointPicker reloadAllComponents];
             
             if (remainPoint <= 0) {
                 pointR.text = @"0";
                 warnLabel.hidden = NO;
                 [self lockEverything:YES];
             }
             else{
                 pointR.text = @"1";
                 warnLabel.hidden = YES;
                 [self lockEverything:NO];
             }
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

- (void)lockEverything:(BOOL)lockStatus
{
    if (lockStatus) {
        qrBtn.userInteractionEnabled = NO;
        idR.userInteractionEnabled = NO;
        reasonR.userInteractionEnabled = NO;
        remarkR.userInteractionEnabled = NO;
        pointR.userInteractionEnabled = NO;
        sendBtn.userInteractionEnabled = NO;
        //[sendBtn setTitle:@"คะแนนไม่พอ" forState:UIControlStateNormal];
        [sendBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    else{
        qrBtn.userInteractionEnabled = YES;
        idR.userInteractionEnabled = YES;
        reasonR.userInteractionEnabled = YES;
        remarkR.userInteractionEnabled = YES;
        pointR.userInteractionEnabled = YES;
        sendBtn.userInteractionEnabled = YES;
        //[sendBtn setTitle:@"ให้คะแนน" forState:UIControlStateNormal];
        [sendBtn setBackgroundColor:delegate.mainThemeColor];
    }
}

- (void)loadNurseID:(NSString*)userID
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@empProfileDetail/%@",delegate.serverURL,userID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"ProfileJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             
             profileJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
             idR.text = [profileJSON objectForKey:@"ac_no"];
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

- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {//REASON
        return [reasonJSON count];
    }
    else {
        return remainPoint;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {//REASON
        return [[reasonJSON objectAtIndex:row] objectForKey:@"reason"];
    }
    else {
        return [NSString stringWithFormat: @"%ld", row+1];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {//REASON
        reasonR.text = [[reasonJSON objectAtIndex:row] objectForKey:@"reason"];
        typeID = [[reasonJSON objectAtIndex:row] objectForKey:@"id"];
        
        if ([typeID isEqualToString:@"8"])//อื่นๆ
        {
            remarkL.hidden = NO;
            remarkR.hidden = NO;
        }
        else{
            remarkL.hidden = YES;
            remarkR.hidden = YES;
        }
    }
    else {
        pointR.text = [NSString stringWithFormat: @"%ld", row+1];
    }
}

- (IBAction)qrClick:(id)sender
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
                NSLog(@"QR1 = %@",detectionString);
                
                if ([detectionString rangeOfString:@"spm"].location != NSNotFound) {
                    isFirst = FALSE;
                    [session stopRunning];
                    [prevLayer removeFromSuperlayer];
                    session = nil;
                    prevLayer = nil;
                    
                    qrString = detectionString;
                    //https://spm-hero.thaidevelopers.com/namecard/spm/2671
                    NSArray *qrArray = [qrString componentsSeparatedByString:@"/"];
                    qrID = [qrArray lastObject];
                    [self loadNurseID:qrID];
                }
                else
                {
                    [self alertTitle:@"QR Code ไม่ถูกต้อง" alertDetail:@"ไม่สามารถใช้ในการให้คะแนนได้"];
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

- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,textField.frame.size.height, textField.frame.size.width, 1.0f);
    
    if (color == nil) {
        bottomBorder.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1].CGColor;
    }
    else{
        bottomBorder.backgroundColor = color.CGColor;
        //UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, userField.frame.size.width, 20)];
        //textField.rightView = paddingView;
        //textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    [textField.layer addSublayer:bottomBorder];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

- (IBAction)submitPoint:(id)sender
{
    if ([idR.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"กรุณากรอกรหัสพนักงาน\nหรือ\nสแกนรหัสพนักงานจาก QR code"];
    }
    else if ([typeID isEqualToString:@"8"]&&[remarkR.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"กรุณากรอกหมายเหตุ"];
    }
    else
    {
        [self loadSubmit];
    }
}

- (void)loadSubmit
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    /*
    NSData *nsdata = [remarkR.text
      dataUsingEncoding:NSUTF8StringEncoding];
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    */
    
    NSString *encodeReason = [remarkR.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString* url = [NSString stringWithFormat:@"%@give_point_process/%@/%@/%@/%@/%@",delegate.serverURL,[pointJSON objectForKey:@"manager_id"],idR.text,typeID,pointR.text//[pointJSON objectForKey:@"remain_point"]
                     ,encodeReason];
    NSLog(@"URL %@",url);
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
        NSLog(@"submitJSON %@",responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
            
            [SVProgressHUD showSuccessWithStatus:[[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"status_text"]];
            [self lockEverything:YES];
            idR.text = @"";
            
            [self performSelector:@selector(loadReason) withObject:self afterDelay:2.5 ];
            //[SVProgressHUD dismiss];
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

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
