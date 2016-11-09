//
//  TxtPageViewController.h
//  TxtReader
//
//  Created by WzxJiang on 16/11/7.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZXTxtAnalyse;

@interface WZXTxtPageViewController : UIPageViewController

@property (nonatomic, assign) NSUInteger currentChapterNum;
@property (nonatomic, assign) NSUInteger currentPageNum;

- (instancetype)initWithAnalyse:(WZXTxtAnalyse *)analyse;

- (void)toPageWithChapterNum:(NSUInteger)chapterNum pageNum:(NSUInteger)pageNum;

- (void)install;
@end

