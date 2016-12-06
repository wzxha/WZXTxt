//
//  EasyHUD.m
//  Example
//
//  Created by WzxJiang on 16/11/10.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "VisHUD.h"

@interface VisHUDView : UIView

@end

@implementation VisHUDView {
    UIActivityIndicatorView * _indicatorView;
    UILabel                 * _label;
    BOOL                      _dismissed;
}

- (instancetype)init {
    if (self = [super init]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)show:(NSString *)text afterDelay:(CGFloat)second {
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_indicatorView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    if (text) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:8];
        _label.text = text;
        _label.textColor = [UIColor grayColor];
        _label.numberOfLines = 0;
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_label];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_indicatorView attribute:NSLayoutAttributeBottom multiplier:1 constant:3]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
    }
    
    [_indicatorView startAnimating];
    
    if (second > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }
}

- (void)dismiss {
    [self setValue:@(YES) forKey:@"_dismissed"];
}

@end

//------------------------------------------------------------------------------------------

@implementation VisHUD {
    VisHUDView * _contentView;
}

static VisHUD * hud = nil;

///MARK: - Open

+ (void)show:(NSString *)text userInteraction:(BOOL)userInteractionEnabled afterDelay:(CGFloat)second {
    if ([VisHUD shareHUD]->_contentView) {
        [VisHUD dismiss];
    }
    [[VisHUD shareHUD] show:text userInteraction:userInteractionEnabled afterDelay:second];
}

+ (void)show:(NSString *)text afterDelay:(CGFloat)second {
    [self show:text userInteraction:NO afterDelay:second];
}

+ (void)show:(NSString *)text userInteraction:(BOOL)userInteractionEnabled {
    [self show:text userInteraction:userInteractionEnabled afterDelay:0];
}

+ (void)show:(NSString *)text {
    [self show:text userInteraction:NO afterDelay:0];
}

+ (void)show {
    [self show:nil userInteraction:NO afterDelay:0];
}

+ (void)dismiss {
    [[VisHUD shareHUD] dismiss];
}

///MARK: - Private

+ (instancetype)shareHUD {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [VisHUD new];
    });
    return hud;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.frame = [UIScreen mainScreen].bounds;
}

- (void)show:(NSString *)text userInteraction:(BOOL)userInteractionEnabled afterDelay:(CGFloat)second {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        self.userInteractionEnabled = userInteractionEnabled;
        
        _contentView = [VisHUDView new];
        [_contentView addObserver:self forKeyPath:@"_dismissed" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubview:_contentView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0]];

        SEL selector = NSSelectorFromString(@"show:afterDelay:");
        IMP imp = [_contentView methodForSelector:selector];
        void (*func)(id, SEL, NSString *, CGFloat) = (void *)imp;
        func(_contentView, selector, text, second);
        
    });
}

- (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_contentView removeObserver:self forKeyPath:@"_dismissed"];
        [_contentView removeFromSuperview];
        _contentView = nil;
        [self removeFromSuperview];        
    });
}

// kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:_contentView]) {
        if ([keyPath isEqualToString:@"_dismissed"]) {
            if ([change[@"new"] boolValue]) {
                [self dismiss];
            }
        }
    }
}

@end
