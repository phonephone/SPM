//
//  Setting.h
//  PMS
//
//  Created by Truk Karawawattana on 14/3/2564 BE.
//  Copyright © 2564 BE TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Setting : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *delegate;
    NSMutableIndexSet *expandedSections;
    
    NSDictionary *parameters;
}

@property (retain, nonatomic) IBOutlet UITableView *myTable;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@end
