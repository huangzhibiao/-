//
//  BGOrderSecondCellItemView.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/23.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGOrderSecondCellItemView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *descri;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *num;

+ (instancetype)view;
@end
