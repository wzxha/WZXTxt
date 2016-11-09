//
//  TxtViewController.m
//  TxtReader
//
//  Created by WzxJiang on 16/11/7.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXTxtViewController.h"
#import "WZXTxtAnalyse.h"
#import "Masonry.h"

@interface WZXTxtViewController ()

@end

@implementation WZXTxtViewController 

- (void)setUp {
    _chapterLabel = [UILabel new];
    [self.view addSubview:_chapterLabel];
    
    _chapterLabel.font      = [UIFont systemFontOfSize:10];
    _chapterLabel.textColor = [UIColor grayColor];
    [_chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view).offset(10);
        make.height.equalTo(@(_pageModel.pageNum == 0 ? 0: 8));
    }];
    
    _textView = [UITextView new];
    [self.view addSubview:self.textView];
    
//    [_textView addGestureRecognizer:
//     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendChangeNavStateNoti)]];
    
    _textView.editable       = NO;
    _textView.scrollEnabled  = NO;
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_chapterLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    _numLabel = [UILabel new];
    [self.view addSubview:_numLabel];
    
    _numLabel.font      = [UIFont systemFontOfSize:10];
    _numLabel.textColor = [UIColor grayColor];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-5);
        make.right.equalTo(self.view).offset(-10);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setPageModel:(TxtPageModel *)pageModel {
    _pageModel = pageModel;
    
    [self setUp];
    
    _chapterLabel.text       = _pageModel.chapterName;
    
    _textView.attributedText = _pageModel.attributedString;

    _numLabel.text           =
    [NSString stringWithFormat:@"%lu/%lu", _pageModel.currentPageNum, _pageModel.allPageNums];
}

- (NSUInteger)pageNum {
    return _pageModel.pageNum;
}

- (NSUInteger)chapterNum {
    return _pageModel.chapterNum;
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
