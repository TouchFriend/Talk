//
//  NJTool.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/16.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJTool.h"
#import <AFNetworking.h>
#define NJMessages @"messages"
#define NJSecret_notice @"secret_notice"
@implementation NJTool
static NSString * lastReceiveMessageTime;
static NSOperationQueue * beatQueue;
static AFHTTPSessionManager * manager;
static NSString * fullPath;
static BOOL flag;
static NSDateFormatter * formatter;
static NSString * icon;
//导航控制器
static UINavigationController * navigationConroller;
+ (void)setToken:(NSString *)newToken
{
    fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"token.plist"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:fullPath])
    {
        [fileManager createFileAtPath: fullPath contents:nil attributes:nil];
    }
    NSDictionary * dic = @{
                           @"token" : newToken,
                           };
    [dic writeToFile:fullPath atomically:YES];
}
+ (NSString *)getToken
{
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:fullPath];
    NSLog(@"%@",dic);
    return dic[@"token"];
}
+ (void)setLastReceiveMessageTime:(NSString *)dateStr
{
    lastReceiveMessageTime = dateStr;
}
+ (NSString *)getLastReceiveMessageTime
{
    if(lastReceiveMessageTime == nil)
    {
        NSDateFormatter * formatter = [self getFormatter];
        //初始化为登陆时间
        return [formatter stringFromDate:[NSDate date]];
    }
    return lastReceiveMessageTime;
}
+ (void)sendBeats
{
    //初始化
    manager = [AFHTTPSessionManager manager];
    flag = YES;
    beatQueue = [[NSOperationQueue alloc]init];
    //1.拼接URL
    NSString * urlStr = [NJServiceHttp stringByAppendingPathComponent:NJBeats];
    //拼接Token
    NSString * urlToken = [urlStr stringByAppendingPathComponent:[NJTool getToken]];
    NSLog(@"%@",urlToken);
    NSMutableDictionary * parametersDic = [NSMutableDictionary dictionary];
    [beatQueue addOperationWithBlock:^{
        while (flag)
        {
            @synchronized (self) {
                [NSThread sleepForTimeInterval:10.0];
                [parametersDic setObject:[NJTool getLastReceiveMessageTime] forKey:@"last_time"];
                [manager POST:urlToken parameters:parametersDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    //判断是否异常
                    if([responseObject[@"status"] intValue] < 0)
                    {
                        NSLog(@"%@",responseObject[@"inf"]);
                        //调到登陆界面
//                        if([responseObject[@"inf"] isEqualToString:@"不存在用户"])
//                        {
//                           [navigationConroller popToRootViewControllerAnimated:YES];
//                        }
                        return;
                    }
//                    NSLog(@"responseObject%@",responseObject);
                    NSArray * messageArr = responseObject[NJMessages];
                    NSArray * secret_notice = responseObject[NJSecret_notice];
                    //有收到消息
                    if(messageArr.count > 0  || secret_notice.count > 0)
                    {
                        NSMutableDictionary * messageDicM = [NSMutableDictionary dictionary];
                        [messageDicM setValue:messageArr forKey:NJMessages];
                        [messageDicM setValue:secret_notice forKey:NJSecret_notice];
                        //发送通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageCome" object:self userInfo:messageDicM];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];

            }
        }
    }];
}
+ (void)clearBeatTask
{
    [beatQueue cancelAllOperations];
    beatQueue = nil;
    manager = nil;
    [self setFlag:NO];
}
+ (void)setFlag:(BOOL)newFlag
{
    flag = newFlag;
}
+ (NSDateFormatter *)getFormatter
{
    if(formatter == nil)
    {
        formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return formatter;
}
+ (NSString *)getIcon
{
    if(icon == nil)
    {
        icon = @"smallYellowBoy";
    }
    return icon;
}
+ (void)setIcon:(NSString *)newIcon
{
    icon = newIcon;
}
//设置导航控制器
+ (void)setNavigationController:(UINavigationController *)newNavigation
{
    navigationConroller = newNavigation;
}
@end
