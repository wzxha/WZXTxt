//
//  TxtViewController.m
//  TxtReader
//
//  Created by WzxJiang on 16/11/7.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXTxtViewController.h"
#import "WZXTxtAnalyse.h"

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
        if (_pageModel.pageNum == 0) {
            make.height.equalTo(@(0));
        } else {
            make.height.lessThanOrEqualTo(@(15));
        }
    }];
    
    _textView = [UITextView new];
    [self.view addSubview:self.textView];
    
    _textView.backgroundColor = [UIColor clearColor];
    
    [_textView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReaderAction:)]];
    
    _textView.editable       = NO;
//    _textView.scrollEnabled  = NO;
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_chapterLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(BASE_TEXTVIEW_SIZE);
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:@"WZXChangeThemeNotification" object:nil];
}

- (void)changeTheme:(NSNotification *)noti {
    _theme.textColor = noti.userInfo[@"textColor"];
    _theme.backgroundColor = noti.userInfo[@"backgroundColor"];
    [self updateTheme];
}

- (void)updateTheme {
    self.view.backgroundColor   = _theme.backgroundColor;
    self.textView.textColor     = _theme.textColor;
    self.numLabel.textColor     = _theme.assistColor;
    self.chapterLabel.textColor = _theme.assistColor;
}

- (void)tapReaderAction:(UITapGestureRecognizer *)sender {
    CGPoint pt = [sender locationInView:self.view];
    [self judgeClickPoint:pt];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInView:self.view];
    [self judgeClickPoint:pt];
}

- (void)judgeClickPoint:(CGPoint)pt {
    if (pt.x < 100) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WZXTapReaderNotification" object:nil userInfo:@{@"type": @(1)}];
        [self.delegate txtViewControllerClickLeft];
    } else if (pt.x > self.view.frame.size.width - 100){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WZXTapReaderNotification" object:nil userInfo:@{@"type": @(1)}];
        [self.delegate txtViewControllerClickRight];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WZXTapReaderNotification" object:nil userInfo:@{@"type": @(0)}];
    }
}


- (void)setPageModel:(TxtPageModel *)pageModel {
    _pageModel = pageModel;
    
    [self setUp];
    
    _chapterLabel.text       = _pageModel.chapterName;
    
    _textView.attributedText = _pageModel.attributedString;

    _numLabel.text           =
    [NSString stringWithFormat:@"%lu/%lu", _pageModel.currentPageNum, _pageModel.allPageNums];
    
    [self updateTheme];
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
