
//
//  NJLoginViewController.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/3/31.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJLoginViewController.h"
#import "SVProgressHUD.h"
#import "NJUserInfoVC.h"
#import "NJRegisterVC.h"
#import "GCDAsyncUdpSocket.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSString+NJMD5String.h"
@interface NJLoginViewController () <GCDAsyncUdpSocketDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick;
- (IBAction)ResBtnClick;
/********* sendSocket *********/
@property(nonatomic,strong)GCDAsyncUdpSocket * sendSocket;

@end

@implementation NJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置用户头像为圆形
    [self setRoundImage];
    //设置登陆按钮有圆角
    [self setLoginBtnRoundCorner];
    dispatch_queue_t queue = dispatch_queue_create("Login", 0);
    self.sendSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:queue];
    NSError * error;
    //绑定端口
    [self.sendSocket bindToPort:NJClientLoginPort error:&error];
    if(error)
    {
        NSLog(@"绑定端口失败");
    }
    //开始接受数据
    [self.sendSocket beginReceiving:nil];
    
}

- (void)setRoundImage
{
    //1.设置图片名
    UIImage * image = [UIImage imageNamed:@"xcode"];
    //2.允许裁剪
    self.userIcon.layer.masksToBounds = YES;
    //3.设置圆角半径
    self.userIcon.layer.cornerRadius = self.userIcon.frame.size.width / 2;
    self.userIcon.image = image;
}
- (void)setLoginBtnRoundCorner
{
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 10;
}

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
    //判断用户ID和密码是否正确
    if([self isLoginWithID:userID pwd:userPwd])
    {
        [SVProgressHUD dismissWithCompletion:^{
            //1.创建用户信息控制器
            NJUserInfoVC * userInfoVC = [[NJUserInfoVC alloc]init];
            //2.添加到navigation控制器中
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"用户名或密码不正确！"];
        [SVProgressHUD dismissWithDelay:1.5];
      
    }
}
//判断用户ID和密码是否正确
- (BOOL)isLoginWithID:(NSString *)userAccount pwd:(NSString *)userPwd
{
    //1.包头
    Byte head2[] = {7,1};
    NSInteger accountLength = strlen(userAccount.UTF8String);
    NSData * accountData = [userAccount dataUsingEncoding:NSASCIIStringEncoding];
//    NSLog(@"account%@",[[NSString alloc]initWithData:accountData encoding:NSASCIIStringEncoding]);
    //2.包内容
    //2.1将密码加盐
    NSString * packetContent = [userPwd stringByAppendingString:NJSalt];
    //2.2将密码MD5加密
    NSString * secureString = [NSString md5String:packetContent];
    NSInteger userPwdLength = strlen(secureString.UTF8String);
    //3.包尾
    //4.计算包长 = 8 + 账号长度 + 加密后的密码长度
    int packetLength = (int)( 8 + accountLength + userPwdLength);
    //5.拼接成包
    //5.1头两个字节
    NSMutableData * packetDataM = [NSMutableData dataWithBytes:head2 length:2];
    //5.2账号长度
    Byte accountLenB[] = {accountLength};
    [packetDataM appendBytes:accountLenB length:1];
    //5.3账号
    [packetDataM appendData:accountData];
    //5.4包长度
    Byte packetLenB[] = {0,0,0,0};
    NSLog(@"%i",(Byte)(packetLength & 0xff));
    packetLenB[0] = (Byte)((packetLength >> 24) & 0xff);
    packetLenB[1] = (Byte)((packetLength >> 16) & 0xff);
    packetLenB[2] = (Byte)((packetLength >> 8) & 0xff);
    packetLenB[3] = (Byte)(packetLength & 0xff);
    [packetDataM appendBytes:packetLenB length:4];
    //5.5加密后的密码
    [packetDataM appendData:[secureString dataUsingEncoding:NSUTF8StringEncoding]];
    //5.6添加包尾
    NSString * packetTailStr = [NSString stringWithFormat:@"%d",NJPacketTail];
    [packetDataM appendBytes:[[packetTailStr dataUsingEncoding:kCFStringEncodingUTF8] bytes] length:1];
    //6.发送数据
    NSLog(@"要发送的数据:%@",packetDataM);
    [self.sendSocket sendData:packetDataM toHost:NJServerIP port:NJServerPort withTimeout:50 tag:200];
    return YES;
}
//点击注册按钮
- (IBAction)ResBtnClick
{
    NJRegisterVC * registerVC = [[NJRegisterVC alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
#pragma mark - GCDAsyncUdpSocketDelegate方法
//接收服务器返回的数据
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    if(tag == 200)
    {
        NSLog(@"发送失败");
    }
}
@end
