//
//  ActivityList.m
//  PMS
//
//  Created by Truk Karawawattana on 8/3/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import "ActivityList.h"
#import "RewardCell.h"
#import "ActivityDetail.h"
#import "ActivityJoinList.h"
#import "RewardHistory.h"
#import "SDWebImage.h"

@interface ActivityList ()

@end

@implementation ActivityList

@synthesize myTable,titleLabel,profilePic,pointLabel,nameLabel,userBtn,redeemBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self loadScore];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;

    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    
    profilePic.layer.borderColor = [[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1] CGColor];
    profilePic.layer.borderWidth = 1;
    profilePic.layer.cornerRadius = profilePic.frame.size.height/2;
    profilePic.layer.masksToBounds = YES;
    
    myTable.delegate = self;
    myTable.dataSource = self;
    
    [self loadList];
    [self loadProfile];
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"http://spm-hero.thaidevelopers.com/api/today_event/%@",delegate.userID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"ListJSON %@",responseObject);
        listJSON = [[responseObject objectForKey:@"data"] mutableCopy];
        [myTable reloadData];
        
        [SVProgressHUD dismiss];
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"Error %@",error);
        [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
    }];
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

- (NSString *)encodeToBase64String:(UIImage *)image {
 return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
  NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
  return [UIImage imageWithData:data];
}

- (void)loadScore
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"http://spm-hero.thaidevelopers.com/api/scoer_user/%@",delegate.userID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"UserJSON %@",responseObject);
        scoreJSON = [[responseObject objectForKey:@"data"] mutableCopy];
        
        pointLabel.text = [NSString stringWithFormat:@"%@ Points",[[scoreJSON objectForKey:@"score"] stringValue]];
        nameLabel.text = [NSString stringWithFormat:@"%@ %@",[scoreJSON objectForKey:@"first_name"],[scoreJSON objectForKey:@"last_name"]];
        
        [SVProgressHUD dismiss];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listJSON count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RewardCell *cell = (RewardCell *)[tableView dequeueReusableCellWithIdentifier:@"RewardCell"];
    
    NSDictionary *cellArray = [listJSON objectAtIndex:indexPath.row];
    
    [cell.rewardPic sd_setImageWithURL:[NSURL URLWithString:[cellArray objectForKey:@"cover_img"]] placeholderImage:[UIImage imageNamed:@"logo_square.png"]];
    
    cell.nameLabel.text = [cellArray objectForKey:@"title"];
    cell.pointLabel.text = [NSString stringWithFormat:@"จำนวนผู้ร่วมงาน : %@ / %@",[[cellArray objectForKey:@"register"] stringValue],[cellArray objectForKey:@"amount"]];
    
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithData:[[cellArray objectForKey:@"content"] dataUsingEncoding:NSUnicodeStringEncoding]
                                            options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                         documentAttributes:nil error:nil];
    
    UIFont *replacementFont =  [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    [attString addAttribute:NSFontAttributeName value:replacementFont range:NSMakeRange(0,attString.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,attString.length)];
    
    cell.detailLabel.attributedText = attString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellArray = [listJSON objectAtIndex:indexPath.row];
    
    ActivityDetail *atd = [[ActivityDetail alloc]initWithNibName:@"ActivityDetail" bundle:nil];
    atd.rewardID = [cellArray objectForKey:@"id"];
    [self.navigationController pushViewController:atd animated:YES];
}

- (IBAction)userClick:(id)sender
{
    RewardHistory *rwd = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardHistory"];
    [self.navigationController pushViewController:rwd animated:YES];
}

- (IBAction)redeemClick:(id)sender
{
    ActivityJoinList *ajl = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityJoinList"];
    [self.navigationController pushViewController:ajl animated:YES];
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
