
//
//  NJLoginViewController.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/3/31.
//  Copyright © 2017年 cxz. All rights reserved.
//
#define NJLoginPath @"data/user/login"
#import "NJLoginViewController.h"
#import "SVProgressHUD.h"
#import "NJUserInfoVC.h"
#import "NJRegisterVC.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSString+NJMD5String.h"
#import "AFNetworking.h"
#import "NJTool.h"
#import "NJIconViewController.h"
@interface NJLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userIDTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick;
- (IBAction)ResBtnClick;
/********* 会话管理者 *********/
@property(nonatomic,strong)AFHTTPSessionManager * manager;
//用户头像
@property (weak, nonatomic) IBOutlet UIButton *userIcon;
//点击用户头像
- (IBAction)clickUserIcon;

@end

@implementation NJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置用户头像为圆形
    [self setRoundImage];
    //设置登陆按钮有圆角
    [self setLoginBtnRoundCorner];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置用户头像
    [self.userIcon setImage:[UIImage imageNamed:[NJTool getIcon]] forState:UIControlStateNormal];
    [self.userIcon setImage:[UIImage imageNamed:[NJTool getIcon]] forState:UIControlStateHighlighted];
}
//懒加载
- (AFHTTPSessionManager *)manager
{
    if(_manager == nil)
    {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)setRoundImage
{
    //1.设置图片名
    UIImage * image = [UIImage imageNamed:[NJTool getIcon]];
    //2.允许裁剪
    self.userIcon.layer.masksToBounds = YES;
    //3.设置圆角半径
    self.userIcon.layer.cornerRadius = self.userIcon.frame.size.width / 2;
    [self.userIcon setImage:image forState:UIControlStateNormal];
    [self.userIcon setImage:image forState:UIControlStateHighlighted];
}
- (void)setLoginBtnRoundCorner
{
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 10;
}
#pragma mark - 点击登陆按钮
- (IBAction)loginBtnClick
{
    //出现黑色幕布
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString * userID = self.userIDTextF.text;
    NSString * userPwd = self.pwdTextF.text;
    //判断用户ID是否为空
    if(!userID.length)
    {
        //提示
        [SVProgressHUD showErrorWithStatus:@"请输入您的ID"];
        //用户未输入ID，出现键盘
        [self.userIDTextF becomeFirstResponder];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    //判断用户密码是否为空
    if(!userPwd.length)
    {
        //提示
        [SVProgressHUD showErrorWithStatus:@"请输入您的密码"];
        //用户未输入密码，出现键盘
        [self.pwdTextF becomeFirstResponder];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    //关闭键盘
    [self.userIDTextF resignFirstResponder];
    [self.pwdTextF resignFirstResponder];
    //提示
    [SVProgressHUD showWithStatus:@"正在登陆中...."];
    //发送请求
    [self sendRequestWithID:self.userIDTextF.text pwd:self.pwdTextF.text];

}
//发送登陆请求
- (void)sendRequestWithID:(NSString *)userAccount pwd:(NSString *)userPwd
{
    //1.请求体
    //参数字典
    NSMutableDictionary * parameterDicM = [NSMutableDictionary dictionary];
    //账号
    [parameterDicM setObject:userAccount forKey:@"account"];
    //1密码加盐
    NSString * pwdAfterAddSalt = [userPwd stringByAppendingString:NJSalt];
    //2密码MD5加密
    NSString * securePwd = [NSString md5String:pwdAfterAddSalt];
    //3将加密后的密码加入字典
    [parameterDicM setObject:securePwd forKey:@"password"];
    //2.拼接URL地址
    NSString * urlStr = [NJServiceHttp stringByAppendingPathComponent:NJLoginPath];
    NSLog(@"%@",urlStr);
    //3.发送请求
    [self.manager POST:urlStr parameters:parameterDicM progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"status"] intValue] < 0)
        {
            NSLog(@"%@",responseObject[@"inf"]);
            NSString * info = responseObject[@"inf"];
            //提示
            [SVProgressHUD showErrorWithStatus:info];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
        NSLog(@"token:%@",responseObject[@"token"]);
        [NJTool setToken:responseObject[@"token"]];
        [SVProgressHUD dismissWithDelay:0.2 completion:^{
            //跳到用户信息界面
            NJUserInfoVC * userInfoVC = [[NJUserInfoVC alloc]init];
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }];
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}
//点击注册按钮
- (IBAction)ResBtnClick
{
    NJRegisterVC * registerVC = [[NJRegisterVC alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//点击用户头像
- (IBAction)clickUserIcon
{
    //跳转到头像选择控制器
    NJIconViewController * iconVC = [[NJIconViewController alloc]init];
    [self.navigationController pushViewController:iconVC animated:YES];
}
@end
