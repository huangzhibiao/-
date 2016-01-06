//
//  orderAdressView.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/8.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "orderAdressView.h"

@interface orderAdressView()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *telphone;
@property (weak, nonatomic) IBOutlet UILabel *address;


@end

@implementation orderAdressView

+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:@"orderAdress" owner:nil options:nil] firstObject];
}

-(void)setReceiveName:(NSString*) receiveName{
    self.name.text = [NSString stringWithFormat:@"收货人：%@",receiveName];
}

-(void)setTelphoneNumber:(NSString*) telphoneNumber{
    self.telphone.text = [NSString stringWithFormat:@"%@",telphoneNumber];
}

-(void)setReceiveAddress:(NSString*) receiveAddress{
    self.address.text = [NSString stringWithFormat:@"收货地址：%@",receiveAddress];
}
//- (void)awakeFromNib
//{
//    self.autoresizingMask = UIViewAutoresizingNone;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
