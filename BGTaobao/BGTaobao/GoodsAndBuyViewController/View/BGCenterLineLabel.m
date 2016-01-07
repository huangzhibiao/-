//
//  BGCenterLineLabel.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/7.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BGCenterLineLabel.h"

@implementation BGCenterLineLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];    
    UIRectFill(CGRectMake(0, rect.size.height * 0.5, rect.size.width, 1));
}

@end
