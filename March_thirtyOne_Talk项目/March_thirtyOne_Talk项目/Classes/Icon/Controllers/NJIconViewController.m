//
//  NJIconViewController.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/20.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJIconViewController.h"
#import "NJShowIconViewController.h"
//有几列
#define NJImageNumberHorizontal 3
//高比宽多多少
#define NJHeightThanWidth 50
//第一行举例顶端多长
#define NJDistanceToTop 70
@interface NJIconViewController () <UIGestureRecognizerDelegate>
- (IBAction)clickIconBtn:(UIButton *)sender;
/********* 头像 *********/
@property(nonatomic,strong)NSArray * iconNameArr;

@end

@implementation NJIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加图片控件
    [self addImages];
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
#pragma mark - 添加图片
- (void)addImages
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin = 10;
    CGFloat imageW = (screenW - (NJImageNumberHorizontal + 1) * 10 ) / NJImageNumberHorizontal;
    CGFloat imageH = imageW + NJHeightThanWidth;
    //添加控件
    for (NSInteger index = 0; index < self.iconNameArr.count; index++) {
        //1.第几行
        NSInteger row = index / NJImageNumberHorizontal;
        //2.第几列
        NSInteger column = index % NJImageNumberHorizontal;
        //3.x坐标
        CGFloat btnX = margin + (imageW + margin) * column;
        //4.y坐标
        CGFloat btnY = NJDistanceToTop + (imageH + margin) * row;
        //5.创建控件
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        //5.1 设置frame
        btn.frame = CGRectMake(btnX, btnY, imageW, imageH);
        //5.2 设置图片
        [btn setBackgroundImage:[UIImage imageNamed:self.iconNameArr[index]] forState:UIControlStateNormal];
        //5.3 添加事件
        [btn addTarget:self action:@selector(clickIconBtn:) forControlEvents:UIControlEventTouchUpInside];
        //5.4 设置序号
        btn.tag = index;
        //6.添加到视图中
        [self.view addSubview:btn];
        
    }
}
@end
