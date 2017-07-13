//
//  NJRegisterVC.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/5.
//  Copyright © 2017年 cxz. All rights reserved.
//
#define NJRegisterPath @"data/user/register"
#import "NJRegisterVC.h"
#import "NJBirthdayVC.h"
#import "NJBirthdayVCDelegate.h"
#import "NJSexTextF.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "NSString+NJMD5String.h"
@interface NJRegisterVC () <NJBirthdayVCDelegate,UIGestureRecognizerDelegate>
/********* 性别数组 *********/
@property(nonatomic,strong)NSArray * sexArr;
/********* 邮箱 *********/
@property (weak, nonatomic) IBOutlet UITextField *emailTextF;
/********* 昵称 *********/
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
/********* 密码 *********/
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
/********* 性别 *********/
@property (weak, nonatomic) IBOutlet NJSexTextF *sexTextF;
/********* 年龄 *********/
@property (weak, nonatomic) IBOutlet UIButton *ageBtn;
/********* 出生年月 *********/
@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;
/********* 所在地 *********/
@property (weak, nonatomic) IBOutlet UITextField *addressTextF;

/********* 点击性别文本框 *********/
- (IBAction)SexTextFEdit;
/********* 阴影 *********/
@property(nonatomic,strong)UIButton * shadowView;
/********* 点击年龄或者出生年月按钮 *********/
- (IBAction)ageBtnClick:(UIButton *)sender;
/********* 点击注册按钮 *********/
- (IBAction)registerBtnClick;
/********* 会话管理者 *********/
@property(nonatomic,strong)AFHTTPSessionManager * manager;

@end

@implementation NJRegisterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启导航栏
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
//懒加载
- (NSArray *)sexArr
{
    if(_sexArr == nil)
    {
        _sexArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sex.plist" ofType:nil]];
    }
    return _sexArr;
}
- (UIButton *)shadowView
{
    if(_shadowView == nil)
    {
        UIButton * shadowView = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
        shadowView.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:241/255.0 alpha:0.91];
        _shadowView = shadowView;
    }
    return _shadowView;
}
- (AFHTTPSessionManager *)manager
{
    if(_manager == nil)
    {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.emailTextF resignFirstResponder];
    [self.nameTextF resignFirstResponder];
    [self.addressTextF resignFirstResponder];
}
#pragma mark - NJBirthdayVCDelegate方法
- (void)birthdayVC:(NJBirthdayVC *)birthdayVC dateStr:(NSString *)dateStr age:(NSString *)age
{
    [self.ageBtn setTitle:age forState:UIControlStateNormal];
    [self.birthdayBtn setTitle:dateStr forState:UIControlStateNormal];
}
#pragma mark -
//编辑性别文本框
- (IBAction)SexTextFEdit
{
    //添加阴影
    [self.view addSubview:self.shadowView];
    //绑定点击事件
    [self.shadowView addTarget:self action:@selector(shadowViewClick:) forControlEvents:UIControlEventTouchUpInside];
    //初始化
    NSString * sex = self.sexTextF.text;
    if(!sex.length)
    {
        [self.sexTextF initWithBeginEdit];
    }

}
- (void)shadowViewClick:(UIButton *)shadowView
{
    [UIView animateWithDuration:0.2 animations:^{
        //移除阴影
        [self.shadowView removeFromSuperview];
        //解除第一响应者
        [self.sexTextF resignFirstResponder];
    }];
   
    
}
//点击注册按钮
- (IBAction)registerBtnClick
{
    //1.判断邮箱是否为空
    if(!self.emailTextF.text.length)
    {
        //提示
        [SVProgressHUD showErrorWithStatus:@"请输入您的邮箱"];
        //用户未输入ID，出现键盘
        [self.emailTextF becomeFirstResponder];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    //2.判断昵称是否为空
    if(!self.nameTextF.text.length)
    {
        //提示
        [SVProgressHUD showErrorWithStatus:@"请输入您的昵称"];
        //用户未输入ID，出现键盘
        [self.nameTextF becomeFirstResponder];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    //3.判断密码是否为空
    if(!self.pwdTextF.text.length)
    {
        //提示
        [SVProgressHUD showErrorWithStatus:@"请输入您的密码"];
        //用户未输入ID，出现键盘
        [self.pwdTextF becomeFirstResponder];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    //4.判断性别是否为空
    if(!self.sexTextF.text.length)
    {
        //提示
        [SVProgressHUD showErrorWithStatus:@"请输入您的性别"];
        //用户未输入ID，出现键盘
        [self.sexTextF becomeFirstResponder];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    //5.判断出生年月是否为空
    if(![self.birthdayBtn titleForState:UIControlStateNormal].length)
    {
        //提示
        [SVProgressHUD showErrorWithStatus:@"请输入您的出生年月"];
        //用户未输入ID，出现键盘
        [self.birthdayBtn becomeFirstResponder];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    //6.判断所在地是否为空
    if(!self.addressTextF.text.length)
    {
        //提示
        [SVProgressHUD showErrorWithStatus:@"请输入您的所在地"];
        //用户未输入ID，出现键盘
        [self.addressTextF becomeFirstResponder];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    //参数字典
    NSMutableDictionary * loginParamM = [NSMutableDictionary dictionary];
    //1.邮箱
    [loginParamM setObject:self.emailTextF.text forKey:@"mail"];
    //2.昵称
    [loginParamM setObject:self.nameTextF.text forKey:@"nick"];
    //3.密码
    //3.1密码加盐
    NSString * pwdAfterAddSalt = [self.pwdTextF.text stringByAppendingString:NJSalt];
    //3.2密码MD5加密
    NSString * securePwd = [NSString md5String:pwdAfterAddSalt];
    //3.3将加密后的密码加入字典
    [loginParamM setObject:securePwd forKey:@"password"];
    //4.性别
    [loginParamM setObject:self.sexTextF.text forKey:@"sex"];
    //5.出生年月
    [loginParamM setObject:[self.birthdayBtn titleForState:UIControlStateNormal] forKey:@"birthday"];
    //6.所在地
    [loginParamM setObject:self.addressTextF.text forKey:@"address"];
    //发送请求
    //出现黑色幕布
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在注册中...."];
    NSString * urlStr = [NJServiceHttp stringByAppendingPathComponent:NJRegisterPath];
    NSLog(@"%@",urlStr);
    [self.manager POST:urlStr parameters:loginParamM progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if([responseObject[@"status"] intValue] < 0)
        {
            NSLog(@"%@",responseObject[@"inf"]);
            NSString * info = responseObject[@"inf"];
            //提示
            [SVProgressHUD showErrorWithStatus:info];
            //用户未输入ID，出现键盘
            [self.emailTextF becomeFirstResponder];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
        NSLog(@"%@----%@",responseObject[@"status"], responseObject[@"inf"]);
        [SVProgressHUD showErrorWithStatus:@"注册成功"];
        [SVProgressHUD dismissWithDelay:1.5 completion:^{
                        //返回登陆界面
            [self.navigationController popViewControllerAnimated:YES];
        }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        [SVProgressHUD dismissWithDelay:1.5];
        if(error)
        {
            NSLog(@"%@",error);
        }
    }];
}

- (IBAction)ageBtnClick:(UIButton *)sender
{
    //跳转到出生年月选中界面
    NJBirthdayVC * birthdayVC = [[NJBirthdayVC alloc]init];
    //设置代理
    birthdayVC.delegate = self;
    //传递数据
    birthdayVC.birthdayDate = [self.birthdayBtn titleForState:UIControlStateNormal];
    [self.navigationController pushViewController:birthdayVC animated:YES];
}
#pragma mark - UIGestureRecognizerDelegate方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
@end
