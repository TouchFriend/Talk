//
//  NJUserInfoVC.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/1.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJUserInfoVC.h"
#import "NJCommunicationVC.h"
#import "UIImage+Image.h"
#import "NJTableViewCell.h"
#import "NJInfo.h"
#import "MJExtension.h"
#define NJOriginY -320
#define NJOriginBgConstraintHeight 200
#define NJOriginUserNameConstraintheight 120
#define NJNavigationBarHeight 64
//NJOriginUserNameConstraintheight + 20(statusBar)
#define NJStopY 140
@interface NJUserInfoVC () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgConstraintHeight;
/********* 用户信息 *********/
@property(nonatomic,strong)NSArray * userInfoArr;
/********* 昵称 *********/
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *communicationBtn;

- (IBAction)CommuniBtnClick;
@end

@implementation NJUserInfoVC
static NSString * ID = @"userInfo";
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置数据源和代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //禁止自动设置偏移量
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置偏移量
    self.tableView.contentInset = UIEdgeInsetsMake(-NJOriginY, 0, 0, 0);
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NJTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    //初始化昵称
    NJInfo * info = (NJInfo *)self.userInfoArr[1];
    self.userNameLabel.text = info.content;
    //设置聊天按钮的圆角
    [self setCommunicationBtnRound];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏navigationBar
    self.navigationController.navigationBar.hidden = YES;
    //将头像设置成圆形
    [self setIconRound];
}
//懒加载
- (NSArray *)userInfoArr
{
    if(_userInfoArr == nil)
    {
        _userInfoArr = [NJInfo mj_objectArrayWithFilename:@"userInformation.plist"];
    }
    return _userInfoArr;
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
    return self.userInfoArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //设置数据
    cell.info = self.userInfoArr[indexPath.row];
    return cell;
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
#pragma mark -
- (IBAction)CommuniBtnClick {
    NJCommunicationVC * communiVC = [[NJCommunicationVC alloc]init];
    communiVC.userName = self.userNameLabel.text;
    [self.navigationController pushViewController:communiVC animated:YES];
}
@end
