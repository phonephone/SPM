//
//  ActivityList.h
//  PMS
//
//  Created by Truk Karawawattana on 8/3/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityList : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *delegate;
    NSMutableArray *listJSON;
    NSMutableDictionary *scoreJSON;
    NSMutableDictionary *profileJSON;
}

@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UIButton *redeemBtn;
@end

NS_ASSUME_NONNULL_END
