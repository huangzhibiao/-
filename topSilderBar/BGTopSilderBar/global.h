//
//  global.h
//  topSilderBar
//
//  Created by huangzhibiao on 16/7/7.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#define color(r,g,b,al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]
#define appTintColor color(0.0,162.0,154.0,1.0)
#define appBackgroundColor color(245.0,245.0,245.0,1.0)
#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width
#define BGFont(size) [UIFont systemFontOfSize:size]

@interface global : NSObject

/**
 适配各个屏幕尺寸宽 函数
 */
+(CGFloat)BGWidth:(CGFloat)width;
/**
 适配各个屏幕尺寸高 函数
 */
+(CGFloat)BGHeight:(CGFloat)height;
/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
@end
