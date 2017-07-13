//
//  NJUDPSendSocket.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/9.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJUDPSendSocket.h"
@interface NJUDPSendSocket ()

@end
@implementation NJUDPSendSocket
//单粒对象
static NJUDPSendSocket * _instance;
//1.重写方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil)
        {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
- (id)copy
{
    return _instance;
}
- (id)mutableCopy
{
    return _instance;
}
//2.提供获取单粒对象方法
+ (instancetype)defaultUDPSendSocket
{
    return [[self alloc]init];
}

@end
