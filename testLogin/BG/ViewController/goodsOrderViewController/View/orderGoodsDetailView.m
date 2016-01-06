//
//  orderGoodsDetailView.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/8.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "orderGoodsDetailView.h"
#import "global.h"
#import "UIImageView+WebCache.h"

@interface orderGoodsDetailView()

@property (weak, nonatomic) IBOutlet UIImageView *image_iv;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UILabel *descri_lab;
@property (weak, nonatomic) IBOutlet UILabel *price_lab;
@property (weak, nonatomic) IBOutlet UILabel *num_lab;


@end

@implementation orderGoodsDetailView

+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:@"orderGoodsDetail" owner:nil options:nil] firstObject];
}

-(void)setImage:(NSString *)image{
    [self.image_iv sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:nil];
}

-(void)setName:(NSString *)name{
    self.name_lab.text = name;
}

-(void)setDescri:(NSString *)descri{
    NSString* des = [NSString stringWithFormat:@"具体规格：%@",descri];
    self.descri_lab.text = des;
}

-(void)setPrice:(NSNumber *)price{
    NSString* pri = [NSString stringWithFormat:@"¥%.2f",[price floatValue]];//截取小数点后两位
    NSMutableAttributedString *str = [global setMutableStringSize:pri];
    self.price_lab.attributedText = str;
}

-(void)setNum:(NSNumber *)num{
    NSString* nu = [NSString stringWithFormat:@"x%@",num];
    self.num_lab.text = nu;
}

//- (void)awakeFromNib
//{
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
