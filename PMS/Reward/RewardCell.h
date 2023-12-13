//
//  RewardCell.h
//  PMS
//
//  Created by Truk Karawawattana on 28/2/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RewardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rewardPic;
@property (weak, nonatomic) IBOutlet UIButton *rewardBtn;

@end

NS_ASSUME_NONNULL_END
