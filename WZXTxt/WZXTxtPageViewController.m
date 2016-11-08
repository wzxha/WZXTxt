//
//  TxtPageViewController.m
//  TxtReader
//
//  Created by WzxJiang on 16/11/7.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXTxtPageViewController.h"
#import "TxtViewController.h"
#import "TxtAnalyse.h"
#import "Masonry.h"

@interface WZXTxtPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation WZXTxtPageViewController {
    TxtAnalyse * _analyse;
    NSString   * _name;
    NSUInteger _chapterNumChange;
    NSUInteger _pageNumChange;
    TxtViewController * _txtViewController;
}

- (instancetype)initWithName:(NSString *)name {
    NSDictionary *options =
    [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                forKey: UIPageViewControllerOptionSpineLocationKey];
    if (self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options]) {
        _name = name;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.delegate = self;
    self.dataSource = self;
    
    _analyse = [[TxtAnalyse alloc] initWithTxtName:_name font:[UIFont systemFontOfSize:13] bounds:CGRectMake(0, 0, self.view.frame.size.width - 20, self.view.frame.size.height - 120)];
    
    [self setViewControllers:@[[self txtViewControllerWithPageNum:_currentPageNum chapterNum:_currentChapterNum]]
                   direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
    }];
    
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
        _txtViewController = (TxtViewController *)previousViewControllers.firstObject;
        _currentPageNum = _txtViewController.pageNum;
        _currentChapterNum = _txtViewController.chapterNum;
    } else {
        _currentPageNum = _pageNumChange;
        _currentChapterNum = _chapterNumChange;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    TxtViewController * txtVC = (TxtViewController *)pendingViewControllers.firstObject;
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
    
    return [self txtViewControllerWithPageNum:_currentPageNum chapterNum:_currentChapterNum];
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
    
    return [self txtViewControllerWithPageNum:_currentPageNum chapterNum:_currentChapterNum];
}

- (TxtViewController *)txtViewControllerWithPageNum:(NSUInteger)pageNum chapterNum:(NSUInteger)chapterNum {
    _txtViewController = [TxtViewController new];
    _txtViewController.textView.attributedText = [_analyse txtWithPageNum:pageNum chapterNum:chapterNum];
    _txtViewController.chapterLabel.text = _analyse.chapterNames[chapterNum];
    _txtViewController.numLabel.text = [NSString stringWithFormat:@"%lu/%lu", [_analyse pageNumsWithChapterNum:_currentChapterNum pageNum:pageNum] + 1, [_analyse allPageNums] + 1];
    _txtViewController.pageNum = pageNum;
    _txtViewController.chapterNum = chapterNum;
    return _txtViewController;
}


@end
