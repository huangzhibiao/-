//
//  BGTopSilderBarCell.h
//  topSilderBar
//
//  Created by huangzhibiao on 16/7/7.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGTopSilderBarCell : UICollectionViewCell

@property(nonatomic,copy)NSString* item;//分类标题文字
@property(nonatomic,strong)UIFont* BGTitleFont;//分类标题文字字体

-(void)setTitleColor:(UIColor*)color;//设置分类标题文字字体颜色
-(void)setFontScale:(BOOL)scale;//设置分类标题文字字体的缩放
@end
