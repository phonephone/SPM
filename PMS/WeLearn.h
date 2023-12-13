//
//  WeLearn.h
//  PMS
//
//  Created by Truk Karawawattana on 14/6/2562 BE.
//  Copyright © 2562 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface WeLearn : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *delegate;
    NSMutableArray *welearnJSON;
}
@property (nonatomic) NSString *mode;
@property (nonatomic) NSString *weLearnID;
@property (nonatomic) NSDictionary *weRosterArray;
@property (nonatomic) NSString *titleStr;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITableView *myTable;

@end
