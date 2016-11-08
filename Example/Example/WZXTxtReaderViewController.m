//
//  ViewController.m
//  TxtReader
//
//  Created by WzxJiang on 16/11/7.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXTxtReaderViewController.h"
#import "WZXTxtPageViewController.h"
#import "WZXTxtReaderBottomView.h"
#import "WZXTxtReaderTopView.h"

@interface WZXTxtReaderViewController ()

@end

@implementation WZXTxtReaderViewController {
    BOOL _isShowNav;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNavState) name:@"WZXTxtChangeNavNotification" object:nil];
    [self changeStateTool];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self createUI];
}

- (void)createUI {
    WZXTxtPageViewController * txtPageVC = [[WZXTxtPageViewController alloc] initWithName:@"mdjyml"];
    [self addChildViewController:txtPageVC];
    txtPageVC.view.frame = self.view.bounds;
    [self.view addSubview:txtPageVC.view];
    
    _topView = [WZXTxtReaderTopView new];
    _topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _topView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 64);
    _topView.center = CGPointMake(self.view.center.x, -32);
    [self.view addSubview:_topView];
    
    _bottomView = [WZXTxtReaderBottomView new];
    _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _bottomView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 44);
    _bottomView.center = CGPointMake(self.view.center.x, self.view.frame.size.height + 22);
    [self.view addSubview:_bottomView];
}

- (void)changeStateTool {
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (void)changeNavState {
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint topCenter = _topView.center;
        CGPoint bottomCenter = _bottomView.center;
        
        if (_isShowNav) {
            topCenter.y = -32;
            bottomCenter.y = self.view.frame.size.height + 22;
        } else {
            topCenter.y = 32;
            bottomCenter.y = self.view.frame.size.height - 22;
        }
        
        _topView.center = topCenter;
        _bottomView.center = bottomCenter;
    } completion:^(BOOL finished) {
        _isShowNav = !_isShowNav;
        [self changeStateTool];
    }];
}

- (BOOL)prefersStatusBarHidden {
    return !_isShowNav;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
