//
//  NSArray+NJDictionaryArrWithModelArr.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/9.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NSArray+NJDictionaryArrWithModelArr.h"
#import "NJMessageFrame.h"
#import "NSDictionary+NJDictionaryWithModel.h"
#import "NJMessage.h"
@implementation NSArray (NJDictionaryArrWithModelArr)
//模型数组转字典数组
+ (NSArray *)dictionaryArrWithModelArr:(NSArray *)modeleArr
{
    NSMutableArray * dictionaryArr = [NSMutableArray array];
    for (NJMessageFrame * messageF in modeleArr) {
        //模型转字典
        NSDictionary * dic = [NSDictionary dictionaryWithModel:messageF];
        //将字典添加到数组中
        [dictionaryArr addObject:dic];
    }
    return dictionaryArr;
}

@end
