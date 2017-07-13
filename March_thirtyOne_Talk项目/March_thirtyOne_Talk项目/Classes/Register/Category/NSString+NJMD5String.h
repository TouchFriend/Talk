//
//  NSString+NJMD5String.h
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/9.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NJMD5String)
/**
 MD5加密
 
 @param sourceString 要加密的字符串
 @return 加密后的字符串
 */
+ (NSString *)md5String:(NSString *)sourceString;
@end
