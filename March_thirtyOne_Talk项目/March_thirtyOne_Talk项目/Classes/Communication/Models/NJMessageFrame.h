//
//  NJMessageFrame.h
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/8.
//  Copyright © 2017年 cxz. All rights reserved.
//
#define NJTextPadding 20
#define NJContentFont [UIFont systemFontOfSize:16]
#define NJUserNameFont [UIFont systemFontOfSize:14]
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class NJMessage;
@interface NJMessageFrame : NSObject
/********* 聊天时间Frame *********/
@property(nonatomic,assign,readonly)CGRect timeFram;
/********* 头像Frame *********/
@property(nonatomic,assign,readonly)CGRect iconFram;
/********* 用户名Fame *********/
@property(nonatomic,assign,readonly)CGRect userNameFram;
/********* 聊天内容Fame *********/
@property(nonatomic,assign,readonly)CGRect textFram;
/********* cellHeight *********/
@property(nonatomic,assign,readonly)CGFloat cellHeight;
/********* 数据模型 *********/
@property(nonatomic,strong)NJMessage * message;
@end
