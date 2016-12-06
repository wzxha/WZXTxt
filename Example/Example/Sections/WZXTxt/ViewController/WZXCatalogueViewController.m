//
//  WZXCatalogueViewController.m
//  Example
//
//  Created by WzxJiang on 16/11/9.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXCatalogueViewController.h"
#import "WZXTxtCatalogueCell.h"

@interface WZXCatalogueViewController () <UITableViewDataSource>

@end

@implementation WZXCatalogueViewController {
    UIControl * _backgroundControl;
    UIView * _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.view.alpha = 0;
    
    _backgroundControl = [UIControl new];
    [self.view addSubview:_backgroundControl];
    
    _backgroundControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [_backgroundControl addTarget:self action:@selector(hideCatalogue) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _contentView = [UIView new];
    [self.view addSubview:_contentView];

    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.frame = CGRectMake(-self.view.frame.size.width - 100, 0, self.view.frame.size.width - 100, self.view.frame.size.height);
    
    _tableView = [[UITableView alloc] initWithFrame: CGRectZero];
    [_contentView addSubview:_tableView];

    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5);
    [_tableView registerClass:[WZXTxtCatalogueCell class] forCellReuseIdentifier:@"WZXTxtCatalogueCell"];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(20);
        make.left.equalTo(_contentView).offset(5);
        make.right.equalTo(_contentView).offset(-5);
        make.bottom.equalTo(_contentView);
    }];
}

- (void)setChapterNames:(NSArray *)chapterNames {
    _chapterNames = chapterNames;
    [_tableView reloadData];
}

// 滑动到当前章节
- (void)setCurrentChapterNum:(NSUInteger)currentChapterNum {
    _currentChapterNum = currentChapterNum;
    if (_currentChapterNum == 0) return;
    
    [_tableView scrollToRowAtIndexPath:
     [NSIndexPath indexPathForRow:currentChapterNum inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

#pragma mark - Actions

- (void)showCatalogue {
    self.view.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _contentView.frame;
        rect.origin.x = 0;
        _contentView.frame = rect;
        _backgroundControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }];
}

- (void)hideCatalogue {
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        CGRect rect = _contentView.frame;
        rect.origin.x = -rect.size.width;
        _contentView.frame = rect;
    } completion:^(BOOL finished) {
        self.view.alpha = 0;
    }];
}

#pragma mark - UITableViewDataSource 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZXTxtCatalogueCell * cell =
    [tableView dequeueReusableCellWithIdentifier:@"WZXTxtCatalogueCell"];
    cell.chapterLabel.text = _chapterNames[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _chapterNames.count;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
