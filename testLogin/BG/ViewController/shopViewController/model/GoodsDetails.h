//
//  GoodsDetails.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/4.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoodsDetails : NSObject

//@property(nonatomic,copy)NSString* delist_time;//1970-01-01 08:00:00;
//@property(nonatomic,copy)NSString* modified;//2015-11-24 10:23:47
@property(nonatomic,copy)NSString* input_str;// 海王牌芦荟软胶囊 500mg/粒*120粒;杭州海王生物工程有限公司;杭州市余杭区乔莫西路183号海王工业园;通便;每100g含：芦荟苷 2.4g;全叶芦荟烘干粉、大豆油、蜂蜡、明胶、水、甘油、二氧;便秘者;少年儿童、孕产妇、乳母及慢性腹泻者;每日1次，每次2粒; 500mg/粒*120粒;730天;密封，避光，置阴凉（20℃以下）干燥处;本品不能代替药物；食用本品后如出现腹泻者，请立即停;国食健字G20110227
@property(nonatomic,strong)NSNumber* weight;// = 60.000
@property(nonatomic,copy)NSString* title;//海王芦荟软胶囊500mg/粒*120粒
@property(nonatomic,strong)NSNumber* shop_cids;// = 59
@property(nonatomic,strong)NSNumber* market_price;// = 255.000
//@property(nonatomic,strong)NSNumber* score;// =
//@property(nonatomic,strong)NSNumber* bn;// = 8073722
//@property(nonatomic,copy)NSString marketable;// = true
//@property(nonatomic,strong)NSNumber* brand_id;// = 15
@property(nonatomic,copy)NSString* item_imgs;
@property(nonatomic,copy)NSString* default_img_url;
@property(nonatomic,strong)NSNumber* num;
@property(nonatomic,copy)NSString* unit;//瓶
@property(nonatomic,copy)NSString* skus;//产品相关信息
@property(nonatomic,strong)NSNumber* price;// = 49.000
@property(nonatomic,strong)NSNumber* iid;
@property(nonatomic,copy)NSString* created;
@property(nonatomic,copy)NSString* descriptions;//xml格式的描述，需解析,不能用description

@end
