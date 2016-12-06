//
//  WZXTheme.h
//  Example
//
//  Created by WzxJiang on 16/11/11.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZXTheme : NSObject

@property (nonatomic, copy) UIColor * textColor;

@property (nonatomic, copy) UIColor * backgroundColor;

@property (nonatomic, copy) UIColor * assistColor;

@property (nonatomic, copy) UIColor * navColor;


+ (instancetype)defaultTheme;

@end
