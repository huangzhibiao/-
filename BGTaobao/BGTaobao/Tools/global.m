//
//  global.m
//  BGTaobao
//
//  Created by huangzhibiao on 16/1/7.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import "global.h"

@implementation global

/**
 从像素px转换为ios的点阵pt
 */
+(CGFloat)pxTopt:(CGFloat)px{
    CGFloat standardPt = px/2.0;
    if (iphone5) {
        standardPt = (iphone5W/iphone6W)*standardPt;
    }else if(iphone6){
        
    }else if(iphone6plus){
        standardPt = (iphone6plusW/iphone6W)*standardPt;
    }else;
    return standardPt;
}

/**
 UIColor 转UIImage
 */
+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
