//
//  myOrderCommonCellView.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/10.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "myOrderCommonCellView.h"
#import "global.h"

@interface myOrderCommonCellView()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topSubView;

@property (weak, nonatomic) IBOutlet UIImageView *icon_img;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UILabel *status_lab;
@property (weak, nonatomic) IBOutlet UILabel *descri_lab;
@property (weak, nonatomic) IBOutlet UILabel *price_lab;
@property (weak, nonatomic) IBOutlet UILabel *num_lab;

@end

@implementation myOrderCommonCellView


+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:@"myOrderCommonCell" owner:nil options:nil] firstObject];
}
-(void)awakeFromNib{
    
    [self setFra];//设置相关控件frame
    [self setLabFontSize];//设置相关字体大小
    }
/**
 设置相关控件frame
 */
-(void)setFra{
    self.topView.frame = CGRectMake(0, 0, screenW, [global pxTopt:180.0]);
    CGFloat MarginHor = [global pxTopt:25.0];
    CGFloat MarginVer = [global pxTopt:20.0];
    CGFloat icon_imgWH = [global pxTopt:140.0];
    self.icon_img.frame = CGRectMake(MarginHor, MarginVer, icon_imgWH, icon_imgWH);
    self.topSubView.frame = CGRectMake(CGRectGetMaxX(self.icon_img.frame)+MarginHor, MarginVer,screenW - icon_imgWH - MarginHor*2, icon_imgWH);
}
/**
 设置相关控件字体大小
 */
-(void)setLabFontSize{
    self.name_lab.font = font(30.0);
    self.status_lab.font = font(22.0);
    self.descri_lab.font = font(26.0);
    self.num_lab.font = font(26.0);
}
/**
  设置商品图标
 */
-(void)setIcon:(NSString *)icon{
    self.icon_img.image = [UIImage imageNamed:icon];
}
/**
 设置商品名称
 */
-(void)setName:(NSString *)name{
    CGSize size = [global sizeWithText:name font:font(30.0) maxSize:CGSizeMake(200, MAXFLOAT)];
    self.name_lab.frame = CGRectMake(0, 0, size.width, size.height);
    self.name_lab.text = name;
}

/**
 设置商品交易状态
 */
-(void)setStatus:(NSString *)status{
    CGSize size = [global sizeWithText:status font:font(22.0) maxSize:CGSizeMake(200, MAXFLOAT)];
    CGFloat Y = (self.name_lab.frame.size.height - size.height)*0.5;
    CGFloat X = self.topSubView.frame.size.width - size.width - [global pxTopt:25.0];
    self.status_lab.frame = CGRectMake(X, Y, size.width, size.height);
    self.status_lab.text = status;
}

/**
 设置商品详情
 */
-(void)setDescri:(NSString *)descri{
    descri = [NSString stringWithFormat:@"具体规格：%@",descri];
    CGSize size = [global sizeWithText:descri font:font(26.0) maxSize:CGSizeMake(200, MAXFLOAT)];
    CGFloat Y = CGRectGetMaxY(self.status_lab.frame) + [global pxTopt:20.0];
    self.descri_lab.frame = CGRectMake(0, Y, size.width, size.height);
    self.descri_lab.text = descri;
}

/**
 设置商品价格
 */
-(void)setPrice:(NSNumber *)price{
    NSString* pri = [NSString stringWithFormat:@"¥%.2f",[price floatValue]];//截取小数点后两位
    NSMutableAttributedString *str = [global setMutableStringSize:pri];
    CGSize size = [global sizeWithText:pri font:font(28.0) maxSize:CGSizeMake(200,MAXFLOAT)];
    CGFloat Y = self.topSubView.frame.size.height - size.height;
    self.price_lab.frame = CGRectMake(0, Y, size.width, size.height);
    self.price_lab.attributedText = str;
}

/**
 设置商品数量
 */
-(void)setNum:(NSNumber *)num{
    NSString* numStr = [NSString stringWithFormat:@"X%@",num];
    CGSize numStrSize = [global sizeWithText:numStr font:font(26.0) maxSize:CGSizeMake(200,MAXFLOAT)];
    CGFloat nX = self.topSubView.frame.size.width - numStrSize.width - [global pxTopt:25.0];
    CGFloat nY = self.topSubView.frame.size.height - numStrSize.height;
    self.num_lab.frame = CGRectMake(nX, nY, numStrSize.width, numStrSize.height);
    self.num_lab.text = numStr;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
