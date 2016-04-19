//
//  BGHeaderView.m
//  BGJDRefresh
//
//  Created by huangzhibiao on 16/4/18.
//  Copyright © 2016年 JDRefresh. All rights reserved.
//

#import "BGHeaderView.h"

@interface BGHeaderView()

@end

@implementation BGHeaderView

-(void)awakeFromNib{
    
}

+(instancetype)view{
    return [[[NSBundle mainBundle] loadNibNamed:@"BGHeaderView" owner:nil options:nil] firstObject];
}

@end
