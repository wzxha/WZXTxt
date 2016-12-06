//
//  WZXTxtReaderBottomView.m
//  Example
//
//  Created by WzxJiang on 16/11/8.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXTxtReaderBottomView.h"

@implementation WZXTxtReaderBottomView {
    UIView * _contentView;
    UIView * _behindView;
    UIScrollView * _scrollView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
        [self createUI];
    }
    return self;
}

- (void)setUp {
    
}

- (void)createUI {
    [self createBehindView];
    
    _contentView = [UIView new];
    [self addSubview:_contentView];
    
    _contentView.backgroundColor     = [UIColor whiteColor];
    _contentView.layer.shadowColor   = [UIColor grayColor].CGColor;
    _contentView.layer.shadowOffset  = CGSizeMake(0.5, 0.5);
    _contentView.layer.shadowRadius  = 1;
    _contentView.layer.shadowOpacity = 0.8;
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(44));
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    _catalogueButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [_contentView addSubview: _catalogueButton];
    
    [_catalogueButton setTitle:@"目录" forState:UIControlStateNormal];
    [_catalogueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_contentView);
        make.left.equalTo(self).offset(10);
    }];
    
    _chapterButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [_contentView addSubview: _chapterButton];
    
    [_chapterButton setTitle:@"章节" forState:UIControlStateNormal];
    [_chapterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_contentView);
        make.left.equalTo(_catalogueButton.mas_right).offset(10);
    }];
    
    _lightButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [_contentView addSubview: _lightButton];
    
    [_lightButton setTitle:@"灯光" forState:UIControlStateNormal];
    [_lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_contentView);
        make.left.equalTo(_chapterButton.mas_right).offset(10);
    }];

}

- (void)createBehindView {
    _behindView = [UIView new];
    [self addSubview:_behindView];
    
    _behindView.backgroundColor     = [UIColor whiteColor];
    _behindView.layer.shadowColor   = [UIColor grayColor].CGColor;
    _behindView.layer.shadowOffset  = CGSizeMake(0.5, 0.5);
    _behindView.layer.shadowRadius  = 1;
    _behindView.layer.shadowOpacity = 0.8;
    
    [_behindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(100));
    }];
    
    _scrollView = [UIScrollView new];
    [_behindView addSubview:_scrollView];
    
    _scrollView.scrollEnabled = NO;
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_behindView);
    }];
    
    UIView * contentView = [UIView new];
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView).multipliedBy(2);
        make.height.equalTo(_scrollView);
    }];
    
    // - chapter
    UIView * chapterView = [UIView new];
    [contentView addSubview:chapterView];
    [chapterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        make.bottom.equalTo(contentView);
    }];
    
    _chapterSlider = [UISlider new];
    _lightSlider.value = [[UIScreen mainScreen] brightness];
    [chapterView addSubview:_chapterSlider];
    
    [_chapterSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(chapterView);
        make.centerY.equalTo(chapterView);
        make.width.equalTo(@(100));
    }];
    
    
    // - light
    UIView * lightView = [UIView new];
    [contentView addSubview:lightView];
    [lightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(chapterView.mas_right);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        make.bottom.equalTo(contentView);
    }];
    
    _lightSlider = [UISlider new];
    _lightSlider.value = [[UIScreen mainScreen] brightness];
    [lightView addSubview:_lightSlider];
    
    [_lightSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lightView);
        make.centerY.equalTo(lightView);
        make.width.equalTo(@(100));
    }];
    
    _darkBackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _darkBackgroundButton.backgroundColor = [UIColor blackColor];
    [lightView addSubview:_darkBackgroundButton];
    [_darkBackgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lightSlider.mas_bottom).offset(10);
        make.left.equalTo(lightView).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)changeBehindView:(BOOL)show num:(NSUInteger)num {
    [_behindView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(show? 0: 100);
    }];
    
    _scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * num, 0);
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)showBehindView:(NSUInteger)num {
    [self changeBehindView:YES num:num];
}

- (void)hideBehindView {
    [self changeBehindView:NO num:0];
}

- (void)changeThemeColor:(UIColor *)color {
    _contentView.backgroundColor = color;
    _behindView.backgroundColor  = color;
}

@end
