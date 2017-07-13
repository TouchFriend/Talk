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
@interface NJCommunicationVC () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/********* 聊天信息 *********/
@property(nonatomic,strong)NSMutableArray * messageArrM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToolStrainterHeight;
/********* 输入TextView *********/
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
/********* 沙盒路径 *********/
@property(nonatomic,strong)NSString * pathStr;


@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (IBAction)sendBtnClick;

@end

@implementation NJCommunicationVC
static NSString * ID = @"message";
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
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置cell不能选择
    self.tableView.allowsSelection = NO;
    //设置背景颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0  blue:223/255.0  alpha:1];
    //设置表格的Inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomToolStrainterHeight.constant, 0);
    //监听tableview点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewTouch) name:@"tableViewTouch" object:self.tableView];
    //设置textView的代理
    self.inputTextView.delegate = self;
    //监听textView的内容变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputViewValueChange) name:@"UITextViewTextDidChangeNotification" object:self.inputTextView];
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
    NJMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //设置cell数据
    cell.messageFrame = self.messageArrM[indexPath.row];
    return cell;
    
}
#pragma  mark - UITableViewDelegate方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NJMessageFrame * messageFrame = self.messageArrM[indexPath.row];
    return messageFrame.cellHeight;
}
#pragma mark - UITextViewDelegate方法
#pragma mark -
- (IBAction)sendBtnClick
{
    //解除文本框的第一响应者
    [self.inputTextView resignFirstResponder];
    NJMessage * message = [[NJMessage alloc]init];
    //1.用户头像
    message.icon = @"me";
    //2.发送的用户名
    message.senderName = self.userName;
    //3.聊天时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH:MM";
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
@end
