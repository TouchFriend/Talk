//
//  NJRegisterVC.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/5.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJRegisterVC.h"
#import "NJBirthdayVC.h"
#import "NJBirthdayVCDelegate.h"
#import "NJSexTextF.h"
#import "NJUDPSendSocket.h"
@interface NJRegisterVC () <NJBirthdayVCDelegate,GCDAsyncUdpSocketDelegate>
/********* 性别数组 *********/
@property(nonatomic,strong)NSArray * sexArr;
/********* 邮箱 *********/
@property (weak, nonatomic) IBOutlet UITextField *emailTextF;
/********* 昵称 *********/
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
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
/********* senderSocket *********/
@property(nonatomic,strong)GCDAsyncUdpSocket * sendSocket;

@end

@implementation NJRegisterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_queue_t queue = dispatch_queue_create("Client", 0);
    self.sendSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:queue];
    NSError * error;
    //绑定端口
    [self.sendSocket bindToPort:NJClientLoginPort error:&error];
    if(error)
    {
        NSLog(@"绑定端口失败");
        NSLog(@"%@",error);
    }
    //开始接受数据
    [self.sendSocket beginReceiving:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
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
    //将数据封装成包
    //1.包头
    Byte head2[] = {7,3};
    //2.包内容
    NSMutableDictionary * contentDicM = [NSMutableDictionary dictionary];
    //2.1添加邮箱
    [contentDicM setObject:self.emailTextF.text forKey:@"email"];
    //2.2添加昵称
    [contentDicM setObject:self.nameTextF.text forKey:@"userName"];
    //2.3添加性别
    [contentDicM setObject:self.sexTextF.text forKey:@"sex"];
    //2.4添加年龄
    [contentDicM setObject:[self.ageBtn titleForState:UIControlStateNormal] forKey:@"age"];
    //2.5添加出生年月
    [contentDicM setObject:[self.birthdayBtn titleForState:UIControlStateNormal] forKey:@"birthday"];
    //2.6添加所在地
    [contentDicM setObject:self.addressTextF.text forKey:@"address"];
    //2.7判断能否转成json对象
    if(![NSJSONSerialization isValidJSONObject:contentDicM])
    {
        NSLog(@"%@不能转化成json",contentDicM);
        return;
    }
    NSData * packetContentData = [NSJSONSerialization dataWithJSONObject:contentDicM options:kNilOptions error:nil];
    //2.8注册内容长度
    NSInteger contentLength = strlen([[NSString alloc]initWithData:packetContentData encoding:NSUTF8StringEncoding].UTF8String);
    //3.包尾
    //4.计算包长 = 8 + 账号长度 + 加密后的内容长度
    int packetLength = (int)(8 + 1 + contentLength);
    //5.拼接成包
    //5.1头两个字节
    NSMutableData * packetDataM = [NSMutableData dataWithBytes:head2 length:2];
    //5.2账号长度
    Byte accountLenB[] = {0};
    [packetDataM appendBytes:accountLenB length:1];
    //5.3账号
    //5.4包长度
    Byte packetLenB[] = {0,0,0,0};
    NSLog(@"%i",(Byte)(packetLength & 0xff));
    packetLenB[0] = (Byte)((packetLength >> 24) & 0xff);
    packetLenB[1] = (Byte)((packetLength >> 16) & 0xff);
    packetLenB[2] = (Byte)((packetLength >> 8) & 0xff);
    packetLenB[3] = (Byte)(packetLength & 0xff);
    [packetDataM appendBytes:packetLenB length:4];
    //5.5注册内容
    [packetDataM appendData:packetContentData];
    //5.6添加包尾
    NSString * packetTailStr = [NSString stringWithFormat:@"%d",NJPacketTail];
    [packetDataM appendBytes:[[packetTailStr dataUsingEncoding:NSUTF8StringEncoding] bytes] length:1];
    //6.发送数据
    NSLog(@"要发送的数据:%@",packetDataM);
    [self.sendSocket sendData:packetDataM toHost:NJServerIP port:NJServerPort withTimeout:50 tag:200];
    //    [self.navigationController popViewControllerAnimated:YES];
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
