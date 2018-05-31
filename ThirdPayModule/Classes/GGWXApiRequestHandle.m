//
//  GGWXApiRequestHandle.m
//  ThirdPayModule_Example
//
//  Created by 亲点 on 2018/5/30.
//  Copyright © 2018年 nqwl. All rights reserved.
//

#import "GGWXApiRequestHandle.h"
#import <CommonCrypto/CommonDigest.h>

@implementation GGWXApiRequestHandle

//由服务器统一下单：根据待支付的money，以及哪个用户支付，结合其他参数，向公司服务器发出请求，公司服务器会去微信支付服务器发出订单生成的请求，从而生成微信订单。
//从服务器请求下来prepayId，nonceStr，type后发起，APP端调起支付的参数列表
- (void)callWXPayWithOpenID:(NSString *)openId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId nonceStr:(NSString *)nonceStr type:(int)type {
    if([WXApi isWXAppInstalled]) {
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
    [contentString appendFormat:@"key=%@", @"ymKqEY5goYnLk9JGT0BdBELArJH95SRq"/*商户key(此参数一定得填(坑了我两天)我也不知道这个参数在哪里找的 只知道是微信官网的商户平台有关)*/];
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

@end
