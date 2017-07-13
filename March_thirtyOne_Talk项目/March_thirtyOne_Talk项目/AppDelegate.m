//
//  AppDelegate.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/3/31.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "AppDelegate.h"
#import "NJLoginViewController.h"
@interface AppDelegate ()

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
    self.window.rootViewController = navigation;
    //3.显示窗口
    [self.window makeKeyAndVisible];
    return YES;
}
@end
