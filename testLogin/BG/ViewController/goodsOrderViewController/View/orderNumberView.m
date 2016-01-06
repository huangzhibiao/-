//
//  orderNumberView.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/9.
//  Copyright © 2015年 haiwang. All rights reserved.
//numberCopy orderNumber createTime

#import "orderNumberView.h"
#import "UICopyLabel.h"
#import "MBProgressHUD+MJ.h"
#import "global.h"

@interface orderNumberView()

@property (weak, nonatomic) IBOutlet UIButton *numberCopy;
@property (weak, nonatomic) IBOutlet UICopyLabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *createTime;

@end


@implementation orderNumberView

+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:@"orderNumber" owner:nil options:nil] firstObject];
}

-(void)awakeFromNib{
    self.numberCopy.layer.borderWidth = 1.0;
    self.numberCopy.layer.borderColor = color(220.0, 220.0, 220.0,1.0).CGColor;
    [self.numberCopy addTarget:self action:@selector(dealCopy:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)dealCopy:(id)sender{
    [self.orderNumber copy:sender];
    [MBProgressHUD showSuccess:@"复制成功"];
}

-(void)setOrderNum:(NSString *)orderNum{
    self.orderNumber.text = orderNum;
}

-(void)setCreatedTime:(NSString *)createdTime{
    self.createTime.text = createdTime;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
