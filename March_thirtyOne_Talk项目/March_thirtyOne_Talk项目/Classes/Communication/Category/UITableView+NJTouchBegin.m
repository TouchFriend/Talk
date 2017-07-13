//
//  UITableView+NJTouchBegin.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/8.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "UITableView+NJTouchBegin.h"

@implementation UITableView (NJTouchBegin)
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //发布通知
    NSNotification * notification = [NSNotification notificationWithName:@"tableViewTouch" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
