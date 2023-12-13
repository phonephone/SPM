//
//  MainMenuCell.h
//  PMS
//
//  Created by Truk Karawawattana on 29/1/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainMenuCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *menuTitle;
@property (weak, nonatomic) IBOutlet UIImageView *menuPic;
@property (weak, nonatomic) IBOutlet UIImageView *menuAlert;

@end

NS_ASSUME_NONNULL_END
