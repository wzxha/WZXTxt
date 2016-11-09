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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    _backgroundControl = [UIControl new];
    [self.view addSubview:_backgroundControl];
    
    _backgroundControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _backgroundControl.alpha = 0;
    [_backgroundControl addTarget:self action:@selector(hideCatalogue) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView * contentView = [UIView new];
    [self.view addSubview:contentView];

    contentView.backgroundColor = [UIColor whiteColor];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(@(250));
        make.bottom.equalTo(self.view);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame: CGRectZero];
    [contentView addSubview:_tableView];

    _tableView.dataSource = self;
    [_tableView registerClass:[WZXTxtCatalogueCell class] forCellReuseIdentifier:@"WZXTxtCatalogueCell"];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(20);
        make.left.equalTo(contentView).offset(5);
        make.right.equalTo(contentView).offset(-5);
        make.bottom.equalTo(contentView);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZXTxtCatalogueCell * cell =
    [tableView dequeueReusableCellWithIdentifier:@"WZXTxtCatalogueCell"];
    cell.chapterLabel.text = _chapterNames[indexPath.row];
    return cell;
}

- (void)setChapterNames:(NSArray *)chapterNames {
    _chapterNames = chapterNames;
    [_tableView reloadData];
}

- (void)setCurrentChapterNum:(NSUInteger)currentChapterNum {
    _currentChapterNum = currentChapterNum;
    if (_currentChapterNum == 0) return;
    
    [_tableView scrollToRowAtIndexPath:
     [NSIndexPath indexPathForRow:currentChapterNum inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _chapterNames.count;
}

- (void)showCatalogue {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.x = 0;
        self.view.frame = rect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _backgroundControl.alpha = 1;
        }];
    }];
}

- (void)hideCatalogue {
    [UIView animateWithDuration:0.2 animations:^{
        _backgroundControl.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.view.frame;
            rect.origin.x = -[UIScreen mainScreen].bounds.size.width;
            self.view.frame = rect;
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
