//
//  Agenda.h
//  Mangkud
//
//  Created by Firststep Consulting on 31/5/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Agenda : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *delegate;
    NSMutableArray *agendaJSON;
    NSMutableArray *sortJSON;
    NSDateFormatter *df;
    NSDateFormatter *df2;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UITableView *myTable;

@end
