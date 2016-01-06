//
//  BGPayStyleViewCellView.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/24.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BGPayStyleViewCellView.h"

@implementation BGPayStyleViewCellView

+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BGPayStyleViewCellView" owner:nil options:nil] firstObject];
}

@end
