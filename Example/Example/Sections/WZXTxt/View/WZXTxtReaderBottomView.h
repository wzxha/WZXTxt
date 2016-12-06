//
//  WZXTxtReaderBottomView.h
//  Example
//
//  Created by WzxJiang on 16/11/8.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZXTxtReaderBottomView : UIView

@property (nonatomic, strong) UIButton * catalogueButton;

@property (nonatomic, strong) UIButton * chapterButton;

@property (nonatomic, strong) UIButton * lightButton;

@property (nonatomic, strong) UISlider * chapterSlider;

@property (nonatomic, strong) UISlider * lightSlider;

@property (nonatomic, strong) UIButton * darkBackgroundButton;

- (void)showBehindView:(NSUInteger)num;

- (void)hideBehindView;

- (void)changeThemeColor:(UIColor *)color;
@end
