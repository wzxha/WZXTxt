//
//  MainViewController.m
//  Example
//
//  Created by WzxJiang on 16/11/9.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "MainViewController.h"
#import "WZXNavigationView.h"
#import "WZXTxtReaderViewController.h"
@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MainViewController {
    UITableView * _tableView;
    NSMutableArray * _books;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUp];
    [self createUI];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)setUp {
    _books = [NSMutableArray array];
    [_books addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"txt" inDirectory:@""]];
    [_books addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"epub" inDirectory:@""]];
}

- (void)createUI {
    WZXNavigationView * topView = [WZXNavigationView new];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(64));
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MainCell"];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(65);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * path = _books[indexPath.row];
    NSString * name = [[path componentsSeparatedByString:@"/"].lastObject componentsSeparatedByString:@"."].firstObject;
    [self.navigationController pushViewController:[[WZXTxtReaderViewController alloc] initWithName:name path:path] animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [_books[indexPath.row] componentsSeparatedByString:@"/"].lastObject;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _books.count;
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
