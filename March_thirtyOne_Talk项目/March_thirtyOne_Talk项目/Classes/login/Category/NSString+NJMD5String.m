//
//  NSString+NJMD5String.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/9.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NSString+NJMD5String.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSString (NJMD5String)
+ (NSString *)md5String:(NSString *)sourceString
{
    if(!sourceString)
    {
        return nil;
    }
    //1.先转换为c字符串
    const char * cString = sourceString.UTF8String;
    //2.存储加密结果
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    /*
     第一个参数：要加密的字符串
     第二个参数：要加密的字符串的长度
     第三个参数：加密后的字符串存储的地方
     */
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    NSMutableString * resultStrM = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [resultStrM appendString:[NSString stringWithFormat:@"%02x",result[i]]];
    }
//    NSLog(@"加密后的字符串：%@",resultStrM);
    return resultStrM;
    
}
@end
