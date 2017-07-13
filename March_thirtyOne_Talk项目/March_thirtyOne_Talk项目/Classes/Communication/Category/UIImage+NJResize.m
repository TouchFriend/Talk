//
//  UIImage+NJResize.m
//  09 - qq聊天工具 - 01
//
//  Created by 陈显镇 on 16/9/5.
//  Copyright © 2016年 陈显镇. All rights reserved.
//

#import "UIImage+NJResize.h"

@implementation UIImage (NJResize)
/**
 *  获得经过拉伸的新的图片
 *
 *  @param name 图片名
 *
 *  @return 新的拉伸的图片
 */
+ (UIImage *)lastImageWithName:(NSString *)name
{
    UIImage * imageMe = [UIImage imageNamed:name];
    CGFloat top = imageMe.size.height * 0.5 - 1;
    CGFloat left = imageMe.size.width * 0.5 - 1;
    return [imageMe resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, top, left) resizingMode:UIImageResizingModeTile];
    
}
@end
