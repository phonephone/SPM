//
//  Leave_Left.h
//  PMS
//
//  Created by Firststep Consulting on 20/2/19.
//  Copyright © 2019 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Leave_Left : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *delegate;
    NSMutableDictionary *leaveTopicJSON;
    NSMutableDictionary *leaveJSON;
    NSMutableDictionary *summaryJSON;
    
    NSLayoutConstraint *sumViewHeight0;
    NSLayoutConstraint *sumViewHeight1;
    
    NSLocale *localeEN;
}
@property (nonatomic) NSString *mode;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UIView *sumView;

@property (retain, nonatomic) IBOutlet UILabel *sumTitle;
@property (retain, nonatomic) IBOutlet UILabel *sumL1;
@property (retain, nonatomic) IBOutlet UILabel *sumL2;
@property (retain, nonatomic) IBOutlet UILabel *sumL3;
@property (retain, nonatomic) IBOutlet UILabel *sumR1;
@property (retain, nonatomic) IBOutlet UILabel *sumR2;
@property (retain, nonatomic) IBOutlet UILabel *sumR3;

@property (retain, nonatomic) IBOutlet UITableView *myTable;

@property (retain, nonatomic) IBOutlet UIButton *leftBtn;
@property (retain, nonatomic) IBOutlet UIButton *addBtn;

- (void)loadList;
@end
