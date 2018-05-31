//
//  GGWXApiRequestHandle.h
//  ThirdPayModule_Example
//
//  Created by 亲点 on 2018/5/30.
//  Copyright © 2018年 nqwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
@interface GGWXApiRequestHandle : NSObject
- (void)callWXPayWithOpenID:(NSString *)openId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId nonceStr:(NSString *)nonceStr type:(int)type;

@end
