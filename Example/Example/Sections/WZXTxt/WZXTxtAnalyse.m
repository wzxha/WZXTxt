//
//  TxtAnalyse.m
//  TxtReader
//
//  Created by WzxJiang on 16/11/7.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXTxtAnalyse.h"
#import <CoreText/CTFramesetter.h>

@implementation WZXTxtAnalyse {
    NSUInteger _lastLocal;
    NSUInteger _allPageNums;
}

@synthesize name = _name;

- (instancetype)initWithBounds:(CGRect)bounds {
    if (self = [super init]) {
        _chapters = [NSMutableArray array];
        _chapterNames = [NSMutableArray array];
        _bounds = bounds;
    }
    return self;
}

- (NSString *)name {
    return _name;
}

- (void)contentWithName:(NSString *)name path:(NSString *)path font:(UIFont *)font {
    _name = name;
    dispatch_async(dispatch_queue_create("WZX_TXT_QUEUE", DISPATCH_QUEUE_SERIAL), ^{
        NSError * error;
        NSString * content = [NSString stringWithContentsOfFile:path encoding:0x80000632 error:&error];
        if (content == nil) {
            NSLog(@"%@", error);
        }
        
        NSMutableParagraphStyle * paragraph = [NSMutableParagraphStyle new];
        paragraph.alignment = NSTextAlignmentJustified;
//        paragraph.firstLineHeadIndent    = 20.0;
//        paragraph.paragraphSpacingBefore = 10.0;
        paragraph.lineSpacing = 3;
//        paragraph.hyphenationFactor=1.0;
        NSMutableAttributedString * attributedString =
        [[NSMutableAttributedString alloc] initWithString: content
                                               attributes:@{NSFontAttributeName: font,
                                                            NSParagraphStyleAttributeName : paragraph}];
        
        
        
        NSString * parten = @"第[0-9一二三四五六七八九十百千]*[章回].*";
        NSRegularExpression * reg =
        [NSRegularExpression regularExpressionWithPattern:parten
                                                  options:NSRegularExpressionCaseInsensitive
                                                    error:nil];
        [reg enumerateMatchesInString:attributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, attributedString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result.range.length > 0) {
                if (result.range.location > 0) {
                    if (_lastLocal == 0) {
                        [_chapterNames addObject: _name];
                    }
                    
                    [attributedString setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20]} range:result.range];
                    
                    TxtChapterModel * chapterModel = [TxtChapterModel new];
                    
                    chapterModel.attributedString =
                    [attributedString attributedSubstringFromRange:
                     NSMakeRange(_lastLocal, result.range.location - _lastLocal)];
                    
                    [self paginateWithChapterModel:chapterModel];
                    
                    [_chapters addObject:chapterModel];
                    
                    _lastLocal = result.range.location;
                }
                
                [_chapterNames addObject:
                 [attributedString attributedSubstringFromRange:NSMakeRange(result.range.location, result.range.length)].string];
            }
        }];
        
        [self.delegate txtAnalyseDidAnalyse];
    });
}


- (void)paginateWithChapterModel:(TxtChapterModel *)chapterModel {
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) chapterModel.attributedString);
    CGPathRef path = CGPathCreateWithRect(_bounds, NULL);
    
    NSInteger currentInnerOffset = 0;
    
    NSUInteger pageNums = 0;
    
    NSMutableArray * offsets = [NSMutableArray array];
    
    BOOL hasMorePages = YES;
    
    while (hasMorePages) {
        pageNums ++;
        
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
    
        [offsets addObject:[NSValue valueWithRange:NSMakeRange(range.location, range.length)]];
        
        if ((range.location + range.length) != chapterModel.attributedString.length) {
            currentInnerOffset += range.length;
        } else {
            hasMorePages = NO;
        }
        
        if (frame) {
            CFRelease(frame);
        }
    }
    
    chapterModel.pageNum = pageNums;
    chapterModel.offsets = [offsets copy];
}

- (NSAttributedString *)txtWithPageNum:(NSUInteger)pageNum chapterNum:(NSUInteger)chapterNum {
    TxtChapterModel * chapterModel = _chapters[chapterNum];
    NSValue * value = chapterModel.offsets[pageNum];
    NSRange range;
    [value getValue:&range];
    return [chapterModel.attributedString attributedSubstringFromRange:range];
}

- (NSUInteger)chapterNums {
    return _chapters.count;
}

- (NSUInteger)allPageNums {
    if (_allPageNums == 0) {
        _allPageNums = [self pageNumsWithChapterNum:_chapters.count pageNum:0];
    }
    return _allPageNums;
}

- (NSUInteger)pageNumsWithChapterNum:(NSUInteger)chapterNum pageNum:(NSUInteger)pageNum {
    NSUInteger nums = 0;
    for (int i = 0; i < chapterNum; i++) {
        TxtChapterModel * model = _chapters[i];
        nums += model.pageNum;
    }
    
    return nums+pageNum;
}

@end

@implementation TxtChapterModel

- (instancetype)init {
    if (self = [super init]) {
        _offsets = [NSMutableArray array];
    }
    return self;
}

@end

@implementation TxtPageModel



@end
