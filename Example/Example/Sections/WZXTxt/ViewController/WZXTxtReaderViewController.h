//
//  ViewController.h
//  Example
//
//  Created by WzxJiang on 16/11/8.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZXTxtReaderTopView;
@class WZXTxtReaderBottomView;

@interface WZXTxtReaderViewController : UIViewController

@property (nonatomic, strong) WZXTxtReaderTopView    * topView;
@property (nonatomic, strong) WZXTxtReaderBottomView * bottomView;

- (instancetype)initWithName:(NSString *)name path:(NSString *)path;
@end

