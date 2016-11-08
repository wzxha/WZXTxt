//
//  TxtPageViewController.m
//  TxtReader
//
//  Created by WzxJiang on 16/11/7.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "TxtPageViewController.h"
#import "TxtViewController.h"
#import "TxtAnalyse.h"
#import "Masonry.h"

@interface TxtPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation TxtPageViewController {
    TxtAnalyse * _analyse;
    NSString   * _name;
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

//- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
//    if (!completed) {
//        TxtViewController * txtViewController = previousViewControllers.firstObject;
//        _txtViewController = txtViewController;
//        _currentPageNum = txtViewController.pageNum;
//        _currentChapterNum = txtViewController.chapterNum;
//        
//    } else{
//        
//    }
//}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSLog(@"之前章节: %lu, 之前pagenum: %lu", _currentChapterNum, _currentPageNum);
    
    TxtChapterModel * chapterModel = _analyse.chapters[_currentChapterNum];
    
    if (_currentChapterNum == _analyse.chapterNums) {
        TxtChapterModel * lastChapterModel = _analyse.chapters.lastObject;
        if (_currentPageNum == lastChapterModel.pageNum) {
            return nil;
        }
    }
    
    _currentPageNum ++;

    if (_currentPageNum >= chapterModel.pageNum) {
        _currentChapterNum ++;
        _currentPageNum = 0;
    }
    
    NSLog(@"现在章节: %lu, 之前pagenum: %lu", _currentChapterNum, _currentPageNum);
    return [self txtViewControllerWithPageNum:_currentPageNum chapterNum:_currentChapterNum];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSLog(@"之前章节: %lu, 之前pagenum: %lu", _currentChapterNum, _currentPageNum);
    
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
    
    NSLog(@"现在章节: %lu, 之前pagenum: %lu", _currentChapterNum, _currentPageNum);
    return [self txtViewControllerWithPageNum:_currentPageNum chapterNum:_currentChapterNum];
}

- (TxtViewController *)txtViewControllerWithPageNum:(NSUInteger)pageNum chapterNum:(NSUInteger)chapterNum {
    _txtViewController = [TxtViewController new];
    _txtViewController.textView.attributedText = [_analyse txtWithPageNum:_currentPageNum chapterNum:_currentChapterNum];
    _txtViewController.chapterLabel.text = _analyse.chapterNames[_currentChapterNum];
    _txtViewController.numLabel.text = [NSString stringWithFormat:@"%lu/%lu", [_analyse pageNumsWithChapterNum:_currentChapterNum pageNum:_currentPageNum], [_analyse allPageNums]];
    _txtViewController.pageNum = _currentPageNum;
    _txtViewController.chapterNum = _currentChapterNum;
    return _txtViewController;
}


@end
