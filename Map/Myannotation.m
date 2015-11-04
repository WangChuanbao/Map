//
//  Myannotation.m
//  Map
//
//  Created by 王宝 on 15/10/22.
//  Copyright © 2015年 王宝. All rights reserved.
//

#import "Myannotation.h"

@implementation Myannotation

- (NSString *)title {
    return @"您的位置";
}

- (NSString *)subtitle {
    NSMutableString *string = [NSMutableString new];
    
    if (_state) {
        [string appendString:_state];
    }
    if (_city) {
        [string appendString:_city];
    }
    if (_state || _city) {
        [string appendString:@"－"];
    }
    if (_street) {
        [string appendString:_street];
    }
    if (_zip) {
        [string appendFormat:@"，%@",_zip];
    }
    
    return string;
}

@end
