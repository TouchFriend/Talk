//
//  NJCommunicationVC.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/1.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJCommunicationVC.h"
#import "NJFriendsViewController.h"
#import "NJMessageFrame.h"
#import "NJMessage.h"
#import "NJMessageCell.h"
#import "NSDictionary+NJDictionaryWithModel.h"
#import "NSArray+NJDictionaryArrWithModelArr.h"
#import "NJTool.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "NJSecretMessageCell.h"
#import "NJSecretMessageCell.h"
@interface NJCommunicationVC () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/********* 聊天信息 *********/
@property(nonatomic,strong)NSMutableArray * messageArrM;
/********* 底部工具栏的高度 *********/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToolStrainterHeight;
/********* 输入TextView *********/
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
/********* 沙盒路径 *********/
@property(nonatomic,strong)NSString * pathStr;

/********* 发送按钮 *********/
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
/********* 点击发送按钮 *********/
- (IBAction)sendBtnClick;
/********* 阅后即焚按钮 *********/
@property (weak, nonatomic) IBOutlet UIButton *burnAfterReadingBtn;
/********* 点击阅后即焚 *********/
- (IBAction)burnAfterReadingBtnClick;
/********* 是否开启阅后即焚 *********/
@property(nonatomic,assign)BOOL isOpenBurnAfterReading;
/********* 会话管理者 *********/
@property(nonatomic,strong)AFHTTPSessionManager * manager;
@end

@implementation NJCommunicationVC
static NSString * ID = @"message";
static NSString * secretMessageID = @"secretMessage";
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    self.navigationItem.title = @"聊天";
    //设置导航条的右标题
    UIBarButtonItem * friendsBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"好友" style:UIBarButtonItemStylePlain target:self action:@selector(openFriendList)];
    [self.navigationItem setRightBarButtonItem:friendsBtnItem animated:YES];
    //监听键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //设置tableView的数据源和代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //注册cell
    [self.tableView registerClass:[NJMessageCell class] forCellReuseIdentifier:ID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NJSecretMessageCell class]) bundle:nil] forCellReuseIdentifier:secretMessageID];
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置背景颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0  blue:223/255.0  alpha:1];
    //设置表格的Inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomToolStrainterHeight.constant, 0);
    //监听tableview点击
    [self addGestureRecognizes];
    //设置textView的代理
    self.inputTextView.delegate = self;
    //监听textView的内容变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputViewValueChange) name:@"UITextViewTextDidChangeNotification" object:self.inputTextView];
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessage:) name:@"messageCome" object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //显示navigationBar
    self.navigationController.navigationBar.hidden = NO;

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //拉到tableview的底部
    [self pullToTableBottom];
}
//懒加载
- (NSMutableArray *)messageArrM
{
    if(_messageArrM == nil)
    {
        if(![[NSFileManager defaultManager] fileExistsAtPath:self.pathStr])
        {
            [[NSFileManager defaultManager] createFileAtPath:self.pathStr contents:nil attributes:nil];
            _messageArrM = [NSMutableArray array];
            return _messageArrM;
        }
        //从沙盒路径中获取数据
        NSArray * messageArr = [NSArray arrayWithContentsOfFile:self.pathStr];
        NSMutableArray * messageArrM = [NSMutableArray array];
        for (NSDictionary * dic in messageArr) {
            NJMessage * message = [NJMessage messageWithDic:dic];
            //判断时间跟上一条消息是否相同，相同就隐藏
            NJMessageFrame * lastMessFrame = [messageArrM lastObject];
            if([lastMessFrame.message.time isEqualToString:message.time])
            {
                message.hideTime = YES;
            }
            else
            {
                message.hideTime = NO;
            }
            //创建模型
            NJMessageFrame * messageFrame = [[NJMessageFrame alloc]init];
            messageFrame.message = message;
            [messageArrM addObject:messageFrame];
        };
        _messageArrM = messageArrM;
    }
    return _messageArrM;
}
- (AFHTTPSessionManager *)manager
{
    if(_manager == nil)
    {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (NSString *)pathStr
{
    if(_pathStr == nil)
    {
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * newPath = [path stringByAppendingPathComponent:@"messages.plist"];
        NSLog(@"%@",newPath);
        _pathStr = newPath;
    }
    return _pathStr;
}
- (void)keyBoardWillShow:(NSNotification *)keyBoardNoti
{
    //出现键盘时，view整个上移
    CGFloat duration = [[keyBoardNoti.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect endFram = [[keyBoardNoti.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat changeY = endFram.origin.y - [UIScreen mainScreen].bounds.size.height   ;
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, changeY);
    }];
    
}
//打开好友列表
- (void)openFriendList
{
    NJFriendsViewController * friendVC = [[NJFriendsViewController alloc]init];
    [self.navigationController pushViewController:friendVC animated:YES];
}
- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
 UIKeyboardAnimationCurveUserInfoKey = 7;
 UIKeyboardAnimationDurationUserInfoKey = "0.25";
 UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {414, 271}}";
 UIKeyboardCenterBeginUserInfoKey = "NSPoint: {207, 871.5}";
 UIKeyboardCenterEndUserInfoKey = "NSPoint: {207, 600.5}";
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 736}, {414, 271}}";
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 465}, {414, 271}}";
 UIKeyboardIsLocalUserInfoKey = 1;
 */
#pragma  mark - UITableViewDataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出model
    NJMessageFrame * messageFrame = self.messageArrM[indexPath.row];
    //1.不是阅后即焚
    if(!messageFrame.message.secretMessageFlag)
    {
        NJMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        //设置cell数据
        cell.messageFrame = messageFrame;
        return cell;
    }
    //2.是阅后即焚且未看过
    else if(messageFrame.message.secretMessageFlag && !messageFrame.message.hasReaded)
    {
        NJSecretMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:secretMessageID];
        return cell;
    }
    //3.是阅后即焚且看过
    else
    {
        NJMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        //设置cell数据
        cell.messageFrame = messageFrame;
        //改变cell的聊天背景
        [cell setBackGround:@"background"];
        return cell;
    }
    NJMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //设置cell数据
    cell.messageFrame = self.messageArrM[indexPath.row];
    return cell;
    
}
#pragma  mark - UITableViewDelegate方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NJMessageFrame * messageFrame = self.messageArrM[indexPath.row];
    if(messageFrame.message.secretMessageFlag && !messageFrame.message.hasReaded)
    {
        return 60;
    }
    return messageFrame.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //解除输入框的第一响应者
    [self tableViewTouch];
    NSLog(@"didSelectRowAtIndexPath-----%ld",indexPath.row);
    NJMessageFrame * messageFrame = self.messageArrM[indexPath.row];
    if(messageFrame.message.secretMessageFlag && !messageFrame.message.hasReaded)
    {
        messageFrame.message.hasReaded = YES;
        [self.tableView reloadData];
        //tablevie移到末尾
        [self pullToTableBottom];
        //通过文字长度计算延迟时间
        CGFloat time = (messageFrame.message.text.length / 3.5) > 4.0 ? (messageFrame.message.text.length / 3.5) : 4.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //从后往前遍历模型数组
            for (NSInteger index = self.messageArrM.count - 1; index >= 0; index--)
            {
                //找到阅后即焚消息后删除
                if(messageFrame == self.messageArrM[index])
                {
                    [self.messageArrM removeObjectAtIndex:index];
                    break;
                }
            }
            //刷新表格
            [self.tableView reloadData];
            //tablevie移到末尾
            [self pullToTableBottom];
            //通知服务器消息已经阅读过了
            [self secretMessageHasReaded:messageFrame.message.MessageID];
        });
        

    }

}
#pragma mark - UITextViewDelegate方法
#pragma mark - 点击发送按钮
- (IBAction)sendBtnClick
{
    //1.拼接URL
    NSString * urlStr = [NJServiceHttp stringByAppendingPathComponent:NJSendMessage];
    //拼接Token
    NSString * urlToken = [urlStr stringByAppendingPathComponent:[NJTool getToken]];
    NSLog(@"urlToken----%@",urlToken);
    //2.参数字典
    NSMutableDictionary * parameterDicM = [NSMutableDictionary dictionary];
    //2.1获取聊天信息
    NJMessage * message = [self getMessage];
    NSDictionary * messageDic = [NSDictionary dictionaryWithMessageModel:message];
    //2.2设置为其他人消息
    [messageDic setValue:@1 forKey:@"type"];
    //2.3设置是否是阅后即焚
    [messageDic setValue:@(self.isOpenBurnAfterReading) forKey:@"secretMessageFlag"];
    NSLog(@"%@",messageDic);
    //3.1聊天信息
    [parameterDicM setObject:messageDic forKey:@"message"];
    //3.2是否是阅后即焚
    [parameterDicM setObject:@(self.isOpenBurnAfterReading) forKey:@"is_secret"];
    [self.manager POST:urlToken parameters:parameterDicM progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"status"] intValue] < 0)
        {
            NSLog(@"%@",responseObject[@"inf"]);
            NSString * info = responseObject[@"inf"];
            //提示
            [SVProgressHUD showErrorWithStatus:info];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
//        NSLog(@"responseObject----%@----%@",responseObject, responseObject[@"inf"]);
        //给聊天信息添加ID
        message.MessageID = [responseObject[@"message_id"] integerValue];
        //保存信息
        [self saveMessage:message];
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error)
        {
            NSLog(@"%@",error);
        }
    }];
    

}
- (void)saveMessage:(NJMessage *)message
{
    //7.创建NJMessageFrame模型
    NJMessageFrame * messageFrame = [[NJMessageFrame alloc]init];
    messageFrame.message = message;
    
    //8.将数据模型到模型数组中
    [self.messageArrM addObject:messageFrame];
    //9.刷新表格
    [self.tableView reloadData];
    //10.清除数据
    self.inputTextView.text = @"";
    self.sendBtn.enabled = NO;
    //11.将数据写入沙盒
    //模型数组转字典数组
    NSArray * dicArr = [NSArray dictionaryArrWithModelArr:self.messageArrM];
    [dicArr writeToFile:self.pathStr atomically:YES];
    //12.拉到tableview的底部
    [self pullToTableBottom];
}
- (NJMessage *)getMessage
{
    NJMessage * message = [[NJMessage alloc]init];
    //1.用户头像
    message.icon = [NJTool getIcon];
    //2.发送的用户名
    message.senderName = self.userName;
    //3.聊天时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * nowDate = [NSDate date];
    NSString * nowDateStr = [formatter stringFromDate:nowDate];
    message.time = nowDateStr;
    //4.聊天内容
    message.text = self.inputTextView.text;
    //5.发送者
    message.type = NJSendMessMe;
    //6.判断日期跟上一条是否一致
    NJMessageFrame * lastMessageF = self.messageArrM.lastObject;
    message.hideTime = [message.time isEqualToString:lastMessageF.message.time];
    return message;
}
#pragma mark - 点击tableview时
- (void)tableViewTouch
{
    //解除文本框的第一响应者
    [self.inputTextView resignFirstResponder];
}
//判断发送按钮是否可用
- (void)inputViewValueChange
{
    self.sendBtn.enabled = (self.inputTextView.text.length > 0);
}

//拉到tableview的底部
- (void)pullToTableBottom
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(self.tableView.contentSize.height <= screenHeight - self.tableView.contentInset.bottom)
    {
        return;
    }
    self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height + self.tableView.contentInset.bottom);
}
/********* 点击阅后即焚 *********/
- (IBAction)burnAfterReadingBtnClick
{
    if(!self.isOpenBurnAfterReading)
    {
        self.sendBtn.backgroundColor = [UIColor redColor];
        self.burnAfterReadingBtn.backgroundColor = [UIColor redColor];
        self.isOpenBurnAfterReading = YES;
    }
    else
    {
        self.sendBtn.backgroundColor = [UIColor blueColor];
        self.burnAfterReadingBtn.backgroundColor = [UIColor blueColor];
        self.isOpenBurnAfterReading = NO;
    }
}
#pragma mark - 接收到消息通知
/*
 group = 3;
 id = 43;
 "is_chat" = 0;
 "is_secret" = 0;
 message = "<NJMessage: 0x170c6e000>";
 "publish_time" = "2017-04-19 17:24:40";
 publisher = 5;
 receiver = "<null>";
 */
- (void)getMessage:(NSNotification *)notification
{
    @synchronized (self) {
        NSLog(@"%@----%@",@"noti",notification.userInfo);
        NSArray * messageArr = notification.userInfo[@"messages"];
        NSArray * secretNoticeArr = notification.userInfo[@"secret_notice"];
        if(messageArr.count > 0)
        {
            for (NSDictionary * message in messageArr)
            {
                if(message[@"receiver"] == [NSNull null])
                {
                    //将数据添加到数据数组中
                    NSString * messageStr = (NSString *)message[@"message"];
                    NSDictionary * messageDic = [NSJSONSerialization JSONObjectWithData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    NJMessage * getMessage = [NJMessage messageWithDic:messageDic];
                    //设置消息ID
                    //                    getMessage.MessageID = [message[@"id"] integerValue];
                    getMessage.MessageID = [message[@"id"]  integerValue];
                    NSLog(@"message---%@",getMessage);
                    NJMessageFrame * messageFrame = [[NJMessageFrame alloc]init];
                    messageFrame.message = getMessage;
                    //将数据添加到数据数组中
                    [self.messageArrM addObject:messageFrame];
                    //刷新表格
                    [self.tableView reloadData];
                    //拉到tableview的底部
                    [self pullToTableBottom];
                }
            }
        }
        else if (secretNoticeArr.count > 0 )
        {
            for (NSNumber * number in secretNoticeArr)
            {
                //从后往前遍历模型数组
                for (NSInteger index = self.messageArrM.count - 1; index >= 0; index-- )
                {
                    NJMessageFrame * messageFrame = (NJMessageFrame *)self.messageArrM[index];
                    //找到后删除阅后即焚消息
                    if(messageFrame.message.MessageID == [number integerValue])
                    {
                        [self.messageArrM removeObjectAtIndex:index];
                        [self.tableView reloadData];
                        break;
                    }
                }

            }
        }


    }
}
#pragma mark -
- (void)addGestureRecognizes
{
    //为tableview添加tap手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewTouch)];
    [self.tableView addGestureRecognizer:tapGesture];
    //设置代理
    tapGesture.delegate = self;
}
#pragma mark - UIGestureRecognizerDelegate方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self.tableView];
    if(touchPoint.y < self.tableView.contentSize.height)
    {
        return NO;
    }
    return YES;
}
#pragma mark - 阅后即焚被阅读后向服务器发送通知
- (void)secretMessageHasReaded:(NSInteger)messageID
{
    //1.拼接URL
    NSString * urlStr = [NJServiceHttp stringByAppendingPathComponent:NJSecretMessagehasReaded];
    //2.拼接消息ID
    NSString * urlMessage = [urlStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",messageID]];
    //3.拼接Token
    NSString * urlToken = [urlMessage stringByAppendingPathComponent:[NJTool getToken]];
    NSLog(@"urlToken----%@",urlToken);
    //4.发送请求
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error)
        {
            NSLog(@"%@",error);
        }
    }];

}
@end
