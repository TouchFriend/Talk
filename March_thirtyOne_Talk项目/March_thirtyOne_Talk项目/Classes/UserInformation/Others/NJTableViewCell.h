//
//  NJTableViewCell.h
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/6.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NJInfo;
@interface NJTableViewCell : UITableViewCell
/********* 初始化数据 *********/
@property(nonatomic,strong)NJInfo * info;

@end
