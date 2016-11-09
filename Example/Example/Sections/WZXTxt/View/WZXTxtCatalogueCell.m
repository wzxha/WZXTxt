//
//  WZXTxtCatalogueCell.m
//  Example
//
//  Created by WzxJiang on 16/11/9.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXTxtCatalogueCell.h"

@implementation WZXTxtCatalogueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _chapterLabel = [UILabel new];
    _chapterLabel.font = BASE_FONT(12);
    [self.contentView addSubview:_chapterLabel];
    [_chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
