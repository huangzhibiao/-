//
//  NaviBase.h
//  BGTaobao
//
//  Created by huangzhibiao on 16/1/7.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NaviBaseDelegate <NSObject>
-(void)NaviPopGes:(UIScreenEdgePanGestureRecognizer*)ges;
@end

@interface NaviBase : UINavigationController

@property(nonatomic,assign)id<NaviBaseDelegate> NaviPopDelegate;

@end
