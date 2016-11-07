//
//  TxtPageViewController.h
//  TxtReader
//
//  Created by WzxJiang on 16/11/7.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TxtPageViewController : UIPageViewController

@property (nonatomic, assign) NSUInteger currentChapterNum;
@property (nonatomic, assign) NSUInteger currentPageNum;

- (instancetype)initWithName:(NSString *)name;

@end
