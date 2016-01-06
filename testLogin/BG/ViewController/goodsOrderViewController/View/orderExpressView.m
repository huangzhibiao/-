//
//  orderExpressView.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/9.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "orderExpressView.h"
#import "global.h"

@interface orderExpressView()

@property (weak, nonatomic) IBOutlet UILabel *expressStyle;//配送类型
@property (weak, nonatomic) IBOutlet UILabel *expressCost;//运费
@property (weak, nonatomic) IBOutlet UILabel *preferential;//优惠价格
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;//订单总价


@end

@implementation orderExpressView

+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:@"orderExpress" owner:nil options:nil] firstObject];
}

-(void)setStyle:(NSString *)style{
    self.expressStyle.text = style;
}

-(void)setCost:(NSNumber *)cost{
    NSString* cos = [NSString stringWithFormat:@"¥%.2f",[cost floatValue]];//截取小数点后两位
    self.expressCost.text = cos;
}

-(void)setPreferent:(NSNumber *)preferent{
    NSString* pre = [NSString stringWithFormat:@"-¥%.2f",[preferent floatValue]];//截取小数点后两位
    self.preferential.text = pre;
}

-(void)setPrice:(NSNumber *)price{
    NSString* pri = [NSString stringWithFormat:@"¥%.2f",[price floatValue]];//截取小数点后两位
    NSMutableAttributedString *str = [global setMutableStringSize:pri];
    self.orderPrice.attributedText = str;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
