//
//  Personal_2.m
//  PMS
//
//  Created by Truk Karawawattana on 14/2/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import "Personal_2.h"
#import "SDWebImage.h"

@interface Personal_2 ()

@end

@implementation Personal_2

@synthesize profilePic,cameraBtn,nameLabel,telL,emailL,emailprivateL,lineL,fbL,igL,linkL,telR,emailR,emailprivateR,lineR,fbR,igR,linkR,saveBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    profilePic.layer.borderColor = [[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1] CGColor];
    profilePic.layer.borderWidth = 1;
    profilePic.layer.cornerRadius = profilePic.frame.size.height/2;
    profilePic.layer.masksToBounds = YES;
    
    nameLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    
    float fontSize = delegate.fontSize;
    telL.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    emailL.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    emailprivateL.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    telR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    emailR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    emailprivateR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    lineR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    fbR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    igR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    linkR.font = [UIFont fontWithName:delegate.fontRegular size:fontSize];
    
    [self addbottomBorder:telR withColor:nil];
    [self addbottomBorder:emailR withColor:nil];
    [self addbottomBorder:emailprivateR withColor:nil];
    [self addbottomBorder:lineR withColor:nil];
    [self addbottomBorder:fbR withColor:nil];
    [self addbottomBorder:igR withColor:nil];
    [self addbottomBorder:linkR withColor:nil];
    
    telR.userInteractionEnabled = NO;
    emailR.userInteractionEnabled = NO;
    
    [self loadProfile];
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
             nameLabel.text = [NSString stringWithFormat:@"พนักงาน : %@ %@",[profileJSON objectForKey:@"name"],[profileJSON objectForKey:@"lastname"]];
             telR.text = [profileJSON objectForKey:@"phone"];
             emailR.text = [profileJSON objectForKey:@"email"];
             lineR.text = [profileJSON objectForKey:@"line_id"];
             fbR.text = [profileJSON objectForKey:@"facebook_id"];
             igR.text = [profileJSON objectForKey:@"ig_id"];
             linkR.text = [profileJSON objectForKey:@"linkedin_id"];
             
             [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[profileJSON objectForKey:@"photo"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                 if (image && finished) {
                     [profilePic setImage:[delegate imageByCroppingImage:image toSize:CGSizeMake(image.size.width, image.size.width)]];
                 }
             }];
             
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

- (IBAction)saveClick:(id)sender
{
    [self saveProfile];
}

- (void)saveProfile
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *line = [lineR.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *fb = [fbR.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *ig = [igR.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *linked = [linkR.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString* url = [NSString stringWithFormat:@"%@updateProfileContact/%@/%@/%@/%@/%@",delegate.serverURL,delegate.userID,line,fb,ig,linked];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"ProfileJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             
             [SVProgressHUD showSuccessWithStatus:@"บันทึกข้อมูลเรียบร้อย"];
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
