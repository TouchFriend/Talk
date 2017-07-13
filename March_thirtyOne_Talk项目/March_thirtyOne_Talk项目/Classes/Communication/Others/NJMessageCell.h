//
//  NJTableViewCell.h
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/8.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIImageView+NJImageRound.h"
#import "UIImage+NJResize.h"
@class NJMessageFrame;
@interface NJMessageCell : UITableViewCell
/********* 数据模型 *********/
@property(nonatomic,strong)NJMessageFrame * messageFrame;
//改变聊天背景
- (void)setBackGround:(NSString *)name;
@end
