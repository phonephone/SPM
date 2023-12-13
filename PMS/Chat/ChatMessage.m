//
//  ChatMessage.m
//  PMS
//
//  Created by Truk Karawawattana on 7/2/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage

+ (instancetype)messageWithString:(NSString *)message from:(NSString *)from type:(NSString *)type time:(NSString *)time thumbnail:(NSString *)thumbnail
{
    return [ChatMessage messageWithString:message from:from type:type time:time thumbnail:thumbnail image:nil];
}

+ (instancetype)messageWithString:(NSString *)message from:(NSString *)from type:(NSString *)type time:(NSString *)time thumbnail:(NSString *)thumbnail image:(UIImage *)image
{
    return [[ChatMessage alloc] initWithString:message from:from type:type time:time thumbnail:thumbnail image:image];
}

- (instancetype)initWithString:(NSString *)message from:(NSString *)from type:(NSString *)type time:(NSString *)time thumbnail:(NSString *)thumbnail
{
    return [self initWithString:message from:from type:type time:time thumbnail:thumbnail image:nil];
}

- (instancetype)initWithString:(NSString *)message from:(NSString *)from type:(NSString *)type time:(NSString *)time thumbnail:(NSString *)thumbnail image:(UIImage *)image
{
    self = [super init];
    if(self)
    {
        _message = message;
        _from = from;
        _type = type;
        _time = time;
        _thumbnail = thumbnail;
        _avatar = image;
    }
    return self;
}

@end
