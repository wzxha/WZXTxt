//
//  TxtAnalyse.h
//  TxtReader
//
//  Created by WzxJiang on 16/11/7.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WZXTxtAnalyseDelegate <NSObject>

// 分析完毕
- (void)txtAnalyseDidAnalyse;

@end

@interface WZXTxtAnalyse : NSObject

@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, copy, readonly) NSString * name;
@property (nonatomic, strong) NSMutableArray * chapterNames;
@property (nonatomic, strong) NSMutableArray * chapters;
@property (nonatomic, weak) id <WZXTxtAnalyseDelegate> delegate;

// 初始化
- (instancetype)initWithBounds:(CGRect)bounds;

// 分析
- (void)contentWithName:(NSString *)name font:(UIFont *)font;


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
