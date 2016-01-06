//
//  BGPayStyleViewCellView.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/24.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGPayStyleViewCellView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *descri;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;

+ (instancetype)view;
@end
