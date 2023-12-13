//
//  AgendaCell.m
//  Mangkud
//
//  Created by Firststep Consulting on 31/5/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "AgendaCell.h"

@implementation AgendaCell

@synthesize bgView,colorView,dateLabel,dayLabel,monthLabel,titleLabel,datailLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
