//
//  NJTableViewCell.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/8.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJMessageCell.h"
#import "NJMessageFrame.h"
#import "NJMessage.h"
@interface NJMessageCell ()
/********* 时间 *********/
@property(nonatomic,strong)UILabel * timeLabel;
/********* 用户头像 *********/
@property(nonatomic,strong)UIImageView * iconImageView;
/********* 用户名 *********/
@property(nonatomic,strong)UILabel * userNameLabel;
/********* 聊天内容 *********/
@property(nonatomic,strong)UIButton * textBtn;

@end
@implementation NJMessageCell 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //添加控件
        //1.时间
        UILabel * timeLabel = [[UILabel alloc]init];
        self.timeLabel = timeLabel;
        //文字居中
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        //字体
        [self.timeLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self addSubview:timeLabel];
        //2.头像
        UIImageView * iconImageView = [[UIImageView alloc]init];
        self.iconImageView = iconImageView;

        [self addSubview:iconImageView];
        //3.用户名
        UILabel * userNameLabel = [[UILabel alloc]init];
        self.userNameLabel = userNameLabel;
        //设置字体
        [userNameLabel setFont:NJUserNameFont];
        [self addSubview:userNameLabel];
        //4.聊天内容
        UIButton * textBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.textBtn = textBtn;
        //设置换行
        self.textBtn.titleLabel.numberOfLines = 0;
        //设置字体
        textBtn.titleLabel.font = NJContentFont;
        //设置内容外边距
        textBtn.contentEdgeInsets = UIEdgeInsetsMake(NJTextPadding, NJTextPadding, NJTextPadding, NJTextPadding);
        [self addSubview:textBtn];
         //5.设置cell的背景色
        [self setBackgroundColor:[UIColor clearColor]];
        //6.设置cell选中的样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
//布局控件
- (void)layoutSubviews
{
    
    //1.时间
    self.timeLabel.frame = self.messageFrame.timeFram;
    //2.头像
    self.iconImageView.frame = self.messageFrame.iconFram;
    //设置圆角
    [self.iconImageView setToRound];
    //3.用户名
    self.userNameLabel.frame = self.messageFrame.userNameFram;
    //4.聊天内容
    self.textBtn.frame = self.messageFrame.textFram;
}
//给控件赋值
- (void)setMessageFrame:(NJMessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    //取出模型
    //1.时间
    NJMessage * message = messageFrame.message;
    //2.头像
    self.timeLabel.text = message.time;
    self.iconImageView.image = [UIImage imageNamed:message.icon];
    //3.用户名
    self.userNameLabel.text = [NSString stringWithFormat:@"%@:",message.senderName];
    //4.聊天内容
    [self.textBtn setTitle:message.text forState:UIControlStateNormal];
    //设置背景和字体颜色
    if(message.type == NJSendMessOther)
    {
        [self.textBtn setBackgroundImage:[UIImage lastImageWithName:@"chat_recive_nor"] forState:UIControlStateNormal];
        [self.textBtn setBackgroundImage:[UIImage lastImageWithName:@"chat_recive_press_pic"] forState:UIControlStateHighlighted];
        //设置字体颜色
        [self.textBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.textBtn setBackgroundImage:[UIImage lastImageWithName:@"chat_send_nor"] forState:UIControlStateNormal];
        [self.textBtn setBackgroundImage:[UIImage lastImageWithName:@"chat_send_press_pic"] forState:UIControlStateHighlighted];
        //设置字体颜色
        [self.textBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
//改变聊天背景
- (void)setBackGround:(NSString *)name
{
    [self.textBtn setBackgroundImage:[UIImage lastImageWithName:name] forState:UIControlStateNormal];
}
@end
