//
//  Profile.m
//  PMS
//
//  Created by Truk Karawawattana on 14/2/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import "Profile.h"
#import "Personal_1.h"
#import "Personal_2.h"
#import "Personal_3.h"
#import "GivePoint.h"

@interface Profile ()

@end

@implementation Profile

@synthesize givePointStatus,titleLabel,givePointBtn,toolBar,targetView;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.text = @"We Personal";
    
    if (givePointStatus) {
        givePointBtn.hidden = NO;
    }
    else
    {
        givePointBtn.hidden = YES;
    }
        
        carbonTabSwipeNavigation = [[CarbonTabSwipeNavigation alloc] initWithItems:@[@"บัตรพนักงาน",
                                                                                     @"ข้อมูลติดต่อ",
                                                                                     @"โปรไฟล์"] delegate:self];
    
    [carbonTabSwipeNavigation insertIntoRootViewController:self andTargetView:self.targetView];
    
    [self style];
}

- (void)style {
    
    /*
     UIColor *color = [UIColor colorWithRed:243.0 / 255 green:75.0 / 255 blue:152.0 / 255 alpha:1];
     self.navigationController.navigationBar.translucent = NO;
     self.navigationController.navigationBar.tintColor = [UIColor redColor];
     self.navigationController.navigationBar.barTintColor = color;
     self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    */
    
    carbonTabSwipeNavigation.toolbar.layer.borderColor = [[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1] CGColor];
    carbonTabSwipeNavigation.toolbar.layer.borderWidth = 1;
    
    //carbonTabSwipeNavigation.toolbar.backgroundColor = [UIColor redColor];
    carbonTabSwipeNavigation.toolbar.barTintColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
    carbonTabSwipeNavigation.toolbar.translucent = NO;
    carbonTabSwipeNavigation.toolbar.clipsToBounds = YES;
    [carbonTabSwipeNavigation setIndicatorColor:delegate.mainThemeColor];
    [carbonTabSwipeNavigation setIndicatorHeight:4];
    
    carbonTabSwipeNavigation.toolbarHeight = [NSLayoutConstraint constraintWithItem:carbonTabSwipeNavigation.toolbar
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0
                                                                           constant:50];
    [self.view addConstraint:carbonTabSwipeNavigation.toolbarHeight];
    
    [carbonTabSwipeNavigation setTabExtraWidth:0];
    
    
    int width = [UIScreen mainScreen].bounds.size.width/3;
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:[UIScreen mainScreen].bounds.size.width*0.35 forSegmentAtIndex:0];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:[UIScreen mainScreen].bounds.size.width*0.35 forSegmentAtIndex:1];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:[UIScreen mainScreen].bounds.size.width*0.3 forSegmentAtIndex:2];
    
    // Custimize segmented control
    
    [carbonTabSwipeNavigation setNormalColor:[[UIColor grayColor] colorWithAlphaComponent:1.0] font:[UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3]];
    [carbonTabSwipeNavigation setSelectedColor:delegate.mainThemeColor font:[UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3]];
    [carbonTabSwipeNavigation setCurrentTabIndex:0];
}

#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation
                                 viewControllerAtIndex:(NSUInteger)index
{
    UIViewController *vc;
    
    switch (index) {
        case 0:
            //vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Mylist"];
            vc = [[Personal_1 alloc]initWithNibName:@"Personal_1" bundle:nil];
            break;
            
        case 1:
            vc = [[Personal_2 alloc]initWithNibName:@"Personal_2" bundle:nil];
            break;
            
        case 2:
            vc = [[Personal_3 alloc]initWithNibName:@"Personal_3" bundle:nil];
            break;
    }
    
    return vc;
}

// optional
- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                 willMoveAtIndex:(NSUInteger)index
{
    NSLog(@"Will move to index: %ld", (unsigned long)index);
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
    //NSLog(@"Did move at index: %ld", (unsigned long)index);
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}

- (IBAction)rightMenuClick:(id)sender
{
    GivePoint *gp = [[GivePoint alloc]initWithNibName:@"GivePoint" bundle:nil];
    [self.navigationController pushViewController:gp animated:YES];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
