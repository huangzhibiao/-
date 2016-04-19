//
//  BGHeaderView.h
//  BGJDRefresh
//
//  Created by huangzhibiao on 16/4/18.
//  Copyright © 2016年 JDRefresh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *icon;//图片
@property (weak, nonatomic) IBOutlet UILabel *prompt;//动态提示文字

+(instancetype)view;

@end
