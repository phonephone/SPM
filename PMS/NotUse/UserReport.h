//
//  UserReport.h
//  Mangkud
//
//  Created by Firststep Consulting on 14/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <JTCalendar/JTCalendar.h>

@interface UserReport : UIViewController <UITextFieldDelegate,JTCalendarDelegate>
{
    AppDelegate *delegate;
    
    NSDateFormatter *df;
    UIDatePicker *datePicker;
    
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTVerticalCalendarView *calendarContentView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (strong, nonatomic) NSDate *dateSelected;
@property (strong, nonatomic) NSDate *filterDate;

@end
