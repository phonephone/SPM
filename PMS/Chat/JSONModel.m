//
//  JSONModel.m
//  Mangkud
//
//  Created by Firststep Consulting on 16/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "JSONModel.h"

@implementation JSONModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _identifier = [self uniqueIdentifier];
        _title = dictionary[@"title"];
        _content = dictionary[@"content"];
        _username = dictionary[@"username"];
        _time = dictionary[@"time"];
        _imageName = dictionary[@"imageName"];
    }
    return self;
}


- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}
@end
