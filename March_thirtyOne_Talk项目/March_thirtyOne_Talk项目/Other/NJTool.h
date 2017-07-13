//
//  NJTool.h
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/16.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NJTool : NSObject
+ (void)setToken:(NSString *)Token;
+ (NSString *)getToken;
+ (void)setLastReceiveMessageTime:(NSString *)dateStr;
+ (NSString *)getLastReceiveMessageTime;
//心跳
+ (void)sendBeats;
//清除心跳Task
+ (void)clearBeatTask;
+ (void)setFlag:(BOOL)newFlag;
//获得格式化日期
+ (NSDateFormatter *)getFormatter;
+ (void)setIcon:(NSString *)newIcon;
+ (NSString *)getIcon;
//设置导航控制器
+ (void)setNavigationController:(UINavigationController *)newNavigation;
@end
