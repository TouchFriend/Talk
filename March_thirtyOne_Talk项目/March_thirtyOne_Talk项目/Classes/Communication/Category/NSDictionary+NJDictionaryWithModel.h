//
//  NSDictionary+NJDictionaryWithModel.h
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/9.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NJMessageFrame;
@class NJMessage;
@interface NSDictionary (NJDictionaryWithModel)
//模型转字典
+ (NSDictionary *)dictionaryWithModel:(NJMessageFrame *)messageF;
+ (NSDictionary *)dictionaryWithMessageModel:(NJMessage *)message;
@end
