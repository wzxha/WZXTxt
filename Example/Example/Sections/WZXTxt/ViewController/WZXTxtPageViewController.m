//
//  TxtPageViewController.m
//  TxtReader
//
//  Created by WzxJiang on 16/11/7.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXTxtPageViewController.h"
#import "WZXTxtViewController.h"
#import "WZXTxtAnalyse.h"

@interface WZXTxtPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation WZXTxtPageViewController {
    WZXTxtAnalyse * _analyse;
    NSString   * _name;
    NSUInteger _chapterNumChange;
    NSUInteger _pageNumChange;
    WZXTxtViewController * _txtViewController;
}

- (instancetype)initWithAnalyse:(WZXTxtAnalyse *)analyse {
    NSDictionary *options =
    [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                forKey: UIPageViewControllerOptionSpineLocationKey];
    if (self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options]) {
        _analyse = analyse;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.delegate = self;
    self.dataSource = self;
}

- (void)install {
    [self setViewControllers:@[[self txtViewControllerWithPageNum:_currentPageNum chapterNum:_currentChapterNum]]
                   direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
                       
                   }];
}

- (void)toPageWithChapterNum:(NSUInteger)chapterNum pageNum:(NSUInteger)pageNum {
    _currentChapterNum = chapterNum;
    _currentPageNum = pageNum;
    [self install];
    
    [[NSUserDefaults standardUserDefaults]
     setObject:@{@"chapter": @(_currentChapterNum),
                 @"page": @(_currentPageNum)}
     forKey: [NSString stringWithFormat:@"%@", _analyse.name]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        _txtViewController = (WZXTxtViewController *)previousViewControllers.firstObject;
        
        _currentPageNum = _txtViewController.pageNum;
        
        _currentChapterNum = _txtViewController.chapterNum;
        
    } else {
        _currentPageNum = _pageNumChange;
        
        _currentChapterNum = _chapterNumChange;
        
        [[NSUserDefaults standardUserDefaults]
         setObject:@{@"chapter": @(_currentChapterNum),
                     @"page": @(_currentPageNum)}
         forKey: [NSString stringWithFormat:@"%@", _analyse.name]];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WZXTapReaderNotification" object:nil userInfo:@{@"type": @(1)}];
    
    WZXTxtViewController * txtVC = (WZXTxtViewController *)pendingViewControllers.firstObject;
    
    _chapterNumChange = txtVC.chapterNum;
    
    _pageNumChange    = txtVC.pageNum;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    TxtChapterModel * chapterModel = _analyse.chapters[_currentChapterNum];
    
    if (_currentChapterNum == _analyse.chapterNums - 1) {
        TxtChapterModel * lastChapterModel = _analyse.chapters.lastObject;
        if (_currentPageNum == lastChapterModel.pageNum - 1) {
            return nil;
        }
    }
    
    _currentPageNum ++;

    if (_currentPageNum >= chapterModel.pageNum) {
        _currentChapterNum ++;
        _currentPageNum = 0;
    }
    
    return [self txtViewControllerWithPageNum:_currentPageNum
                                   chapterNum:_currentChapterNum];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (_currentPageNum == 0) {
        if (_currentChapterNum == 0) {
            return nil;
        } else {
            _currentChapterNum --;
            TxtChapterModel * chapterModel = _analyse.chapters[_currentChapterNum];
            _currentPageNum = chapterModel.pageNum - 1;
        }
    } else {
        _currentPageNum --;
    }
    
    return [self txtViewControllerWithPageNum:_currentPageNum
                                   chapterNum:_currentChapterNum];
}

- (WZXTxtViewController *)txtViewControllerWithPageNum:(NSUInteger)pageNum chapterNum:(NSUInteger)chapterNum {
    _txtViewController = [WZXTxtViewController new];
    
    TxtPageModel * pageModel   = [TxtPageModel new];
    pageModel.currentPageNum   =
    [_analyse pageNumsWithChapterNum:_currentChapterNum pageNum:pageNum] + 1;
    
    pageModel.allPageNums      = [_analyse allPageNums] + 1;
    pageModel.pageNum          = pageNum;
    pageModel.chapterNum       = chapterNum;
    pageModel.chapterName      = _analyse.chapterNames[chapterNum];
    pageModel.attributedString =  [_analyse txtWithPageNum:pageNum chapterNum:chapterNum];

    _txtViewController.pageModel = pageModel;
    return _txtViewController;
}


@end