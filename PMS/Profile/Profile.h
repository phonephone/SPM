//
//  Profile.h
//  PMS
//
//  Created by Truk Karawawattana on 14/2/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CarbonKit/CarbonKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Profile : UIViewController <CarbonTabSwipeNavigationDelegate>
{
    AppDelegate *delegate;
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
}

@property (nonatomic) BOOL givePointStatus;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *givePointBtn;

@property(weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property(weak, nonatomic) IBOutlet UIView *targetView;


@end


NS_ASSUME_NONNULL_END
