//
//  Approve.h
//  Mangkud
//
//  Created by Firststep Consulting on 5/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Approve : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *delegate;
    NSMutableDictionary *approveJSON;
}
@property (nonatomic) NSString *mode;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITableView *myTable;

- (void)loadList;
@end
