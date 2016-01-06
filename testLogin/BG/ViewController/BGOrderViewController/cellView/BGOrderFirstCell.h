//
//  BGOrderFirstCell.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/23.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGOrderFrame.h"

@protocol BGOrderFirstCellDelegate <NSObject>

@required
-(void)selectCell:(BGOrderFrame*)OrderFrame index:(NSInteger)index;
-(void)clickFirstBtn:(BGOrderFrame*)OrderFrame;
-(void)clickSecondBtn:(BGOrderFrame*)OrderFrame;

@end

@interface BGOrderFirstCell : UITableViewCell

@property(nonatomic,strong)BGOrderFrame* orderFrame;
@property (nonatomic, weak) id <BGOrderFirstCellDelegate> delegate;
+(instancetype)cellWithTableView:(UITableView*)tableView;
@end
