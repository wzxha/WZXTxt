//
//  TxtViewController.m
//  TxtReader
//
//  Created by WzxJiang on 16/11/7.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "TxtViewController.h"
#import "Masonry.h"

@interface TxtViewController ()

@end

@implementation TxtViewController 

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _chapterLabel = [UILabel new];
    _chapterLabel.font = [UIFont systemFontOfSize:10];
    _chapterLabel.textColor = [UIColor grayColor];
    [self.view addSubview:_chapterLabel];
    [_chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.height.equalTo(@(8));
    }];
    
    _textView = [UITextView new];
    [self.view addSubview:self.textView];
    _textView.editable = NO;
    _textView.scrollEnabled = NO;
    _textView.font = [UIFont systemFontOfSize:13];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_chapterLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    _numLabel = [UILabel new];
    _numLabel.font = [UIFont systemFontOfSize:10];
    _numLabel.textColor = [UIColor grayColor];
    [self.view addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-5);
        make.right.equalTo(self.view).offset(-10);
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
