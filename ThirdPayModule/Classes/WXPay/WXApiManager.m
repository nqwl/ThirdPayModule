//
//  WXApiManager.m
//  ThirdPayModule
//
//  Created by nqwl on 05/30/2018.
//  Copyright (c) 2018 nqwl. All rights reserved.
//


#import "WXApiManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation WXApiManager {
    NSString *_key;
}

#pragma mark - LifeCycle
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}
#pragma mark - App端调用微信支付
//由服务器统一下单：根据待支付的money，以及哪个用户支付，结合其他参数，向公司服务器发出请求，公司服务器会去微信支付服务器发出订单生成的请求，从而生成微信订单。
//从服务器请求下来prepayId，nonceStr，type后发起，APP端调起支付的参数列表
- (void)callWXPayWithOpenID:(NSString *)openId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId nonceStr:(NSString *)nonceStr type:(int)type key:(NSString *)key {
    if([WXApi isWXAppInstalled]) {
        _key = key;
        PayReq *req = [[PayReq alloc] init];
        req.openID = openId;//就是appid，相当于微信给你的app的标示
        req.partnerId = partnerId;//@"1384000202";商家id
        req.prepayId = prepayId;//预支付订单编号
        req.nonceStr = nonceStr;//随机字符串，防重发
        req.timeStamp = (int)[[NSDate date] timeIntervalSince1970];
        req.package = @"Sign=WXPay";
        req.type = type;
        req.sign = [self signWithPayReq:req];
        [WXApi sendReq:req];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"并未安装微信app" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}
- (NSString *)signWithPayReq:(PayReq *)req {
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: req.openID forKey:@"appid"];    //微信支付ID
    [signParams setObject: req.nonceStr forKey:@"noncestr"];
    [signParams setObject: req.package forKey:@"package"];
    [signParams setObject: req.partnerId forKey:@"partnerid"];
    [signParams setObject: [NSString stringWithFormat:@"%d",(unsigned int)req.timeStamp] forKey:@"timestamp"];
    [signParams setObject: req.prepayId forKey:@"prepayid"];
    //返回签名
    return [self createMd5Sign:signParams];
}
//第二次签名(服务器完成第一次签名)
- (NSString*) createMd5Sign:(NSMutableDictionary*)dict {
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (![[dict objectForKey:categoryId] isEqualToString:@""]&& ![categoryId isEqualToString:@"sign"]&& ![categoryId isEqualToString:@"key"]) {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", _key/*商户key(此参数一定得填(坑了我两天)我也不知道这个参数在哪里找的 只知道是微信官网的商户平台有关)*/];
    //得到MD5 sign签名
    NSString *md5Sign =[self MD5:contentString];

    return md5Sign;
}

//大写32位 MD5加密
- (NSString *) MD5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    return output;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        [self.delegate receivePayStatus:(NSInteger)resp.errCode];
        switch (resp.errCode) {
                /*
                WXSuccess           = 0,    成功
                WXErrCodeCommon     = -1,   普通错误类型
                WXErrCodeUserCancel = -2,   用户点击取消并返回
                WXErrCodeSentFail   = -3,   发送失败
                WXErrCodeAuthDeny   = -4,   授权失败
                WXErrCodeUnsupport  = -5,   微信不支持
                 */
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                break;
            case WXErrCodeCommon:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,@"普通错误类型"];
                break;
            case WXErrCodeUserCancel:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,@"用户点击取消并返回"];
                break;
            case WXErrCodeSentFail:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,@"发送失败"];
                break;
            case WXErrCodeAuthDeny:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,@"授权失败"];
                break;
            case WXErrCodeUnsupport:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,@"微信不支持"];
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
        NSLog(@"%@",strMsg);
    }else {
    }
}

- (void)onReq:(BaseReq *)req {

}

@end
