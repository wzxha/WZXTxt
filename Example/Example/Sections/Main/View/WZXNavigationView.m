//
//  WZXNavigationView.m
//  Example
//
//  Created by WzxJiang on 16/11/10.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXNavigationView.h"

@implementation WZXNavigationView

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor     = [UIColor whiteColor];
    self.layer.shadowColor   = [UIColor grayColor].CGColor;
    self.layer.shadowOffset  = CGSizeMake(0.5, 0.5);
    self.layer.shadowRadius  = 0.5;
    self.layer.shadowOpacity = 0.8;
}

@end
