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
#import "WZXCatalogueViewController.h"
#import "WZXTxtAnalyse.h"
#import "VisHUD.h"
@interface WZXTxtReaderViewController () <WZXTxtAnalyseDelegate, UITableViewDelegate>

@end

@implementation WZXTxtReaderViewController {
    BOOL _showNav;
    WZXTxtPageViewController * _txtPageViewController;
    WZXCatalogueViewController * _catalogueViewController;
    WZXTxtAnalyse * _analyse;
    NSString * _name;
    NSString * _path;
}

- (instancetype)initWithName:(NSString *)name path:(NSString *)path {
    if (self = [super init]) {
        _name = name;
        _path = path;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapReaderAction:) name:@"WZXTapReaderNotification" object:nil];
    
    [VisHUD show:@"Waiting..."];
    
    _analyse =
    [[WZXTxtAnalyse alloc] initWithBounds: (CGRect){CGPointZero, BASE_TEXTVIEW_SIZE}];
    _analyse.delegate = self;
    [_analyse contentWithName:_name path:_path font:BASE_BODY_FONT];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelAlert;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)createUI {
    NSDictionary * bookRecord = [[NSUserDefaults standardUserDefaults] objectForKey:_name];
    
    _txtPageViewController = [[WZXTxtPageViewController alloc] initWithAnalyse:_analyse];
    [self addChildViewController:_txtPageViewController];
    [self.view addSubview:_txtPageViewController.view];
    _txtPageViewController.currentPageNum = [bookRecord[@"page"] unsignedIntegerValue];
    _txtPageViewController.currentChapterNum = [bookRecord[@"chapter"] unsignedIntegerValue];
    [_txtPageViewController install];
    
    _topView            = [WZXTxtReaderTopView new];
    _topView.frame     = CGRectMake(0, -64, self.view.frame.size.width, 64);
    [self.view addSubview:_topView];
    
    _bottomView         = [WZXTxtReaderBottomView new];
    _bottomView.frame  = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44 + 100);
    [self.view addSubview:_bottomView];
    
    _catalogueViewController = [WZXCatalogueViewController new];
    _catalogueViewController.view.frame = self.view.bounds;
    _catalogueViewController.chapterNames = _analyse.chapterNames;
    _catalogueViewController.tableView.delegate = self;
    _catalogueViewController.currentChapterNum = [bookRecord[@"chapter"] unsignedIntegerValue];
    [self addChildViewController:_catalogueViewController];
    [self.view addSubview:_catalogueViewController.view];
    
    [_topView.backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView.catalogueButton addTarget:_catalogueViewController action:@selector(showCatalogue) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView.chapterButton addTarget:self action:@selector(showChapter) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView.lightButton addTarget:self action:@selector(showLight) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView.chapterSlider addTarget:self action:@selector(changeScreenLight:) forControlEvents:UIControlEventValueChanged];
    [_bottomView.lightSlider addTarget:self action:@selector(changeScreenLight:) forControlEvents:UIControlEventValueChanged];
    
    [_bottomView.darkBackgroundButton addTarget:self action:@selector(changeThemeToDark:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)backToMain {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapReaderAction:(NSNotification *)noti {
    NSInteger type = [noti.userInfo[@"type"] integerValue];
    if (type == 0) {
        // 点击
        [self setNavState:!_showNav];
    } else if (type == 1) {
        // 滑动
        if (!_showNav) {
            return;
        }
        [self setNavState:NO];
    }
}

- (void)setNavState:(BOOL)show {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect topRect = _topView.frame;
        CGRect bottomRect = _bottomView.frame;
        
        if (!show) {
            topRect.origin.y    = -topRect.size.height;
            bottomRect.origin.y = self.view.frame.size.height;
        } else {
            topRect.origin.y    = 0;
            bottomRect.origin.y = self.view.frame.size.height - bottomRect.size.height;
        }
        
        _topView.frame    = topRect;
        _bottomView.frame = bottomRect;
        
        [UIApplication sharedApplication].keyWindow.windowLevel = show? UIWindowLevelNormal: UIWindowLevelAlert;
    } completion:^(BOOL finished) {
        _showNav = show;
        if (!_showNav) {
            [_bottomView hideBehindView];
        }
    }];
}

- (void)showChapter {
    [_bottomView showBehindView:0];
}

- (void)showLight {
    [_bottomView showBehindView:1];
}

- (void)changeScreenLight:(UISlider *)sender {
    [[UIScreen mainScreen] setBrightness: sender.value];
}

- (void)changeThemeToDark:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WZXChangeThemeNotification" object:nil userInfo:@{
        @"textColor":       [UIColor whiteColor],
        @"backgroundColor": [UIColor blackColor],
        @"assistColor":     [UIColor whiteColor],
        @"navColor":        [UIColor blackColor]}];
    
    _topView.backgroundColor = [UIColor blackColor];
    [_bottomView changeThemeColor:[UIColor blackColor]];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setNavState:NO];
    [_catalogueViewController hideCatalogue];
    [_txtPageViewController toPageWithChapterNum:indexPath.row pageNum:0];
}

#pragma mark - WZXTxtAnalyseDelegate
- (void)txtAnalyseDidAnalyse {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createUI];
        [VisHUD dismiss];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
