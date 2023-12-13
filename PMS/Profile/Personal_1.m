//
//  Personal_1.m
//  PMS
//
//  Created by Truk Karawawattana on 14/2/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import "Personal_1.h"
#import "SDWebImage.h"
#import "Login.h"

@interface Personal_1 ()

@end

@implementation Personal_1

@synthesize cardView,profilePic,logoPic,logoPic2,qrPic,firstNameLabel,lastNameLabel,idLabel;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    cardView.layer.borderColor = [[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1] CGColor];
    cardView.layer.borderWidth = 1;
    cardView.layer.cornerRadius = 20;
    cardView.layer.masksToBounds = YES;
    
    firstNameLabel.font = [UIFont fontWithName:delegate.fontMedium size:delegate.fontSize+10];
    lastNameLabel.font = [UIFont fontWithName:delegate.fontMedium size:delegate.fontSize+2];
    idLabel.font = [UIFont fontWithName:delegate.fontLight size:delegate.fontSize+2];
    
    [self loadProfile];
    
    logoPic2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTap)];
    [logoPic2 addGestureRecognizer:tapGesture];
    picTapCount = 0;
    
    NSLog(@"XXXXX %@", self.navigationController.viewControllers);
}

- (void)picTap
{
    picTapCount++;
    if (picTapCount >= 10) {
        picTapCount = 0;
        [self logOut];
    }
}

-(void)logOut
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    delegate.loginStatus = NO;
    delegate.userID = @"";
    delegate.adminID = @"";
    delegate.userLogoUrl = @"";
    delegate.userFullname = @"";
    
    [ud setBool:delegate.loginStatus forKey:@"loginStatus"];
    [ud setObject:delegate.userID forKey:@"userID"];
    [ud setObject:delegate.adminID forKey:@"adminID"];
    //[ud setObject:delegate.userLogoUrl forKey:@"userLogoUrl"];
    //[ud setObject:delegate.userFullname forKey:@"userFullname"];
    [ud synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    Login *log = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.menuContainerViewController setCenterViewController:log];
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}


- (void)loadProfile
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@empProfileDetail/%@",delegate.serverURL,delegate.userID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
        NSLog(@"ProfileJSON %@",responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
            
            profileJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
            firstNameLabel.text = [profileJSON objectForKey:@"name"];
            lastNameLabel.text = [profileJSON objectForKey:@"lastname"];
            idLabel.text = [NSString stringWithFormat:@"รหัสพนักงาน : %@",[profileJSON objectForKey:@"ac_no"]];
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[profileJSON objectForKey:@"photo"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (image && finished) {
                    [profilePic setImage:image];
                }
                else {
                    profilePic.image = [self createImageWithColor:[UIColor lightGrayColor]];
                }
                
            }];
            
            //NSString *picStr = [profileJSON objectForKey:@"photo"];
            //NSString *picStr = @"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";
            /*
             if ([picStr isEqualToString:@""]) {
             profilePic.image = [self createImageWithColor:[UIColor lightGrayColor]];
             }
             else{
             profilePic.image = [self decodeBase64ToImage:picStr];
             }
             */
            [self genQR];
            
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

-(void)genQR
{
    NSString *qrString = [profileJSON objectForKey:@"qr_code"];
    NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setDefaults];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    //[qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = qrPic.frame.size.width / qrImage.extent.size.width;
    float scaleY = qrPic.frame.size.height / qrImage.extent.size.height;
    
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    qrPic.image = [UIImage imageWithCIImage:qrImage
                                      scale:[UIScreen mainScreen].scale
                                orientation:UIImageOrientationUp];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (UIImage *)createImageWithColor: (UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
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
