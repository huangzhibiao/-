//
//  MemberInfo.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/8.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberInfo : NSObject

@property(nonatomic,copy)NSString* advance;
@property(nonatomic,copy)NSString* email;
@property(nonatomic,copy)NSString* levelname;
@property(nonatomic,strong)NSNumber* member_id;
@property(nonatomic,strong)NSNumber* member_lv;
@property(nonatomic,strong)NSNumber* point;
@property(nonatomic,copy)NSString* sex;
@property(nonatomic,copy)NSString* uname;
@property(nonatomic,strong)NSNumber* usage_point;

@end
