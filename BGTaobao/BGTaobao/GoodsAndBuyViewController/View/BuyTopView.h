//
//  BuyTopView.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/21.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGLRRefresh.h"

@interface BuyTopView : UIView
//@property (weak, nonatomic) IBOutlet UIImageView *icon_img;//产品图片=
@property (weak, nonatomic) BGLRRefresh* rightRefresh;
@property(nonatomic,strong)NSArray* images;
+ (instancetype)view;

@end
