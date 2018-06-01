//
//  WXApiManager.h
//  ThirdPayModule
//
//  Created by nqwl on 05/30/2018.
//  Copyright (c) 2018 nqwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol WXApiManagerDelegate <NSObject>

@optional
/**
 用户微信支付状态
 @param payStatus
    WXSuccess           = 0,    成功
    WXErrCodeCommon     = -1,   普通错误类型
    WXErrCodeUserCancel = -2,   用户点击取消并返回
    WXErrCodeSentFail   = -3,   发送失败
    WXErrCodeAuthDeny   = -4,   授权失败
    WXErrCodeUnsupport  = -5,   微信不支持
 */
- (void)receivePayStatus:(NSInteger )payStatus;
@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;

//App端需要微信支付的时候调用
- (void)callWXPayWithOpenID:(NSString *)openId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId nonceStr:(NSString *)nonceStr type:(int)type key:(NSString *)key;

@end
