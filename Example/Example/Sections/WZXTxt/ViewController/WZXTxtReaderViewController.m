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

@interface WZXTxtReaderViewController () <WZXTxtAnalyseDelegate, UITableViewDelegate>

@end

@implementation WZXTxtReaderViewController {
    BOOL _showNav;
    WZXTxtPageViewController * _txtPageViewController;
    WZXCatalogueViewController * _catalogueViewController;
    WZXTxtAnalyse * _analyse;
    NSString * _name;
}

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        _name = name;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapReaderAction:) name:@"WZXTapReaderNotification" object:nil];
    
    _analyse =
    [[WZXTxtAnalyse alloc] initWithBounds:
     CGRectMake(0, 0, self.view.frame.size.width - 20, self.view.frame.size.height - 100)];
    _analyse.delegate = self;
    [_analyse contentWithName:_name font:BASE_BODY_FONT];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    _topView.bounds     = CGRectMake(0, 0, self.view.frame.size.width, 64);
    _topView.center     = CGPointMake(self.view.center.x, -32);
    [self.view addSubview:_topView];
    
    _bottomView         = [WZXTxtReaderBottomView new];
    _bottomView.bounds  = CGRectMake(0, 0, self.view.frame.size.width, 44);
    _bottomView.center  = CGPointMake(self.view.center.x, self.view.frame.size.height + 22);
    [self.view addSubview:_bottomView];
    
    _catalogueViewController = [WZXCatalogueViewController new];
    _catalogueViewController.view.frame = CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    _catalogueViewController.chapterNames = _analyse.chapterNames;
    _catalogueViewController.tableView.delegate = self;
    _catalogueViewController.currentChapterNum = [bookRecord[@"chapter"] unsignedIntegerValue];
    [self addChildViewController:_catalogueViewController];
    [self.view addSubview:_catalogueViewController.view];
    
    [_bottomView.catalogueButton addTarget:_catalogueViewController action:@selector(showCatalogue) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapReaderAction:(NSNotification *)noti {
    NSInteger type = [noti.userInfo[@"type"] integerValue];
    if (type == 0) {
        // 点击
        [self setNavState:!_showNav];
    } else if (type == 1) {
        // 滑动
        [self setNavState:NO];
    }
}

- (void)setNavState:(BOOL)show {
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint topCenter = _topView.center;
        CGPoint bottomCenter = _bottomView.center;
        
        if (!show) {
            topCenter.y    = -32;
            bottomCenter.y = self.view.frame.size.height + 22;
        } else {
            topCenter.y    = 32;
            bottomCenter.y = self.view.frame.size.height - 22;
        }
        
        _topView.center    = topCenter;
        _bottomView.center = bottomCenter;
    } completion:^(BOOL finished) {
        _showNav = show;
    }];
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setNavState:NO];
    [_catalogueViewController hideCatalogue];
    [_txtPageViewController toPageWithChapterNum:indexPath.row pageNum:0];
}

- (void)txtAnalyseDidAnalyse {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createUI];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
