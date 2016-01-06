//
//  BGPayStyleViewCell.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/24.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "payStyleViewCellData.h"

@interface BGPayStyleViewCell : UITableViewCell

@property(nonatomic,strong)payStyleViewCellData* data;

+(instancetype)cellWithTableView:(UITableView*)tableView;

@end
