//
//  BGTopSilderBarCell.m
//  topSilderBar
//
//  Created by huangzhibiao on 16/7/7.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import "BGTopSilderBarCell.h"
#import "global.h"

@interface BGTopSilderBarCell()

@property (weak, nonatomic) IBOutlet UILabel *BGTitle;


@end

@implementation BGTopSilderBarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setItem:(NSString *)item{
    _item = item;
    _BGTitle.text = item;
}

-(void)setTitleColor:(UIColor *)color{
    _BGTitle.textColor = color;
}

-(void)setBGTitleFont:(UIFont *)BGTitleFont{
    _BGTitleFont = BGTitleFont;
    _BGTitle.font = BGTitleFont;
}

-(void)setFontScale:(BOOL)scale{
    if (scale) {
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform tran = CGAffineTransformScale(_BGTitle.transform,1.3,1.3);
            [_BGTitle setTransform:tran];
        } completion:^(BOOL finished) {
            [_BGTitle setTransform:CGAffineTransformIdentity];
            _BGTitle.font = BGFont(19.5);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform tran = CGAffineTransformScale(_BGTitle.transform,0.7692,0.7692);
            [_BGTitle setTransform:tran];
        } completion:^(BOOL finished) {
            [_BGTitle setTransform:CGAffineTransformIdentity];
            _BGTitle.font = BGFont(15.0);
        }];
    }
}

@end
