//
//  TxtAnalyse.h
//  TxtReader
//
//  Created by WzxJiang on 16/11/7.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZXTxtAnalyse : NSObject

@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, strong) NSMutableArray * chapterNames;
@property (nonatomic, strong) NSMutableArray * chapters;

- (instancetype)initWithTxtName:(NSString *)name
                           font:(UIFont *)font
                         bounds:(CGRect)bounds;

- (NSAttributedString *)txtWithPageNum:(NSUInteger)pageNum
                            chapterNum:(NSUInteger)chapterNum;

- (NSUInteger)chapterNums;
- (NSUInteger)allPageNums;
- (NSUInteger)pageNumsWithChapterNum:(NSUInteger)chapterNum
                             pageNum:(NSUInteger)pageNum;
@end

@interface TxtChapterModel : NSObject
@property (nonatomic, copy) NSArray * offsets;
@property (nonatomic, copy) NSAttributedString * attributedString;
@property (nonatomic, assign) NSUInteger pageNum;
@end

@interface TxtPageModel : NSObject

@property (nonatomic, copy) NSString * chapterName;
@property (nonatomic, copy) NSAttributedString * attributedString;
@property (nonatomic, assign) NSUInteger currentPageNum;
@property (nonatomic, assign) NSUInteger allPageNums;
@property (nonatomic, assign) NSUInteger pageNum;
@property (nonatomic, assign) NSUInteger chapterNum;

@end
