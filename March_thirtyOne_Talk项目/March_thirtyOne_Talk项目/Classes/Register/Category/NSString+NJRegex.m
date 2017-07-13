//
//  NSString+NJRegex.m
//  march_six_判断是否是合法的电话号码
//
//  Created by TouchWorld on 2017/3/6.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NSString+NJRegex.h"

@implementation NSString (NJRegex)
//判断字符串(对象本身)是否符合正则表达式(regex)
- (BOOL)isMatchesWithRegex:(NSString *)regex;
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    return [predicate evaluateWithObject:self];
}
@end
