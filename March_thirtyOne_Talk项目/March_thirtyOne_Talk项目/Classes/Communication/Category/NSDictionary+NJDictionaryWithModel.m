//
//  NSDictionary+NJDictionaryWithModel.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/9.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NSDictionary+NJDictionaryWithModel.h"
#import "NJMessageFrame.h"
#import "NJMessage.h"
@implementation NSDictionary (NJDictionaryWithModel)
//模型转字典
+ (NSDictionary *)dictionaryWithModel:(NJMessageFrame *)messageF
{
    NJMessage * message = messageF.message;
    NSMutableDictionary * dicM = [NSMutableDictionary dictionary];
    //1.头像
    [dicM setObject:message.icon forKey:@"icon"];
    //2.senderName
    [dicM setObject:message.senderName forKey:@"senderName"];
    //3.text
    [dicM setObject:message.text forKey:@"text"];
    //4.time
    [dicM setObject:message.time forKey:@"time"];
    //5.type
    [dicM setObject:@(message.type) forKey:@"type"];
    return dicM;
}
@end
