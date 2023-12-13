//
//  MainMenu.h
//  PMS
//
//  Created by Truk Karawawattana on 29/1/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainMenu : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    AppDelegate *delegate;
    
    NSString* url;
    NSMutableDictionary *authorizeJSON;
    NSMutableArray *bannerJSON;
    
    int picTapCount;
    
    NSMutableArray *offlineJSON;
    int failCount;
    NSString *filePath;
    NSString *fileName;
    NSString* fileAtPath;
    
    NSTimer* bannerTimer;
}

@property (retain, nonatomic) IBOutlet UICollectionView *myCollection;
@property (retain, nonatomic) IBOutlet UIImageView *headerView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;

@property (retain, nonatomic) IBOutlet UIButton *rightMenu;

@property (retain, nonatomic) IBOutlet UIView *bannerView;
@property (retain, nonatomic) IBOutlet UIScrollView *bannerScroll;
@property (retain, nonatomic) IBOutlet UIPageControl * pageControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionBottomHeight;


- (void)reloadMainMenu;
@end

NS_ASSUME_NONNULL_END
