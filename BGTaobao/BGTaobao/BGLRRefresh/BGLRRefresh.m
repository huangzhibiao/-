//
//  BGLRRefresh.m
//  BGTaobao
//
//  Created by huangzhibiao on 16/2/22.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import "BGLRRefresh.h"
#import "global.h"

#define BGLRRefreshViewW 75
#define BGLRRefreshViewH 277

@interface BGLRRefresh()

@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;
@property (weak, nonatomic) IBOutlet UILabel *arrowText;
@property (assign, nonatomic) CGFloat SizeWidth;


@end

@implementation BGLRRefresh

-(void)awakeFromNib{
    
}

+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BGLRRefresh" owner:nil options:nil] firstObject];
}

-(void)setScrollview:(UIScrollView *)scrollview{
    _scrollview = scrollview;
    _scrollViewInitInset = scrollview.contentInset;
    // 监听contentOffset
    [scrollview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollview addSubview:self];
}

-(void)contentWidth:(CGFloat)width{
    self.SizeWidth = width-screenW;
    self.frame = CGRectMake(width,0, BGLRRefreshViewW,BGLRRefreshViewH);
}

/**
 释放函数
 */
-(void)free{
    // 移除之前的监听器
    [self.scrollview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [self removeFromSuperview];//从父控件中移除
}

#pragma mark 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (![@"contentOffset" isEqualToString:keyPath])return;
    if (self.scrollview.contentOffset.x > (self.SizeWidth+BGLRRefreshViewW)) {
            [UIView animateWithDuration:0.5 animations:^{
                CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
                [self.arrowIcon setTransform:transform];
            } completion:^(BOOL finished) {
                self.arrowText.text = @"松开查看图文详情";
            }];
        if(!self.scrollview.isDragging){
            if (!self.refreshing){
                self.refreshing = true;
                if (self.block) {
                    self.block();
                    NSLog(@"跳转控制器......");
                }
            }
        }
    }else{
        [UIView animateWithDuration:0.5 animations:^{
           [self.arrowIcon setTransform:CGAffineTransformIdentity];
        } completion:^(BOOL finished) {
            self.arrowText.text = @"滑动查看图文详情";
            self.refreshing = false;
        }];
    }
    //NSLog(@"x = %f   %f",self.scrollview.contentOffset.x,self.SizeWidth);
    
}


@end
