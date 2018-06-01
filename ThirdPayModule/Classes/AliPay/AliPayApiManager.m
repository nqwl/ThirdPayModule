//
//  AliPayApiManager.m
//  ThirdPayModule_Example
//
//  Created by 亲点 on 2018/6/1.
//  Copyright © 2018年 nqwl. All rights reserved.
//

#import "AliPayApiManager.h"

@implementation AliPayApiManager
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static AliPayApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AliPayApiManager alloc] init];
    });
    return instance;
}
- (void)callAliPayWith:(NSString *)orderString appScheme:(NSString *)appScheme callback:(CompletionBlock)completionBlock {
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:completionBlock];
}
- (void)nqwl_processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(CompletionBlock)completionBlock {
    [[AlipaySDK defaultService] processAuthResult:resultUrl standbyCallback:completionBlock];
}
- (void)nqwl_processAuth_V2Result:(NSURL *)resultUrl
             standbyCallback:(CompletionBlock)completionBlock {
    [[AlipaySDK defaultService] processAuth_V2Result:resultUrl standbyCallback:completionBlock];
}
@end
