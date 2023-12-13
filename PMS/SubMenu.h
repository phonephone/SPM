//
//  SubMenu.h
//  PMS
//
//  Created by Truk Karawawattana on 29/1/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubMenu : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *delegate;
    
    NSString* url;
    
    float rowHeight;
}
@property (nonatomic) NSString *mainMenuID;
@property (nonatomic) NSString *subMenuTitle;
@property (nonatomic) NSMutableArray *subArray;

@property (retain, nonatomic) IBOutlet UITableView *myTable;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
