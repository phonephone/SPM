//
//  ChatMessage.h
//  PMS
//
//  Created by Truk Karawawattana on 7/2/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChatMessage : NSObject

+ (instancetype)messageWithString:(NSString *)message from:(NSString *)from type:(NSString *)type time:(NSString *)time thumbnail:(NSString *)thumbnail;
+ (instancetype)messageWithString:(NSString *)message from:(NSString *)from type:(NSString *)type time:(NSString *)time thumbnail:(NSString *)thumbnail image:(UIImage *)image;

- (instancetype)initWithString:(NSString *)message from:(NSString *)from type:(NSString *)type time:(NSString *)time thumbnail:(NSString *)thumbnail;
- (instancetype)initWithString:(NSString *)message from:(NSString *)from type:(NSString *)type time:(NSString *)time thumbnail:(NSString *)thumbnail image:(UIImage *)image;

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, strong) UIImage *avatar;

@end

