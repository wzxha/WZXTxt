//
//  WZXConfig.h
//  Example
//
//  Created by WzxJiang on 16/11/9.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#ifndef WZXConfig_h
#define WZXConfig_h

#define BASE_FONT(float) [UIFont fontWithName:@"Heiti SC" size:float]
#define BASE_BOLD_FONT(float) [UIFont fontWithName:@"Heiti SC-Bold" size:float]
#define BASE_BODY_FONT BASE_FONT(13)

#define BASE_TEXTVIEW_SIZE CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - 60)

#endif /* WZXConfig_h */
