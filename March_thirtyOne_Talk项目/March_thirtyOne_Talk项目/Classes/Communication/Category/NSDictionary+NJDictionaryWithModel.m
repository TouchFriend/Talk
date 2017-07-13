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
    if(message.text == NULL)
    {
        message.text = @"        ";
    }
    [dicM setObject:message.text forKey:@"text"];
    //4.time
    [dicM setObject:message.time forKey:@"time"];
    //5.type
    [dicM setObject:@(message.type) forKey:@"type"];
    //6.消息ID
    [dicM setObject:@(message.MessageID) forKey:@"MessageID"];
    return dicM;
}
//模型转对象
+ (NSDictionary *)dictionaryWithMessageModel:(NJMessage *)message
{
    NSMutableDictionary * dicM = [NSMutableDictionary dictionary];
    /********* 用户头像 *********/
    [dicM setObject:message.icon forKey:@"icon"];
    /********* 发送的用户名 *********/
    [dicM setObject:message.senderName forKey:@"senderName"];
    /********* 聊天时间 *********/
    [dicM setObject:message.time forKey:@"time"];
    /********* 聊天内容 *********/
    [dicM setObject:message.text forKey:@"text"];
    /********* 发送者 *********/
    [dicM setObject:@(message.type) forKey:@"type"];
    /********* 是否显示时间 *********/
    [dicM setObject:@(message.hideTime) forKey:@"hideTime"];
    /********* 消息ID *********/
    [dicM setObject:@(message.MessageID) forKey:@"MessageID"];
    /********* 是否是阅后即焚消息 *********/
    [dicM setObject:@(message.secretMessageFlag) forKey:@"secretMessageFlag"];
    /********* 阅后即焚消息是否已经度过 *********/
    [dicM setObject:@(message.hasReaded) forKey:@"hasReaded"];
    return dicM;
}
@end
