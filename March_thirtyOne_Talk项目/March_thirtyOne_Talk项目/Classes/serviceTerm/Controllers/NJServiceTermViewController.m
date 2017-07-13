//
//  NJServiceTermViewController.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/21.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJServiceTermViewController.h"

@interface NJServiceTermViewController () <UIGestureRecognizerDelegate>

@end

@implementation NJServiceTermViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //显示导航条
    self.navigationController.navigationBar.hidden = NO;
    //右划返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
#pragma mark - UIGestureRecognizerDelegate方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
@end
