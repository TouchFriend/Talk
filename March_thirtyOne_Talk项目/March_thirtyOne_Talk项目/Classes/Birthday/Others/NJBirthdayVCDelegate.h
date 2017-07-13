//
//  NJBirthdayDelegate.h
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/5.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NJBirthdayVC;
@protocol NJBirthdayVCDelegate <NSObject>
@optional
-(void)birthdayVC:(NJBirthdayVC *)birthdayVC dateStr:(NSString *)str age:(NSString *)age;
@end
