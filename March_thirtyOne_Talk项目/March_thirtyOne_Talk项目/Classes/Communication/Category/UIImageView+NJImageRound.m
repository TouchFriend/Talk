//
//  UIImageView+NJImageRound.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/8.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "UIImageView+NJImageRound.h"

@implementation UIImageView (NJImageRound)
- (void)setToRound
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width / 2.0;
}
@end
