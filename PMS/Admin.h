//
//  Admin.h
//  Mangkud
//
//  Created by Firststep Consulting on 21/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Admin : UIViewController
{
    AppDelegate *delegate;
}

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (retain, nonatomic) IBOutlet UIButton *webBtn;
@end
