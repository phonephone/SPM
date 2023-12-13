//
//  RewardCell.m
//  PMS
//
//  Created by Truk Karawawattana on 28/2/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import "RewardCell.h"

@implementation RewardCell

@synthesize nameLabel,detailLabel,pointLabel,rewardPic,rewardBtn;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
