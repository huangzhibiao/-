//
//  UICopyLabel.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/9.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "UICopyLabel.h"

@implementation UICopyLabel

//为了能接收到事件（能成为第一响应者），我们需要覆盖一个方法：

-(BOOL)canBecomeFirstResponder

{
    return YES;
}
// 可以响应的方法

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    return (action == @selector(copy:));
}

//针对于响应方法的实现

-(void)copy:(id)sender

{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
