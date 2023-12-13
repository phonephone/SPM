//
//  MenuCell.h
//  Mangkud
//
//  Created by Firststep Consulting on 28/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *menuAlert;
@property (weak, nonatomic) IBOutlet UIImageView *menuArrow;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIView *menuCellBg;
@property (weak, nonatomic) IBOutlet UIImageView *menuPic;
@property (weak, nonatomic) IBOutlet UILabel *menuTitle;

@property (weak, nonatomic) IBOutlet UIImageView *menuIcon;
@property (weak, nonatomic) IBOutlet UISwitch *menuSwitch;

@end
