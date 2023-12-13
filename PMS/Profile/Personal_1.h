//
//  Personal_1.h
//  PMS
//
//  Created by Truk Karawawattana on 14/2/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface Personal_1 : UIViewController
{
    AppDelegate *delegate;
    NSMutableDictionary *profileJSON;
    
    int picTapCount;
}

@property(weak, nonatomic) IBOutlet UIView *cardView;
@property(weak, nonatomic) IBOutlet UIImageView *logoPic;
@property(weak, nonatomic) IBOutlet UIImageView *logoPic2;
@property(weak, nonatomic) IBOutlet UIImageView *profilePic;
@property(weak, nonatomic) IBOutlet UIImageView *qrPic;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;


@end

NS_ASSUME_NONNULL_END
