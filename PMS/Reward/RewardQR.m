//
//  RewardQR.m
//  PMS
//
//  Created by Truk Karawawattana on 28/2/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import "RewardQR.h"
#import "UIImageView+WebCache.h"

@interface RewardQR ()

@end

@implementation RewardQR

@synthesize mode,redeemArray,rewardPic,nameLabel,pointLabel,dateL,dateR,timeL,timeR,statusLabel,qrPic;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    
    [rewardPic sd_setImageWithURL:[NSURL URLWithString:[redeemArray objectForKey:@"cover_img"]] placeholderImage:[UIImage imageNamed:@"logo_square.png"]];
    
    if ([mode isEqualToString:@"QR"])
    {
        nameLabel.text = [redeemArray objectForKey:@"redeem"];
        pointLabel.text = [NSString stringWithFormat:@"%@ คะแนน",[redeemArray objectForKey:@"score"]];
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSLocale *localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        [df setLocale:localeEN];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
        NSLocale *localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
        [df2 setLocale:localeTH];
        
        NSDate *redeemDate = [df dateFromString:[redeemArray objectForKey:@"date"]];
        
        [df2 setDateFormat:@"dd MMM yyyy"];
        dateR.text = [df2 stringFromDate:redeemDate];
        
        [df2 setDateFormat:@"HH:mm"];
        timeR.text = [df2 stringFromDate:redeemDate];
        
        if ([[redeemArray objectForKey:@"status"] isEqualToString:@"1"]) {
            statusLabel.text = @"นำ QR นี้ไปแลกสินค้า";
            statusLabel.textColor = delegate.mainThemeColor;
        }
        else if ([[redeemArray objectForKey:@"status"] isEqualToString:@"2"]) {
            statusLabel.text = @"QR นี้ถูกใช้แลกสินค้าแล้ว";
            statusLabel.textColor = [UIColor redColor];
        }
        statusLabel.hidden = NO;
    }
    else{//Activity
        nameLabel.text = [redeemArray objectForKey:@"title"];
        pointLabel.text = [NSString stringWithFormat:@"%@ คะแนน",[redeemArray objectForKey:@"score"]];
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSLocale *localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        [df setLocale:localeEN];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
        NSLocale *localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
        [df2 setLocale:localeTH];
        
        NSDate *redeemDate = [df dateFromString:[redeemArray objectForKey:@"date_ev"]];
        
        [df2 setDateFormat:@"dd MMM yyyy"];
        dateR.text = [df2 stringFromDate:redeemDate];
        
        [df2 setDateFormat:@"HH:mm"];
        timeR.text = [df2 stringFromDate:redeemDate];
        
        dateL.text = @"วันที่เข้าร่วมกิจกรรม";
        timeL.text = @"เวลาที่เข้าร่วมกิจกรรม";
        
        statusLabel.hidden = YES;
    }
    
    [self genQR];
}

-(void)genQR
{
    NSString *qrString = [redeemArray objectForKey:@"qr"];
    NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];

    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];

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

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
