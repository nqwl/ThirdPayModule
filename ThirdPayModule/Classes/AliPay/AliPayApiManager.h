//
//  AliPayApiManager.h
//  ThirdPayModule_Example
//
//  Created by 亲点 on 2018/6/1.
//  Copyright © 2018年 nqwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

@interface AliPayApiManager : NSObject
+ (instancetype)sharedManager;

#pragma mark - 为了保证公钥私钥的安全性，重点提示这个orderStr一定要经过后台签名加密获取，不建议在iOS端进行私钥加密
/**
 *  支付接口
 *
 *  @param orderStr       订单信息，为了保证公钥私钥的安全性，重点提示这个orderStr一定要经过后台签名加密获取，不建议在iOS端进行私钥加密
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param completionBlock 支付结果回调Block，用于wap支付结果回调（非跳转钱包支付）
 */
- (void)callAliPayWith:(NSString *)orderString appScheme:(NSString *)appScheme callback:(CompletionBlock)completionBlock;

/**
 *  处理授权信息Url
 *
 *  @param resultUrl        钱包返回的授权结果url
 *  @param completionBlock  授权结果回调
 */
- (void)nqwl_processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(CompletionBlock)completionBlock;

/**
 *  处理授权信息Url
 *
 *  @param resultUrl        钱包返回的授权结果url
 *  @param completionBlock  授权结果回调
 */
- (void)nqwl_processAuth_V2Result:(NSURL *)resultUrl
                  standbyCallback:(CompletionBlock)completionBlock;
@end
