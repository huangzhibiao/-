//
//  CollectionViewCell.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/7.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "CollectionViewCell.h"
#import "GoodsImgs.h"
#import "global.h"
#import "UIImageView+WebCache.h"

@interface CollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;


@end

@implementation CollectionViewCell


- (void)awakeFromNib {
    // Initialization code
    //self.autoresizingMask = UIViewAutoresizingNone;
    UIView* view = [[UIView alloc] init];
    view.frame = self.frame;
    view.backgroundColor = [UIColor grayColor];
    self.selectedBackgroundView = view;
}

-(void)setGoodsDetails:(GoodsDetails*) goodsDetails{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:goodsDetails.default_img_url] placeholderImage:nil];
    self.title.text = goodsDetails.title;
    self.price.text = [NSString stringWithFormat:@"%.1f",[goodsDetails.price floatValue]];
    self.market_price.text = [NSString stringWithFormat:@"%.1f",[goodsDetails.market_price floatValue]];
}


@end
