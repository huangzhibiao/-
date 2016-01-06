//
//  myOrderTBCCell.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/10.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "myOrderTBCCell.h"

@implementation myOrderTBCCell

- (void)awakeFromNib {
    // Initialization code
}

-(NSArray *)CommonViews{
    if (_CommonViews == nil) {
        _CommonViews = [[NSMutableArray alloc] init];
    }
    return _CommonViews;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        for(int i=0;i<3;i++){
//            myOrderCommonCellView* CommonView = [myOrderCommonCellView view];
//            self.contentView.backgroundColor = color(220.0, 220.0, 220.0, 1.0);
//            [self.CommonViews addObject:CommonView];
//            [self.contentView addSubview:CommonView];
//        }
        self.contentView.backgroundColor = color(239.0, 239.0, 239.0, 1.0);
    }
    return self;
}
-(void)setData:(MyOrderModel *)data{
    _data = data;
}
/**
 设置顶部公共的那一栏viewop
 */
-(void)setCellViewFrame{
    [self.CommonViews removeAllObjects];
    for(UIView* view in self.contentView.subviews){
        [view removeFromSuperview];
    }
    for (int i=0;self.data.item.count;i++) {
        
        myOrderCommonCellView* CommonView = [myOrderCommonCellView view];
        self.contentView.backgroundColor = color(220.0, 220.0, 220.0, 1.0);
        [self.CommonViews addObject:CommonView];
        [self.contentView addSubview:CommonView];
        CGFloat Y = [global pxTopt:181.0]*i;
        if (i>0) {
            Y+=[global pxTopt:1.0]*i;
        }
        CommonView.frame = CGRectMake(0, Y, screenW, [global pxTopt:181.0]);
    }
    
        //self.CommonView.frame = CGRectMake(0, 0, screenW, [global pxTopt:181.0]);
}
/**
 拦截设置frame
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += [global pxTopt:10.0];
    //frame.origin.x = 5;
    //frame.size.width -= 2 * 5;
    frame.size.height -= [global pxTopt:10.0];
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
