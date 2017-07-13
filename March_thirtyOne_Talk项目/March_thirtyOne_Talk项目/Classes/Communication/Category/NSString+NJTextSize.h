//
//  NSString+NJResize.h
//  09 - qq聊天工具 - 01
//
//  Created by 陈显镇 on 16/9/5.
//  Copyright © 2016年 陈显镇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (NJResize)
- (CGSize)textSizeWithFont:(UIFont *)font size:(CGSize)maxSize;
@end
