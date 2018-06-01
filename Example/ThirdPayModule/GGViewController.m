//
//  GGViewController.m
//  ThirdPayModule
//
//  Created by nqwl on 05/30/2018.
//  Copyright (c) 2018 nqwl. All rights reserved.
//

#import "GGViewController.h"
#import "AliPayApiManager.h"
@interface GGViewController ()

@end

@implementation GGViewController
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *appScheme = @"";
    NSString *orderString;
    [[AliPayApiManager sharedManager] callAliPayWith:orderString appScheme:appScheme callback:^(NSDictionary *resultDic) {

    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
