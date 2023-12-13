//
//  MenuCell.m
//  Mangkud
//
//  Created by Firststep Consulting on 28/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

@synthesize menuLabel,menuAlert,menuArrow,scoreLabel,menuCellBg,menuPic,menuTitle,menuIcon,menuSwitch;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
