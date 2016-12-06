//
//  WZXTheme.m
//  Example
//
//  Created by WzxJiang on 16/11/11.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXTheme.h"

@implementation WZXTheme

+ (instancetype)defaultTheme {
    WZXTheme * theme      = [WZXTheme new];
    theme.textColor       = [UIColor blackColor];
    theme.backgroundColor = [UIColor whiteColor];
    theme.assistColor     = [UIColor grayColor];
    theme.navColor        = [UIColor whiteColor];
    return theme;
}

@end
