//
//  JSONModel.h
//  Mangkud
//
//  Created by Firststep Consulting on 16/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *identifier;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
