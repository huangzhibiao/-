//
//  global.m
//  topSilderBar
//
//  Created by huangzhibiao on 16/7/7.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import "global.h"

@implementation global

/**
 适配各个屏幕尺寸宽函数
 */
+(CGFloat)BGWidth:(CGFloat)width{
    if(screenW == 320){//iphone4/5
        width = (320.0/375.0)*width;
    }else if(screenW == 375){//iphone6
        
    }else if (screenW == 414){//iphone6s
        width = (414.0/375.0)*width;
    }else;
    return width;
}
/**
 适配各个屏幕尺寸高函数
 */
+(CGFloat)BGHeight:(CGFloat)height{
    if (screenH == 568) {//iphone5
        height = (568.0/667.0)*height;
    }else if (screenH == 667){//iphone6
        
    }else if (screenH == 736) {//iphone6s
        height = (736.0/667.0)*height;
    }else if(screenH == 480){//iphone4s
        height = (480.0/667.0)*height;
    }else;
    return height;
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
