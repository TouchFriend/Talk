//
//  NJUDPSendSocket.h
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/4/9.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
@interface NJUDPSendSocket : NSObject
/********* sendSocket *********/
@property(nonatomic,strong)GCDAsyncUdpSocket * sendSockt;
+ (instancetype)defaultUDPSendSocket;

@end
