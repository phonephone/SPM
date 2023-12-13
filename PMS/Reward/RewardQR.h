//
//  RewardQR.h
//  PMS
//
//  Created by Truk Karawawattana on 28/2/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface RewardQR : UIViewController
{
    AppDelegate *delegate;
    NSMutableDictionary *listJSON;
}
@property (nonatomic) NSString *mode;
@property (nonatomic) NSMutableDictionary *redeemArray;

@property (weak, nonatomic) IBOutlet UIImageView *rewardPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *dateR;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *timeR;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrPic;

@end

NS_ASSUME_NONNULL_END
