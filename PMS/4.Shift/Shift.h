//
//  Shift.h
//  PMS
//
//  Created by Firststep Consulting on 24/11/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Shift : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *delegate;
    NSMutableDictionary *listJSON;
    
    NSLocale *localeTH;
    NSLocale *localeEN;
    NSDateFormatter *dfTH;
    UIDatePicker *datePicker;
    NSDate *showDate;
}
@property (nonatomic) NSString *mode;

@property (retain, nonatomic) IBOutlet UILabel *sumTitle;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

@property (retain, nonatomic) IBOutlet UILabel *sumL1;
@property (retain, nonatomic) IBOutlet UILabel *sumL2;
@property (retain, nonatomic) IBOutlet UILabel *sumL3;
@property (retain, nonatomic) IBOutlet UILabel *sumR1;
@property (retain, nonatomic) IBOutlet UILabel *sumR2;
@property (retain, nonatomic) IBOutlet UILabel *sumR3;


@property (retain, nonatomic) IBOutlet UITableView *myTable;
@property (retain, nonatomic) IBOutlet UIButton *swapBtn;
@property (retain, nonatomic) IBOutlet UIButton *acceptBtn;
@property (retain, nonatomic) IBOutlet UIButton *leftBtn;
@property (retain, nonatomic) IBOutlet UIButton *addBtn;

@property (retain, nonatomic) IBOutlet UIButton *rightMenu;

- (void)loadList:(NSDate*)date;
@end
