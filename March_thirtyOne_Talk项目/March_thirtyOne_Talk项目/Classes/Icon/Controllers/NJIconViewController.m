//
//  NJIconViewController.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/20.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJIconViewController.h"
#import "NJShowIconViewController.h"
@interface NJIconViewController () <UIGestureRecognizerDelegate>
- (IBAction)clickIconBtn:(UIButton *)sender;

/********* iconName *********/
@property(nonatomic,strong)NSArray * iconNameArr;

@end

@implementation NJIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开启导航栏
    self.navigationController.navigationBar.hidden = NO;
    //开启识别手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
//懒加载
- (NSArray *)iconNameArr
{
    if(_iconNameArr == nil)
    {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"iconName.plist" ofType:nil];
        _iconNameArr = [NSArray arrayWithContentsOfFile:path];
    }
    return _iconNameArr;
}


- (IBAction)clickIconBtn:(UIButton *)userIcon
{
    //创建控制器
    NJShowIconViewController * showIconVC = [[NJShowIconViewController alloc]init];
    //赋值
    showIconVC.iconName = self.iconNameArr[userIcon.tag];
    //跳转到图片放大界面
    [self.navigationController pushViewController:showIconVC animated:YES];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
@end
