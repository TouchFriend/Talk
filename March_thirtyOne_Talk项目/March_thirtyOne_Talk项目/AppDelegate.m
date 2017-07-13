//
//  AppDelegate.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/3/31.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "AppDelegate.h"
#import "NJLoginViewController.h"
#import "NJTool.h"
@interface AppDelegate () <UIGestureRecognizerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //1.创建窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //2.创建根控制器
    UINavigationController * navigation = [[UINavigationController alloc]init];
    NJLoginViewController * loginVC = [[NJLoginViewController alloc]init];
    navigation.navigationBar.hidden = YES;
    [navigation pushViewController:loginVC animated:YES];
//    [navigation setEdgesForExtendedLayout:UIRectEdgeRight];
    self.window.rootViewController = navigation;
    //关闭右划返回
    navigation.interactivePopGestureRecognizer.delegate = self;
    //设置NJTool的导航控制器
    [NJTool setNavigationController:navigation];
    //3.显示窗口
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark - UIGestureRecognizerDelegate方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}
@end
