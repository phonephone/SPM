//
//  ActivityDetail.h
//  PMS
//
//  Created by Truk Karawawattana on 8/3/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityDetail : UIViewController
{
    AppDelegate *delegate;
    NSMutableDictionary *listJSON;
    NSMutableDictionary *redeemJSON;
}
@property (nonatomic) NSString *rewardID;

@property (weak, nonatomic) IBOutlet UIImageView *rewardPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollDetail;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

NS_ASSUME_NONNULL_END
