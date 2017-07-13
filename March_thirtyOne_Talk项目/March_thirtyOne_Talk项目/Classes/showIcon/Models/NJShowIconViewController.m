//
//  NJShowIconViewController.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/20.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJShowIconViewController.h"
#import "NJTool.h"
@interface NJShowIconViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
- (IBAction)clickOkbtn:(id)sender;

@end

@implementation NJShowIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化图片
    self.userIconImageView.image = [UIImage imageNamed:self.iconName];
}



- (IBAction)clickOkbtn:(id)sender
{
    //设置头像为选定的图片
    [NJTool setIcon:self.iconName];
    //跳转到登陆界面
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
