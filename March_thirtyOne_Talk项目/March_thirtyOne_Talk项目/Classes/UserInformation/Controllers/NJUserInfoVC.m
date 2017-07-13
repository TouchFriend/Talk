//
//  NJUserInfoVC.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/1.
//  Copyright © 2017年 cxz. All rights reserved.
//
#define NJUserInfo @"data/user/information"
#define NJLogout @"data/user/logout"
#define NJInviteCode @"data/user/getInviteCode"
#define NJInvite_code @"invite_code"
#import "NJUserInfoVC.h"
#import "NJCommunicationVC.h"
#import "UIImage+Image.h"
#import "NJTableViewCell.h"
#import "NJInfo.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import "NJTool.h"
#import <SVProgressHUD.h>
#import "NJOption.h"
#import "NJSetterTableViewCell.h"
#define NJOriginY -320
#define NJOriginBgConstraintHeight 200
#define NJOriginUserNameConstraintheight 120
#define NJNavigationBarHeight 64
#define NJScreenSize [UIScreen mainScreen].bounds.size
#define NJRightTarget [UIScreen mainScreen].bounds.size.width * 0.8
#define NJSideX [UIScreen mainScreen].bounds.size.width * 0.8 * 0.3
#define NJOptionTableViewInsetTop 30
//NJOriginUserNameConstraintheight + 20(statusBar)
#define NJStopY 140
@interface NJUserInfoVC () <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
/********* 用户头像 *********/
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
//主视图的tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgConstraintHeight;
/********* 用户信息 *********/
@property(nonatomic,strong)NSArray * userInfoArr;
/********* 昵称 *********/
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *communicationBtn;
/********* 会话管理者 *********/
@property(nonatomic,strong)AFHTTPSessionManager * manager;
- (IBAction)CommuniBtnClick;
- (IBAction)logoutBtnClick:(UIButton *)sender;
/********* 格式化日期 *********/
@property(nonatomic,strong)NSDateFormatter * formatter;
/********* 获取用户信息文件地址 *********/
@property(nonatomic,strong)NSString * userInfoFilePath;
/********* 是否已经加入了聊天中 *********/
@property(nonatomic,assign)BOOL joinGroupFlag;
/*********** 主视图 *************/
@property (weak, nonatomic) IBOutlet UIView *mainView;
/*********** 背景视图 *************/
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
//后台视图的tableView
@property (weak, nonatomic) IBOutlet UITableView *backgroundTableView;
/********* 设置选项 *********/
@property(nonatomic,strong)NSArray * setOptionArr;
/********* 底部聊天按钮条的高度约束 *********/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToolHeightContraint;
- (IBAction)setterBtnClick:(id)sender;


@end

@implementation NJUserInfoVC
static NSString * ID = @"userInfo";
static NSString * bgOptionID = @"option";
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置数据源和代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //设置设置tableView的数据源和代理
    self.backgroundTableView.dataSource = self;
    self.backgroundTableView.delegate = self;
    //禁止自动设置偏移量
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置偏移量
    self.tableView.contentInset = UIEdgeInsetsMake(-NJOriginY, 0, self.bottomToolHeightContraint.constant,0);
    self.backgroundTableView.contentInset = UIEdgeInsetsMake(NJOptionTableViewInsetTop, 0, 0, 0);
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NJTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.backgroundTableView registerNib:[UINib nibWithNibName:@"NJSetterTableViewCell" bundle:nil] forCellReuseIdentifier:bgOptionID];
    //初始化昵称
    NJInfo * info = (NJInfo *)self.userInfoArr[1];
    self.userNameLabel.text = info.content;
    //设置聊天按钮的圆角
    [self setCommunicationBtnRound];
    //获取用户信息
    [self getUserInfo];
    //心跳
    [NJTool sendBeats];
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateComBtn) name:@"updateComBtn" object:nil];
    //添加手势
    [self addGesture];
    //设置tableview不能选中
    self.tableView.allowsSelection = NO;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏navigationBar
    self.navigationController.navigationBar.hidden = YES;
    //将头像设置成圆形
    [self setIconRound];
    //设置用户头像
    self.userIcon.image = [UIImage imageNamed:[NJTool getIcon]];
    //设置侧边栏左移大小 = 侧边栏大小 * 0.3
    self.backgroundView.frame = [self backgroundframeWithX:-NJSideX];
}
//懒加载
- (NSArray *)userInfoArr
{
    if(_userInfoArr == nil)
    {
        _userInfoArr = [NJInfo mj_objectArrayWithFile:self.userInfoFilePath];
    }
    return _userInfoArr;
}
- (NSArray *)setOptionArr
{
    if(_setOptionArr == nil)
    {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"backgroundOptions.plist" ofType:nil];
        _setOptionArr = [NJOption mj_objectArrayWithFile:path];
    }
    return _setOptionArr;
}
- (AFHTTPSessionManager *)manager
{
    if(_manager == nil)
    {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (NSDateFormatter *)formatter
{
    if(_formatter == nil)
    {
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        _formatter = formatter;
    }
    return _formatter;
    
}
- (NSString *)userInfoFilePath
{
    if(_userInfoFilePath == nil)
    {
        NSString * fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"UserInfo.plist"];
        NSLog(@"%@",fullPath);
        NSFileManager * fileManager = [NSFileManager defaultManager];
        //判断文件是否存在
        if(![fileManager fileExistsAtPath:fullPath])
        {
            //创建空文件
            [fileManager createFileAtPath:fullPath contents:nil attributes:nil];
        }
        _userInfoFilePath = fullPath;
    }
    return _userInfoFilePath;
}
- (void)setJoinGroupFlag:(BOOL)joinGroupFlag
{
    _joinGroupFlag = joinGroupFlag;
    
}
//将头像设置成圆形
- (void)setIconRound
{
    //设置图片
    self.userIcon.image = [UIImage imageNamed:@"xcode"];
    //允许编辑
    self.userIcon.layer.masksToBounds = YES;
    //设置圆角半径
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.height / 2.0;
}
//设置聊天按钮的圆角
- (void)setCommunicationBtnRound
{
    self.communicationBtn.layer.masksToBounds = YES;
    self.communicationBtn.layer.cornerRadius = 5;
}
#pragma mark - UITableViewDataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
      return self.userInfoArr.count;
    }
    else
    {
        return self.setOptionArr.count;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView)
    {
        NJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        //设置数据
        cell.info = self.userInfoArr[indexPath.row];
        return cell;
    }
    else
    {
        NJSetterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:bgOptionID];
        //设置数据
        cell.option = self.setOptionArr[indexPath.row];
        return cell;
    }
}
#pragma mark - UITableViewDelegate方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //计算滚动量
    CGFloat offset = scrollView.contentOffset.y - NJOriginY ;
//    NSLog(@"offset = %lf",offset);
    //userName的最大y
    CGFloat height = NJOriginBgConstraintHeight - offset;
    if(height < NJStopY)
    {
        height = NJStopY;
    }
    self.bgConstraintHeight.constant = height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self getInviteCode];
            break;
        case 1:
            [self showInviteCodeInput];
            break;
        case 2:
            [self sendExitGroupRequest];
            break;
        default:
            break;
    }
    //点击后解除选中
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}
#pragma mark - 点击聊天按钮
- (IBAction)CommuniBtnClick {
    if([[self.communicationBtn titleForState:UIControlStateNormal] isEqualToString:@"聊天"])
    {
        NJCommunicationVC * communiVC = [[NJCommunicationVC alloc]init];
        communiVC.userName = self.userNameLabel.text;
        [self.navigationController pushViewController:communiVC animated:YES];
    }
    else
    {
        [self showInviteCodeInput];
    }
    
}
#pragma mark -

//获取用户信息
- (void)getUserInfo
{
    //1.拼接URL
    NSString * urlStr = [NJServiceHttp stringByAppendingPathComponent:NJUserInfo];
    //拼接Token
    NSString * urlToken = [urlStr stringByAppendingPathComponent:[NJTool getToken]];
    NSLog(@"%@",urlToken);
    //2.发送请求
    [self.manager GET:urlToken parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"status"] intValue] < 0)
        {
            NSLog(@"%@",responseObject[@"inf"]);
            NSString * info = responseObject[@"inf"];
            //提示
            [SVProgressHUD showErrorWithStatus:info];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
        NSLog(@"%@",responseObject[@"inf"]);
        NSMutableArray * userInfoArrM = [NSMutableArray array];
        NSDictionary * userInfoDic = responseObject[@"inf"];
        //1.账号
        [userInfoArrM addObject:@{
                                  @"name" : @"账号",
                                  @"content" : userInfoDic[@"account"],
                                  }];
        //2.昵称
        [userInfoArrM addObject:@{
                                  @"name" : @"昵称",
                                  @"content" : userInfoDic[@"nick"],
                                  }];
        //2.1设置昵称Label
        self.userNameLabel.text = userInfoDic[@"nick"];
        //3.性别
        [userInfoArrM addObject:@{
                                  @"name" : @"性别",
                                  @"content" : userInfoDic[@"sex"],
                                  }];
        //4.年龄
        NSString * birthdayStr = userInfoDic[@"birthday"];
        NSDate * birthdayDate = [self.formatter dateFromString:birthdayStr];
        NSInteger age = [[NSDate date] timeIntervalSinceDate:birthdayDate] / (365 * 24 * 60 * 60);
        [userInfoArrM addObject:@{
                                  @"name" : @"年龄",
                                  @"content" : [NSString stringWithFormat:@"%li",age],
                                  }];
        //5.出生年月
        //格式化日期，只留下年月日
        NSDateFormatter * birthdayFormatter = [[NSDateFormatter alloc]init];
        birthdayFormatter.dateFormat = @"yyyy-MM-dd";
        NSString * birthday = [birthdayFormatter stringFromDate:[[NJTool getFormatter] dateFromString:userInfoDic[@"birthday"]]];
        [userInfoArrM addObject:@{
                                  @"name" : @"出生年月",
                                  @"content" : birthday,
                                  }];
        //6.所在地
        [userInfoArrM addObject:@{
                                  @"name" : @"所在地",
                                  @"content" : userInfoDic[@"address"],
                                  }];
//        NSLog(@"%@",userInfoArrM);
        //7.登陆时间
        [NJTool setLastReceiveMessageTime:userInfoDic[@"login_time"]];
        //8.聊天组
        self.joinGroupFlag = [userInfoDic[@"group"] integerValue];
        //发送聊天按钮更新通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateComBtn" object:nil];
        self.userInfoArr = [NJInfo mj_objectArrayWithKeyValuesArray:userInfoArrM];
        [userInfoArrM writeToFile:self.userInfoFilePath atomically:YES];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error)
        {
            NSLog(@"%@",error);
//            [self getUserInfo];
        }
    }];
}
//注销登陆
- (IBAction)logoutBtnClick:(UIButton *)sender
{
    //发送请求
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"正在注销中"];
    //1.拼接URL
    NSString * urlStr = [NJServiceHttp stringByAppendingPathComponent:NJLogout];
    //拼接Token
    NSString * urlToken = [urlStr stringByAppendingPathComponent:[NJTool getToken]];
    NSLog(@"%@",urlToken);
    [self.manager GET:urlToken parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"status"] intValue] < 0)
        {
            NSLog(@"%@",responseObject[@"inf"]);
            NSString * info = responseObject[@"inf"];
            //提示
            [SVProgressHUD showErrorWithStatus:info];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
        NSLog(@"%@",[NSThread currentThread]);
        [SVProgressHUD dismissWithCompletion:^{
            //清除心跳任务
            [NJTool clearBeatTask];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error)
        {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark - 通过警告框展示邀请码
- (void)showInviteCode:(NSString *)inviteCode
{
    UIAlertController * inviteCodeController = [UIAlertController alertControllerWithTitle:@"邀请码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [inviteCodeController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = inviteCode;
    }];
    [inviteCodeController addAction:okAction];
    [self presentViewController:inviteCodeController animated:YES completion:^{
        
    }];
}
//获取邀请码
- (void)getInviteCode
{
    //1.拼接URL
    NSString * urlStr = [NJServiceHttp stringByAppendingPathComponent:NJInvite];
    //拼接Token
    NSString * urlToken = [urlStr stringByAppendingPathComponent:[NJTool getToken]];
    NSLog(@"%@",urlToken);
    //2.发送请求
    [self.manager GET:urlToken parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"status"] intValue] < 0)
        {
            NSLog(@"%@",responseObject[@"inf"]);
            NSString * info = responseObject[@"inf"];
            //提示
            [SVProgressHUD showErrorWithStatus:info];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
        [self showInviteCode:responseObject[NJInvite_code]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error)
        {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark - 加入聊天组
- (void)showInviteCodeInput
{
    UIAlertController * inviteCodeController = [UIAlertController alertControllerWithTitle:@"邀请码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [inviteCodeController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入邀请码";
    }];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * textF = inviteCodeController.textFields[0];
        if(textF.text.length == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"邀请码不能为空"];
            [SVProgressHUD dismissWithDelay:1.5];
            return ;
        }
        [self sendJoinGroupRequest:textF.text];
    }];

    [inviteCodeController addAction:okAction];
    [self presentViewController:inviteCodeController animated:YES completion:^{
        
    }];
}
- (void)sendJoinGroupRequest:(NSString *)inviteCode
{
    //0.中文转码
//    NSData * inviteCodeData =[inviteCode dataUsingEncoding:NSUTF8StringEncoding];
    //1.拼接URL
    NSString * urlStr = [NJServiceHttp stringByAppendingPathComponent:NJJoinGroup];

    //2.拼接邀请码
    NSString * urlInvite = [urlStr stringByAppendingPathComponent:inviteCode];
    //拼接Token
    NSString * urlToken = [urlInvite stringByAppendingPathComponent:[NJTool getToken]];
    NSLog(@"%@",urlToken);
    //2.发送请求
    [self.manager GET:urlToken parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"status"] intValue] < 0)
        {
            NSLog(@"%@",responseObject[@"inf"]);
            NSString * info = responseObject[@"inf"];
            //提示
            [SVProgressHUD showErrorWithStatus:info];
            [SVProgressHUD dismissWithDelay:1.2];
            return;
        }
        [SVProgressHUD showSuccessWithStatus:@"加入聊天组成功"];
        //改变聊天按钮title成加入聊天组
        self.joinGroupFlag = true;
        [self updateComBtn];
        [SVProgressHUD dismissWithDelay:1.2];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error)
        {
            NSLog(@"%@",error);
        }
    }];

}
#pragma mark - 退出聊天组
- (void)sendExitGroupRequest
{
    //1.拼接URL
    NSString * urlStr = [NJServiceHttp stringByAppendingPathComponent:NJExitGroup];
    //拼接Token
    NSString * urlToken = [urlStr stringByAppendingPathComponent:[NJTool getToken]];
    NSLog(@"%@",urlToken);
    //2.发送请求
    [self.manager GET:urlToken parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"status"] intValue] < 0)
        {
            NSLog(@"%@",responseObject[@"inf"]);
            NSString * info = responseObject[@"inf"];
            //提示
            [SVProgressHUD showErrorWithStatus:info];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
        [SVProgressHUD showSuccessWithStatus:@"退出聊天组成功"];
        //改变聊天按钮title成加入聊天组
        self.joinGroupFlag = false;
        [self updateComBtn];
        [SVProgressHUD dismissWithDelay:1.5];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error)
        {
            NSLog(@"%@",error);
        }
    }];
}
#pragma mark -
//更新聊天按钮
- (void)updateComBtn
{
    NSLog(@"%i",self.joinGroupFlag);
    if(self.joinGroupFlag)
    {
        [self.communicationBtn setTitle:@"聊天" forState: UIControlStateNormal];
    }
    else
    {
        [self.communicationBtn setTitle:@"加入聊天组" forState: UIControlStateNormal];
    }
}
//添加手势
- (void)addGesture
{
    //1.添加平移手势
    //1.1创建手势
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    //1.2添加手势
    [self.view addGestureRecognizer:panGesture];
    //1.3设置拖拽手势的代理
    panGesture.delegate = self;
    //1.4不拦截点击事件
    panGesture.cancelsTouchesInView = NO;
    //2.添加点按手势
    //2.1创建手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    //2.1添加手势
    [self.mainView addGestureRecognizer:tapGesture];
    //2.2设置手势代理
    tapGesture.delegate = self;
}
- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint offsetP = [panGesture translationInView:self.mainView];
    CGRect mainViewFrame = self.mainView.frame;
//    NSLog(@"---{%lf}",offsetP.x);
    //不用transform，是因为它只能改变x和y；
    //初始时不能左移
    if(offsetP.x < 0 && mainViewFrame.origin.x == 0)
    {
        return ;
    }
    //右移后快速左移
    if(offsetP.x < 0 && mainViewFrame.origin.x <= 0.1)
    {
        self.mainView.frame = [UIScreen mainScreen].bounds;
        return ;
    }
    //到达右移最大x时停止右移
    if(offsetP.x > 0 && mainViewFrame.origin.x >= NJRightTarget)
    {
        return;
    }
    //添加蒙版
    
    self.mainView.frame = [self frameWithOffsetX:offsetP.x];
    //1.计算backgroudView的x
    CGFloat x = -NJSideX * (NJRightTarget - self.mainView.frame.origin.x) / NJRightTarget;
    //2.给backgroudView的frame赋值
    self.backgroundView.frame = [self backgroundframeWithX:x];
    //判断手势的状态
    if(panGesture.state == UIGestureRecognizerStateEnded)
    {
        float target  = 0;
        CGPoint velocity =  [panGesture velocityInView:self.mainView];
        NSLog(@"-------%@",NSStringFromCGPoint(velocity));
        if(velocity.x >= 500)
        {
            target = NJRightTarget;
        }
        else if(mainViewFrame.origin.x > NJScreenSize.width * 0.5)
        {
            target = NJRightTarget;
        }
        CGFloat offsetX = target - self.mainView.frame.origin.x;
        [UIView animateWithDuration:0.5 animations:^{
            self.mainView.frame = [self frameWithOffsetX:offsetX];
            self.backgroundView.frame = [self backgroundframeWithX:0];
        }];
    }
    //复位之后，偏移量为这次调用方法和上次调用方法的偏移量
    [panGesture setTranslation:CGPointZero inView:self.mainView];
}
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    //复原
    [UIView animateWithDuration:0.2 animations:^{
        self.mainView.frame = self.view.frame;
    }];
    
}
/**
 *  根据偏移量计算frame
 */
- (CGRect)frameWithOffsetX:(CGFloat)offsetX
{
    CGRect mainFrame = self.mainView.frame;
    mainFrame.origin.x += offsetX;
    return mainFrame;
}
//根据x换回backgroudView的frame
- (CGRect)backgroundframeWithX:(CGFloat)x
{
    CGRect backgroundFrame = self.backgroundView.frame;
    backgroundFrame.origin.x = x;
    return backgroundFrame;
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}
//是否接收点击事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //UITableViewCellContentView
//    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
//    {
//        return NO;
//    }
    return YES;
}
//是否接收按击事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press
{
    return YES;
}
#pragma mark -
- (IBAction)setterBtnClick:(id)sender
{
    //1.设置mainView右划完成后的frame
    CGRect mainViewFrame = self.mainView.frame;
    mainViewFrame.origin.x = NJRightTarget;
    //2.设置bgView右划完成后的frame
    CGRect bgViewFrame = self.backgroundView.frame;
    bgViewFrame.origin.x = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.frame = mainViewFrame;
        self.backgroundView.frame = bgViewFrame;
    }];
}
@end
