//
//  NJBirthdayVC.h
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/5.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NJBirthdayVCDelegate;
@interface NJBirthdayVC : UIViewController
/********* 代理 *********/
@property(nonatomic,weak)id<NJBirthdayVCDelegate> delegate;
/********* 接收注册表的数据 *********/
@property(nonatomic,strong)NSString * birthdayDate;

@end
