//
//  UserReport.m
//  Mangkud
//
//  Created by Firststep Consulting on 14/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "UserReport.h"

@interface UserReport ()

@end

@implementation UserReport
@synthesize titleLabel,dateLabel,dateField,dateBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+8];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    dateLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
    dateField.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+1];
    
    NSLocale *localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:localeTH];
    
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setMaximumDate: [NSDate date]];
    [datePicker setLocale:localeTH];
    datePicker.calendar = [localeTH objectForKey:NSLocaleCalendar];
    datePicker.tag = 1;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 13.4, *)) {
        datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    
    dateField.inputView = datePicker;
    [df setDateFormat:@"MMMM yyyy"];
    dateField.text = [df stringFromDate:[NSDate date]];
    _filterDate = [NSDate date];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    _calendarManager.dateHelper.calendar.firstWeekday = 2;//(1 for Sunday, 2 for Monday, ...)
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    switch (datePicker.tag) {
        case 1://Start Date
            [df setDateFormat:@"MMMM yyyy"];
            dateField.text = [df stringFromDate:datePicker.date];
            _filterDate = datePicker.date;
            [_calendarManager setDate:datePicker.date];
            
            //[df setDateFormat:@"yyyy-MM-dd"];
            //goDate = [df stringFromDate:datePicker.date];
            break;
    }
}

- (IBAction)dateClicked:(id)sender
{
    [dateField becomeFirstResponder];
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    NSDateFormatter *df = [_calendarManager.dateHelper createDateFormatter];
    df.dateFormat = @"yyyy'-'MM'-'dd' 'HH':'mm':'ss";
    //NSLog(@"%@", [dateFormatter stringFromDate:dayView.date]);
    
    dayView.hidden = NO;
    
    // Test if the dayView is from another month than the page
    // Use only in month mode for indicate the day of the previous or next month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor lightGrayColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1];
    }
    
    // Your method to test if a date have an event for example
    int event = arc4random() % 3; //random 0-2
    if(event == 1){
        dayView.dotView.hidden = NO;
        dayView.dotView.backgroundColor = [UIColor colorWithRed:59.0/255 green:129.0/255 blue:61.0/255 alpha:1];
    }
    else if(event == 2){
        dayView.dotView.hidden = NO;
        dayView.dotView.backgroundColor = [UIColor redColor];
    }
    else{
        dayView.dotView.hidden = YES;
    }
    
    //Set Sat&Sun
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"e"];
    NSInteger weekdayNumber = (NSInteger)[[dateFormatter stringFromDate:dayView.date] integerValue];
    int numberDayOfWeek = (int)weekdayNumber;
    if (numberDayOfWeek == 1) {//SUN
        dayView.dotView.hidden = YES;
        //dayView.textLabel.textColor = [UIColor redColor];
        //dayView.textLabel.font = [UIFont fontWithName:delegate.fontBold size:delegate.fontSize];
    } else if (numberDayOfWeek == 7) {//SAT
        dayView.dotView.hidden = YES;
        //dayView.textLabel.textColor = [UIColor purpleColor];
        //dayView.textLabel.font = [UIFont fontWithName:delegate.fontBold size:delegate.fontSize];
    }
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    view.textLabel.font = [UIFont fontWithName:delegate.fontLight size:delegate.fontSize];
    //view.textLabel.textColor = [UIColor lightGrayColor];
    view.circleRatio = 0.6;
    view.dotRatio = 0.19;
    return view;
}

- (UIView<JTCalendarWeekDay> *)calendarBuildWeekDayView:(JTCalendarManager *)calendar
{
    JTCalendarWeekDayView *view = [JTCalendarWeekDayView new];
    for(int i = 0; i < view.dayViews.count; ++i){
        UILabel *weekDayLabel = [view.dayViews objectAtIndex:i];
        weekDayLabel.textColor = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1];
        weekDayLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize];
    }
    return view;
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    // Use to indicate the selected date
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *arbitraryDate = _filterDate;//[NSDate date];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:arbitraryDate];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comp];
    
    NSRange dim = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:arbitraryDate];
    comp.day = dim.length;
    NSDate *lastDayOfMonthDate = [gregorian dateFromComponents:comp];
    
    return [_calendarManager.dateHelper date:date isEqualOrAfter:firstDayOfMonthDate andEqualOrBefore:lastDayOfMonthDate];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertTitle:(NSString*)title detail:(NSString*)alertDetail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:alertDetail preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
