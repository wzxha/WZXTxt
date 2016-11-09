//
//  WZXTxtReaderBottomView.m
//  Example
//
//  Created by WzxJiang on 16/11/8.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXTxtReaderBottomView.h"

@implementation WZXTxtReaderBottomView

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
        [self createUI];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor   = [UIColor grayColor].CGColor;
    self.layer.shadowOffset  = CGSizeMake(0.5, 0.5);
    self.layer.shadowRadius  = 3;
    self.layer.shadowOpacity = 0.5;
}

- (void)createUI {
    _catalogueButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self addSubview: _catalogueButton];
    
    [_catalogueButton setTitle:@"目录" forState:UIControlStateNormal];
    [_catalogueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(10));
    }];
}

@end
