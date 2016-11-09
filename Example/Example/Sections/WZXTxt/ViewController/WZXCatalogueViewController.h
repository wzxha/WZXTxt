//
//  WZXCatalogueViewController.h
//  Example
//
//  Created by WzxJiang on 16/11/9.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZXCatalogueViewController : UIViewController

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy) NSArray * chapterNames;
@property (nonatomic, assign) NSUInteger currentChapterNum;


- (void)showCatalogue;
- (void)hideCatalogue;
@end
