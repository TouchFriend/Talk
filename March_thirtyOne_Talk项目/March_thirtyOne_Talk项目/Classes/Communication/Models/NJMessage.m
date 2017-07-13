//
//  NJMessage.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/8.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJMessage.h"

@implementation NJMessage
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)messageWithDic:(NSDictionary *)dic
{
    return [[self alloc]initWithDic:dic];
}
@end
