//
//  ChatRoom.m
//  PMS
//
//  Created by Truk Karawawattana on 7/2/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import "ChatRoom.h"
#import "ChatBubbleCell.h"
#import "ChatMessage.h"
#import "Tabbar.h"
#import "Navi.h"
#import "Web.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <KSPhotoBrowser/KSPhotoBrowser.h>

@interface ChatRoom () <ChatBubbleCellDelegate,ChatBubbleCellDataSource,SDWebImageManagerDelegate>
{
    KSPhotoBrowser *browser;
}
@property (nonatomic, strong) NSMutableArray *messages;
@end

@implementation ChatRoom

@synthesize fromID,toID,companyID,adminName,headerView,headerTitle,headerLBtn,headerRBtn,titleLabel,myTable,chatView,chatBox,chatField,chatBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    headerTitle.text = adminName;
    
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [headerRBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [myTable addSubview:refreshController];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                             target:self
                                           selector:@selector(loadChat)
                                           userInfo:nil
                                            repeats:YES];
    
    chatField.delegate = self;
    chatField.font = [UIFont fontWithName:delegate.fontRegular size:20];
    
    //chatView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    //chatView.layer.borderWidth = 1.0f;
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, chatView.frame.size.width, 1.0f);
    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [chatView.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, chatView.frame.size.height-1, chatView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [chatView.layer addSublayer:bottomBorder];
    
    fromID = delegate.userID;
    toID = @"0";
    companyID = @"";
    
    myTable.delegate = self;
    myTable.dataSource = self;
    
    myTable.backgroundColor = [UIColor whiteColor];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [myTable setContentInset:UIEdgeInsetsMake(15, 0, 30, 0)]; // top, left, bottom, right
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [myTable addGestureRecognizer:tap];
    
    messageFont = [UIFont fontWithName:delegate.fontRegular size:20];
    timeFont = [UIFont fontWithName:delegate.fontLight size:17];
    
    keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = NO;
    keyboardManager.enableAutoToolbar = NO;
    
    // setup keyboard observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardCameUp:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWentAway:) name:UIKeyboardWillHideNotification object:nil];
    
    [self loadChat];
}

- (void)viewDidAppear:(BOOL)animated {
    //[myTable reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)handleRefresh : (id)sender
{
    [self loadChat];
}

- (void)loadChat
{
    //[SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@index.php?MobileApi_Chat/private_message_list/%@",delegate.serverURLshort,fromID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
        NSLog(@"chatJSON %@",responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
            //[SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
            chatJSON = [[responseObject objectForKey:@"data"] mutableCopy];
            
            self.messages = [[NSMutableArray alloc] init];
            NSMutableArray *tempArray;
            NSMutableDictionary *tempDict;
            for(int i = 0; i < [chatJSON count]; i++)
            {
                tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setObject:[chatJSON[i] objectForKey:@"on_date"] forKey:@"on_date"];
                
                NSMutableArray *JSONArray = [chatJSON[i] objectForKey:@"message_detail"];
                
                tempArray = [[NSMutableArray alloc] init];
                
                for(int j = 0; j < [JSONArray count]; j++)
                {
                    [tempArray addObject:[ChatMessage
                                          messageWithString:[JSONArray[j] objectForKey:@"text"]
                                          from:[JSONArray[j] objectForKey:@"who_message"]
                                          type:[JSONArray[j] objectForKey:@"type"]
                                          time:[JSONArray[j] objectForKey:@"addtime"]
                                          thumbnail:[JSONArray[j] objectForKey:@"video_thumbnail"]
                                          ]];
                }
                [tempDict setObject:tempArray forKey:@"message_detail"];
                [self.messages addObject:tempDict];
            }
            [myTable reloadData];
            
            [refreshController endRefreshing];
            
            if (!firstTime) {
                firstTime = YES;
                //[myTable beginUpdates];
                //[myTable endUpdates];
                [self scrollToTheBottom:NO];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //[self scrollToTheBottom:NO];
                });
            }
            
            [SVProgressHUD dismiss];
        }
        else{
            //[SVProgressHUD showErrorWithStatus:[[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"error"]];
            [SVProgressHUD dismissWithDelay:3];
        }
    }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
        NSLog(@"Error %@",error);
        [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
    }];
}

- (void)scrollToTheBottom:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[self.messages[self.messages.count-1] objectForKey:@"message_detail"] count]-1 inSection:self.messages.count-1];
    [myTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.messages count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.view.frame.size.width/10;;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ChatBubbleCell *headerCell = (ChatBubbleCell *)[tableView dequeueReusableCellWithIdentifier:@"SectionHeader"];
    
    NSDate *messageDate = [delegate getFromServerDate:[self.messages[section] objectForKey:@"on_date"]];
    
    NSString *preferLang = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:preferLang];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:locale];
    [df setDateFormat:@"EEE, dd/MM"];
    NSString *convertDate = [df stringFromDate:messageDate];
    
    if ([self dateCompareWithDateOne:messageDate withDateTwo:[NSDate date]]) {
        if ([preferLang isEqualToString:@"th"]) {
            headerCell.dateLabel.text = @"  วันนี้  ";
        }
        else
        {
            headerCell.dateLabel.text = @"  Today  ";
        }
    }
    else
    {
        headerCell.dateLabel.text = [NSString stringWithFormat:@"  %@  ",convertDate];
    }
    headerCell.dateLabel.font = timeFont;
    headerCell.dateLabel.textColor = [UIColor whiteColor];
    headerCell.dateLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    headerCell.dateLabel.layer.cornerRadius = 8;
    headerCell.dateLabel.layer.masksToBounds = YES;
    return headerCell;
}

- (BOOL)dateCompareWithDateOne:(NSDate *)dateOne withDateTwo:(NSDate *)dateTwo
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:dateOne];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:dateTwo];
    BOOL sameDay = [comp1 day]  == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year]  == [comp2 year] ;
    
    return sameDay;// ? !sameDay : ([dateOne compare:dateTwo] == NSOrderedAscending);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.messages[section] objectForKey:@"message_detail"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bubble Cell";
    
    ChatBubbleCell *cell = (ChatBubbleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ChatBubbleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = myTable.backgroundColor;
        //cell.backgroundColor = [UIColor greenColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataSource = self;
        cell.delegate = self;
    }
    
    ChatMessage *message = [self.messages[indexPath.section] objectForKey:@"message_detail"][indexPath.row];
    
    cell.textLabel.font = messageFont;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    //cell.textLabel.backgroundColor = [UIColor redColor];
    cell.textLabel.text = message.message;
    
    cell.detailTextLabel.font = timeFont;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    //cell.detailTextLabel.backgroundColor = [UIColor yellowColor];
    cell.detailTextLabel.text = message.time;
    
    cell.imageView.image = message.avatar;
    
    // Put your own logic here to determine the author
    if([message.from isEqualToString:@"my"])
    {
        cell.authorType = ChatBubbleCellAuthorTypeSelf;
        cell.bubbleColor = ChatBubbleCellBubbleSelf;
    }
    else
    {
        cell.authorType = ChatBubbleCellAuthorTypeOther;
        cell.bubbleColor = ChatBubbleCellBubbleRecieve;
    }
    
    if([message.type isEqualToString:@"pic"])
    {
        cell.textLabel.hidden = YES;
        cell.bubbleColor = ChatBubbleCellBubblePic;
        [cell.bubbleView setContentMode:UIViewContentModeScaleAspectFill];
        [cell.bubbleView sd_setImageWithURL:[NSURL URLWithString:message.message] placeholderImage:[UIImage imageNamed:@"placeholder_white"] options:SDWebImageRefreshCached];
    }
    else if([message.type isEqualToString:@"video"])
    {
        cell.textLabel.hidden = YES;
        cell.bubbleColor = ChatBubbleCellBubblePic;
        [cell.bubbleView setContentMode:UIViewContentModeScaleAspectFill];
        [cell.bubbleView sd_setImageWithURL:[NSURL URLWithString:message.thumbnail] placeholderImage:[UIImage imageNamed:@"placeholder_white"] options:SDWebImageRefreshCached];
    }
    else
    {
        cell.textLabel.hidden = NO;
        [cell.bubbleView setContentMode:UIViewContentModeScaleToFill];
        cell.bubbleView.image = nil;
        if([message.from isEqualToString:@"my"])
        {
            cell.bubbleColor = ChatBubbleCellBubbleSelf;
        }
        else
        {
            cell.bubbleColor = ChatBubbleCellBubbleRecieve;
        }
    }
    
    return cell;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ChatBubbleCell *cell = (ChatBubbleCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    ChatMessage *message = [self.messages[indexPath.section] objectForKey:@"message_detail"][indexPath.row];
    
    CGSize size;
    CGSize detailsize;
    
    if ([message.type isEqualToString:@"pic"]||[message.type isEqualToString:@"video"]) {
        //UIImage *img = [UIImage imageNamed:@"test_pic"];
        //CGFloat ratio = img.size.height/img.size.width;
        /*
         CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL URLWithString:message.message], NULL);
         NSDictionary* imageHeader = (__bridge NSDictionary*) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
         CGFloat ratio = [[imageHeader objectForKey:@"PixelHeight"] floatValue]/[[imageHeader objectForKey:@"PixelWidth"] floatValue];
         */
        CGFloat width = myTable.frame.size.width*0.65;
        CGFloat height = (width/4)*3;//width*ratio;
        size = CGSizeMake(width,height);
        
        detailsize = [message.message boundingRectWithSize:CGSizeMake(myTable.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - ChatBubbleCellWidthOffset, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:timeFont}
                                                   context:nil].size;
    }
    else if(message.avatar)
    {
        size = [message.message boundingRectWithSize:CGSizeMake(myTable.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - ChatBubbleCellImageSize - 8.0f - ChatBubbleCellWidthOffset, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:messageFont}
                                             context:nil].size;
        
        detailsize = [message.time boundingRectWithSize:CGSizeMake(myTable.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - ChatBubbleCellImageSize - 8.0f - ChatBubbleCellWidthOffset, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:timeFont}
                                                context:nil].size;
    }
    else
    {
        size = [message.message boundingRectWithSize:CGSizeMake(myTable.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - ChatBubbleCellWidthOffset, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:messageFont}
                                             context:nil].size;
        
        detailsize = [message.message boundingRectWithSize:CGSizeMake(myTable.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - ChatBubbleCellWidthOffset, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:timeFont}
                                                   context:nil].size;
    }
    
    // This makes sure the cell is big enough to hold the avatar
    if(size.height + detailsize.height + 30.0f < ChatBubbleCellImageSize + 4.0f && message.avatar)
    {
        return ChatBubbleCellImageSize + 4.0f;
    }
    
    return size.height + detailsize.height + 30.0f;
}

#pragma mark - STBubbleTableViewCellDataSource methods

- (CGFloat)minInsetForCell:(ChatBubbleCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    /*
     if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
     {
     return 100.0f;
     }
     */
    return 50.0f;
}

#pragma mark - STBubbleTableViewCellDelegate methods

- (void)tappedImageOfCell:(ChatBubbleCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ChatMessage *message = [self.messages[indexPath.section] objectForKey:@"message_detail"][indexPath.row];
    
    if([message.type isEqualToString:@"pic"])
    {
        NSArray *urls = @[message.message];
        NSMutableArray *items = @[].mutableCopy;
        for (int i = 0; i < urls.count; i++) {
            // Get the large image url
            NSString *url = [urls[i] stringByReplacingOccurrencesOfString:@"bmiddle" withString:@"large"];
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.bubbleView imageUrl:[NSURL URLWithString:url]];
            [items addObject:item];
        }
        browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
        
        [browser showFromViewController:self];
    }
    else if([message.type isEqualToString:@"video"])
    {
        //Tabbar *tab = (Tabbar*)[[UIApplication sharedApplication].delegate.window.rootViewController.childViewControllers objectAtIndex:1];
        //Navi *navi = tab.selectedViewController;
        UINavigationController *navi = self.navigationController;
        
        Web *web = [[Web alloc]initWithNibName:@"Web" bundle:nil];
        //web.urlStr = @"https://www.dropbox.com/s/qg15oseebgop48d/Celebrity%20Interview%20%E0%B9%80%E0%B8%99%E0%B8%A2%20Neko%20Jump%20by%20PLAYBOY%20THAILAND.mp4?dl=0";
        web.urlStr = message.message;//@"https://www.youtube.com/watch?v=noEhgQ0hI6M";
        web.titleStr = @"Video";
        [navi pushViewController:web animated:YES];
    }
}

- (void)closePhotoView
{
    [browser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Keyboard methods

- (void)keyboardWillChange:(NSNotification *)notification {
    // Get duration of keyboard appearance/ disappearance animation
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions animationOptions = animationCurve | (animationCurve << 16); // Convert animation curve to animation option
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Get the final size of the keyboard
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Calculate the new bottom constraint, which is equal to the size of the keyboard
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat newBottomConstraint = (screen.size.height-keyboardEndFrame.origin.y);
    
    // Keep old y content offset and height before they change
    CGFloat oldYContentOffset = myTable.contentOffset.y;
    CGFloat oldTableViewHeight = myTable.bounds.size.height;
    
    [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
        // Set the new bottom constraint
        self.layoutConstraintContentViewBottomWithSendMessageViewBottom.constant = newBottomConstraint;
        // Request layout with the new bottom constraint
        [self.view layoutIfNeeded];
        
        // Calculate the new y content offset
        CGFloat newTableViewHeight = myTable.bounds.size.height;
        CGFloat contentSizeHeight = myTable.contentSize.height;
        CGFloat newYContentOffset = oldYContentOffset - newTableViewHeight + oldTableViewHeight;
        
        // Prevent new y content offset from exceeding max, i.e. the bottommost part of the UITableView
        CGFloat possibleBottommostYContentOffset = contentSizeHeight - newTableViewHeight;
        newYContentOffset = MIN(newYContentOffset, possibleBottommostYContentOffset);
        
        // Prevent new y content offset from exceeding min, i.e. the topmost part of the UITableView
        CGFloat possibleTopmostYContentOffset = 0;
        newYContentOffset = MAX(possibleTopmostYContentOffset, newYContentOffset);
        
        // Create new content offset
        CGPoint newTableViewContentOffset = CGPointMake(myTable.contentOffset.x, newYContentOffset);
        myTable.contentOffset = newTableViewContentOffset;
        
    } completion:nil];
}

- (void)keyboardCameUp:(NSNotification *)notification {
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Calculate the new bottom constraint, which is equal to the size of the keyboard
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat newBottomConstraint = (screen.size.height-keyboardEndFrame.origin.y-self.view.safeAreaInsets.bottom);
    
    self.layoutConstraintContentViewBottomWithSendMessageViewBottom.constant = newBottomConstraint;
    // Request layout with the new bottom constraint
    [self.view layoutIfNeeded];
    NSLog(@"Keyboard came up!");
}

- (void)keyboardWentAway:(NSNotification *)notification {
    self.layoutConstraintContentViewBottomWithSendMessageViewBottom.constant = 0;
    // Request layout with the new bottom constraint
    [self.view layoutIfNeeded];
    NSLog(@"Keyboard went away!");
}

-(void)dismissKeyboard {
    [chatField resignFirstResponder];
}

#pragma mark - Chat methods

- (IBAction)chatClick:(id)sender
{
    if (![chatField.text isEqualToString:@""]) {
        [self sendChat];
    }
}

- (void)sendChat
{
    //[SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@index.php?MobileApi_Chat/send_message_private_chat_wanlanid",delegate.serverURLshort];
    
    NSDictionary *parameters = @{@"from_id":fromID,
                                 @"to_id":toID,
                                 @"company_id":companyID,
                                 @"message":chatField.text,
                                 @"type":@"message"
    };
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
        NSLog(@"chatSendJSON %@",responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
            //[SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
            
            chatField.text = @"";
            [chatField resignFirstResponder];
            [SVProgressHUD dismiss];
            
            firstTime = NO;
            [self loadChat];
        }
        else{
            [SVProgressHUD showErrorWithStatus:[[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"error"]];
            [SVProgressHUD dismissWithDelay:3];
        }
    }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
        NSLog(@"Error %@",error);
        [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
    }];
}

- (IBAction)cameraClick:(id)sender
{
    [delegate choosePhotoOnViewcontroller:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    CGFloat ratio = image.size.height/image.size.width;
    CGFloat width;
    CGFloat height;
    if (image.size.width > image.size.height) {
        width = 500;
        height = width*ratio;
    }
    else{
        height = 500;
        width = height/ratio;
    }
    CGSize size = CGSizeMake(width,height);
    image = [self imageWithImage:image scaledToSize:size];
    
    imageData = UIImageJPEGRepresentation(image,1.0);
    
    if ([imageData length]>0) {
        imageExisted = YES;
        
        //[picView setImage:image];
        
        [SVProgressHUD showWithStatus:@"Loading"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString* url = [NSString stringWithFormat:@"%@index.php?MobileApi_Chat/send_message_private_chat_wanlanid",delegate.serverURLshort];
        
        NSDictionary *parameters = @{@"from_id":fromID,
                                     @"to_id":toID,
                                     @"company_id":companyID,
                                     @"message":chatField.text,
                                     @"type":@"pic"
        };
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:url parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
            if (imageExisted == YES) {
                [formData appendPartWithFileData:imageData name:@"pic" fileName:@"message.jpg" mimeType:@"image/jpeg"];
            }
        } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            if ([[responseObject objectForKey:@"status"]isEqualToString:@"success"])
            {
                firstTime = NO;
                [self loadChat];
                [SVProgressHUD dismiss];
            }
            else{
                [SVProgressHUD showErrorWithStatus:[[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"error"]];
                [SVProgressHUD dismissWithDelay:3];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //NSLog(@"Error %@",error);
            [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
        }];
    }
    else
    {
        imageExisted = NO;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [timer invalidate];
    timer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

