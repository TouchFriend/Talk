//
//  NSString+NJResize.m
//  09 - qq聊天工具 - 01
//
//  Created by 陈显镇 on 16/9/5.
//  Copyright © 2016年 陈显镇. All rights reserved.
//

#import "NSString+NJTextSize.h"

@implementation NSString (NJResize)
/**
 *  返回文字的尺寸
 *
 *  @param font    字体
 *  @param maxSize 文字的最大尺寸
 *
 *  @return 返回文字的尺寸
 */
- (CGSize)textSizeWithFont:(UIFont *)font size:(CGSize)maxSize
{
    NSDictionary * dict = @{NSFontAttributeName:font};
    CGSize nameMaxSize = CGSizeMake(maxSize.width, maxSize.height);
    return [self boundingRectWithSize:nameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}
@end
