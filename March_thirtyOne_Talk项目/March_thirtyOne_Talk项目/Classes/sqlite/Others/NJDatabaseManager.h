//
//  NJDatabaseManager.h
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/5/22.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase,NJMessage;
@interface NJDatabaseManager : NSObject
//单例方法
+ (instancetype)defaultDatabaseManager;
//获取数据库路径
- (NSString *)getDatabasePath;
//添加消息
- (BOOL)insertMessageWithMessageID:(NJMessage *)message;
//删除全部数据
- (BOOL)removeAllMessages;
//获取全部信息
- (NSArray *)getAllmessages;
@end
