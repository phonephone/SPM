//
//  Agenda.m
//  Mangkud
//
//  Created by Firststep Consulting on 31/5/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Agenda.h"
#import "AgendaCell.h"
#import "LeaveCell.h"
#import "LeftMenu.h"
#import "MainMenu.h"
#import "ChatRoom.h"

@interface Agenda ()

@end

@implementation Agenda

@synthesize titleLabel,myTable;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    [self loadAgenda];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    NSLocale *localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    df = [[NSDateFormatter alloc] init];
    [df setLocale:localeEN];
    
    NSLocale *localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df2 = [[NSDateFormatter alloc] init];
    [df2 setLocale:localeTH];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineAction:) name:@"CheckConnection" object:nil];
}

-(void)onlineAction:(NSNotification *)noti
{
    [self loadAgenda];
}

- (void)loadAgenda
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@empCalendar/%@",delegate.serverURL,delegate.userID];
    //NSString* url = [NSString stringWithFormat:@"%@empCalendar/304",delegate.serverURL];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"AgendaJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             agendaJSON = [responseObject objectForKey:@"data"];
             if (agendaJSON.count != 0) {
                 [self sortMonth];
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

- (void)sortMonth
{
    sortJSON = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSString *yearMonth;
    NSString *previousYearMonth;
    int section = 0;
    int row = 0;
    NSIndexPath *scrollIndexPath;
    
    for (int i=0; i<[agendaJSON count]; i++)
    {
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *checkDate = [df dateFromString:[[agendaJSON objectAtIndex:i] objectForKey:@"date"]];
        [df setDateFormat:@"yyyyMM"];
        yearMonth = [df stringFromDate:checkDate];
        
        if (i == 0) {
            [tempArray addObject:[agendaJSON objectAtIndex:i]];
            previousYearMonth = yearMonth;
        }
        else if (![yearMonth isEqualToString:previousYearMonth]) {
            [sortJSON addObject:tempArray];
            //[tempArray removeAllObjects];
            tempArray = [[NSMutableArray alloc] init];
            [tempArray addObject:[agendaJSON objectAtIndex:i]];
            previousYearMonth = yearMonth;
            section++;
            row = 0;
        }
        else{
            [tempArray addObject:[agendaJSON objectAtIndex:i]];
            row++;
        }
        
        if ([[[agendaJSON objectAtIndex:i] objectForKey:@"today_flag"] isEqualToString:@"1"]) {
            scrollIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
        }
    }
    [sortJSON addObject:tempArray];
    [myTable reloadData];
    
    [myTable scrollToRowAtIndexPath:scrollIndexPath
                   atScrollPosition:UITableViewScrollPositionTop
                           animated:NO];
    //NSLog(@"SORTTTTT %@",sortJSON);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sortJSON count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.view.frame.size.height/20;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LeaveCell *headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"SectionHeader"];
    
    headerCell.Label1.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize+2];
    
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *agendaDate = [df dateFromString:[[[sortJSON objectAtIndex:section] objectAtIndex:0] objectForKey:@"date"]];
    [df2 setDateFormat:@"MMMM"];
    headerCell.Label1.text = [df2 stringFromDate:agendaDate];
    
    return headerCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sortJSON objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowHeight;
    
    rowHeight = (self.view.frame.size.width*0.3);
    
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AgendaCell *cell = (AgendaCell *)[tableView dequeueReusableCellWithIdentifier:@"AgendaCell"];
    
    NSDictionary *cellArray = [[sortJSON objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *colorCode = [cellArray objectForKey:@"color"];
    NSArray *listItems = [colorCode componentsSeparatedByString:@", "];
    float red = [[listItems objectAtIndex:0] floatValue];
    float green = [[listItems objectAtIndex:1] floatValue];
    float blue = [[listItems objectAtIndex:2] floatValue];
    
    cell.colorView.backgroundColor= [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
    
    if ([[cellArray objectForKey:@"today_flag"] isEqualToString:@"1"]) {
        colorCode = [cellArray objectForKey:@"today_color"];
        listItems = [colorCode componentsSeparatedByString:@", "];
        red = [[listItems objectAtIndex:0] floatValue];
        green = [[listItems objectAtIndex:1] floatValue];
        blue = [[listItems objectAtIndex:2] floatValue];
        cell.bgView.backgroundColor= [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
    }
    else
    {
        cell.bgView.backgroundColor= [UIColor whiteColor];
    }
    
    cell.dateLabel.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize+24];
    cell.dayLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+1];
    //cell.monthLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-3];
    cell.titleLabel.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize+2];
    cell.datailLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *agendaDate = [df dateFromString:[cellArray objectForKey:@"date"]];
    
    
    [df2 setDateFormat:@"d"];
    cell.dateLabel.text = [df2 stringFromDate:agendaDate];
    
    [df2 setDateFormat:@"MMMM"];
    cell.monthLabel.text = [df2 stringFromDate:agendaDate];
    
    [df2 setDateFormat:@"EEE"];
    cell.dayLabel.text = [df2 stringFromDate:agendaDate];
    
    
    if ([[cellArray objectForKey:@"hbd_flag"] isEqualToString:@"1"]) {
        
        NSString *topString = [NSString stringWithFormat:@"%@ \xF0\x9F\x8E\x82 \xF0\x9F\x8E\x89",[cellArray objectForKey:@"title"]];
        NSString *bottomString = [cellArray objectForKey:@"description"];
        
        NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",topString,bottomString]];
        
        UIFont *replacementFont =  [UIFont fontWithName:delegate.fontBold size:delegate.fontSize+4];
        [attString addAttribute:NSFontAttributeName value:replacementFont range:NSMakeRange(0,topString.length)];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:254.0/255 green:160.0/255 blue:39.0/255 alpha:1] range:NSMakeRange(0,topString.length)];
        
        UIFont *replacementFont2 =  [UIFont fontWithName:delegate.fontMedium size:delegate.fontSize+2];
        [attString addAttribute:NSFontAttributeName value:replacementFont2 range:NSMakeRange(topString.length+1,bottomString.length)];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:31.0/255 green:150.0/255 blue:98.0/255 alpha:1] range:NSMakeRange(topString.length+1,bottomString.length)];
        cell.titleLabel.attributedText = attString;
        cell.datailLabel.hidden = YES;
    }
    else{
        cell.titleLabel.text = [cellArray objectForKey:@"title"];
        cell.datailLabel.text = [cellArray objectForKey:@"description"];
        cell.datailLabel.hidden = NO;
    }

    //[df2 setDateFormat:@"yy"];
    //myYearString = [df2 stringFromDate:agendaDate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightMenu:(id)sender {
    //AdminChatWeb *viewController = [[AdminChatWeb alloc]initWithNibName:@"AdminChatWeb" bundle:nil];
    //[self.navigationController pushViewController:viewController animated:YES];
    
    ChatRoom *cr = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatRoom"];
    cr.fromID = delegate.userID;
    //cr.toID = [[listJSON objectAtIndex:indexPath.row] objectForKey:@"user"];
    [self.navigationController pushViewController:cr animated:YES];
}

- (void)alertTitle:(NSString*)title detail:(NSString*)alertDetail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:alertDetail preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
