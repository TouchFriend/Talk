//
//  NJMessage.h
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/8.
//  Copyright © 2017年 cxz. All rights reserved.
//
typedef enum {
    NJSendMessMe,
    NJSendMessOther,
} NJMessageSender;
#import <Foundation/Foundation.h>

@interface NJMessage : NSObject
/********* 用户头像 *********/
@property(nonatomic,strong)NSString * icon;
/********* 发送的用户名 *********/
@property(nonatomic,strong)NSString * senderName;
/********* 聊天时间 *********/
@property(nonatomic,strong)NSString * time;
/********* 聊天内容 *********/
@property(nonatomic,strong)NSString * text;
/********* 发送者 *********/
@property(nonatomic,assign)NJMessageSender type;
/********* 是否显示时间 *********/
@property(nonatomic,assign)BOOL hideTime;
/********* 消息ID *********/
@property(nonatomic,assign)NSInteger MessageID;
/********* 是否是阅后即焚消息 *********/
@property(nonatomic,assign)BOOL secretMessageFlag;
/********* 阅后即焚消息是否已经度过 *********/
@property(nonatomic,assign)BOOL hasReaded;


@end
