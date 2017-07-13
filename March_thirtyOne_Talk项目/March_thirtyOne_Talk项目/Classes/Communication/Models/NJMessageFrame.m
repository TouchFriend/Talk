//
//  NJMessageFrame.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/8.
//  Copyright © 2017年 cxz. All rights reserved.
//
#define NJTextMaxSize [UIScreen mainScreen].bounds.size.width - 140
#import "NJMessageFrame.h"
#import "NJMessage.h"
#import "NSString+NJTextSize.h"
@implementation NJMessageFrame
- (void)setMessage:(NJMessage *)messagE
{
    _message = messagE;
    CGFloat padding = 10;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //1.时间Frame
    if(messagE.hideTime == NO)
    {
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeW = screenSize.width;
        CGFloat timeH = 10;
        _timeFram = CGRectMake(timeX, timeY, timeW, timeH);
    }
    //2.头像
    CGFloat iconY = CGRectGetMaxY(_timeFram);
    CGFloat iconW = 50;
    CGFloat iconH = iconW;
    CGFloat iconX;
    if(messagE.type == NJSendMessOther)
    {
        iconX = padding;
    }
    else
    {
        iconX = screenSize.width - padding - iconW;
    }
    _iconFram = CGRectMake(iconX, iconY, iconW, iconH);
    //3.用户名
    CGFloat userNameY = CGRectGetMaxY(_timeFram);
    CGFloat userNameW = screenSize.width / 2.0 - _iconFram.size.width - 2 * padding;
    //用户名的最大size
    CGSize userNameMaxSize = CGSizeMake(userNameW, MAXFLOAT);
    //文字的真实size
    CGSize userNameSize = [[NSString stringWithFormat:@"%@:",messagE.senderName] textSizeWithFont:NJUserNameFont size:userNameMaxSize];
    CGFloat userNameX;
    if(messagE.type == NJSendMessOther)
    {
        userNameX = CGRectGetMaxX(_iconFram) + padding;
    }
    else
    {
        userNameX = iconX - padding - userNameSize.width;
    }
    _userNameFram = (CGRect){{userNameX,userNameY},userNameSize};
    //4.聊天内容
    CGFloat textY = CGRectGetMaxY(_userNameFram);
    //文字的最大size
    
    CGSize textMaxSize = CGSizeMake(NJTextMaxSize, MAXFLOAT);
    //文字的真实size
    CGSize textSize = [messagE.text textSizeWithFont:NJContentFont size:textMaxSize];
    //按钮的真实size
    CGSize btnSize = CGSizeMake(textSize.width + NJTextPadding * 2, textSize.height + NJTextPadding * 2);
    CGFloat textX;
    if(messagE.type == NJSendMessOther)
    {
        textX = CGRectGetMaxX(_iconFram) + padding;
    }
    else
    {
        textX = iconX - padding - btnSize.width;
    }
    _textFram = (CGRect){{textX,textY},btnSize};
    //5.cell的高度
    CGFloat iconMaxY = CGRectGetMaxY(_iconFram) + 1.5 * padding;
    CGFloat textMaxY = CGRectGetMaxY(_textFram) + 1.5 * padding;
    _cellHeight = MAX(iconMaxY, textMaxY);
}

@end
