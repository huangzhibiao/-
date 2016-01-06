//
//  BGPayStyleViewCell.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/24.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BGPayStyleViewCell.h"
#import "BGPayStyleViewCellView.h"
#import "global.h"

@interface BGPayStyleViewCell()

@property(nonatomic,weak)BGPayStyleViewCellView* cellView;

@end

@implementation BGPayStyleViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        BGPayStyleViewCellView* view = [BGPayStyleViewCellView view];
        self.cellView = view;
        [self.contentView addSubview:view];
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView*)tableView {
    static NSString *ID = @"BGPayStyleViewCell";
    //优化cell，去缓存池中寻找是否有可用的cell
    BGPayStyleViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell ==nil){
        cell = [[BGPayStyleViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}


-(void)setData:(payStyleViewCellData *)data{
    _data = data;
    self.cellView.icon.image = [UIImage imageNamed:data.icon];
    self.cellView.title.text = data.title;
    self.cellView.descri.text = data.descri;
    self.cellView.selectImg.hidden = !data.selected;
    self.cellView.frame = CGRectMake(0, 0, screenW, 70.0);
}

@end
