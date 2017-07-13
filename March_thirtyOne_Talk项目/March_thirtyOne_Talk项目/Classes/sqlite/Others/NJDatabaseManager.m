//
//  NJDatabaseManager.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/5/22.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJDatabaseManager.h"
#import <FMDB.h>
#import "NJMessage.h"
@interface NJDatabaseManager ()
/********* 数据库 *********/
@property(nonatomic,strong)FMDatabase * database;

@end
@implementation NJDatabaseManager
static NJDatabaseManager * databaseManager;
//单例方法
+ (instancetype)defaultDatabaseManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(databaseManager == nil)
        {
            databaseManager = [[NJDatabaseManager alloc]init];
        }
    });
    return databaseManager;
}
//- (instancetype)init
//{
//    @throw [NSException exceptionWithName:@"NJDatabaseManager" reason:@"不能用此方法创建对象" userInfo:nil];
//    return self;
//}
- (id)copy
{
    @throw [NSException exceptionWithName:@"NJDatabaseManager" reason:@"不能用此方法创建对象" userInfo:nil];
    return self;
}
- (id)mutableCopy
{
    @throw [NSException exceptionWithName:@"NJDatabaseManager" reason:@"不能用此方法创建对象" userInfo:nil];
    return self;
}
//获取数据库路径
- (NSString *)getDatabasePath
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [docPath stringByAppendingPathComponent:@"communicationDB.sqlite"];
}
//创建数据库
- (FMDatabase *)database
{
    if(_database == nil)
    {
        _database = [FMDatabase databaseWithPath:[self getDatabasePath]];
        //打开数据库
        if([_database open])
        {
            //创建表
            BOOL flag =[_database executeUpdate:@"create table if not exists message(messageID integer primary key,icon text,senderName text,text text,time text,type integer)"];
            if(flag)
            {
                NSLog(@"创建表成功");
            }
            else
            {
                NSLog(@"创建表失败");
            }
        }
    }
    return _database;
}
//添加数据
- (BOOL)insertMessageWithMessageID:(NJMessage *)message
{
    return [self.database executeUpdate:@"insert into message values(?,?,?,?,?,?)",@(message.MessageID),message.icon,message.senderName,message.text,message.time,@(message.type)];
}
//删除全部数据
- (BOOL)removeAllMessages
{
    return [self.database executeUpdate:@"remove from message"];
}
//获取全部信息
- (NSArray *)getAllmessages
{
    return [self getMessagesWithFriendName:nil];
}
//获取指定用户的聊天信息
- (NSArray *)getMessagesWithFriendName:(NSString *)friendName
{
    FMResultSet * resultSet = nil;
    //1.不为空，返回跟这个好友的聊天记录
    if(friendName != nil)
    {
        resultSet = [self.database executeQuery:@"select * from message where senderName = ?",friendName];
    }
    //2.为空，返回所有的聊天数据
    else
    {
        //select * from message limit 4 OFFSET 1分页查询
        resultSet = [self.database executeQuery:@"select * from message"];
    }
    NSMutableArray * messages = [NSMutableArray array];
    while (resultSet.next) {
        NSMutableDictionary * messageDicM = [NSMutableDictionary dictionary];
        //1.添加消息编号
        [messageDicM setObject:@([resultSet intForColumn:@"messageID"]) forKey:@"messageID"];
        //2.添加发送人图像
        [messageDicM setObject:[resultSet stringForColumn:@"icon"] forKey:@"icon"];
        //3.添加发送人昵称
        [messageDicM setObject:[resultSet stringForColumn:@"senderName"] forKey:@"senderName"];
        //4.添加消息内容
        [messageDicM setObject:[resultSet stringForColumn:@"text"] forKey:@"text"];
        //5.添加发送时间
        [messageDicM setObject:[resultSet stringForColumn:@"time"] forKey:@"time"];
        //6.添加消息发送人标志
        [messageDicM setObject:@([resultSet intForColumn:@"type"]) forKey:@"type"];
        //7.添加到数组
        [messages addObject:messageDicM];
    }
    return messages;
}
- (void)dealloc
{
    //关闭数据库
    [self.database close];
}
@end
