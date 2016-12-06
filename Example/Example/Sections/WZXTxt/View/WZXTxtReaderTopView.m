//
//  WZXTxtReaderTopView.m
//  Example
//
//  Created by WzxJiang on 16/11/8.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXTxtReaderTopView.h"

@implementation WZXTxtReaderTopView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:_backButton];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self);
        make.width.equalTo(@(100));
        make.bottom.equalTo(self);
    }];
    
    UILabel * backLabel = [UILabel new];
    [_backButton addSubview:backLabel];
    
    backLabel.text = @"返回";
    backLabel.textColor = [UIColor blueColor];
    [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backButton);
        make.left.equalTo(_backButton).offset(5);
    }];
    
}


@end
