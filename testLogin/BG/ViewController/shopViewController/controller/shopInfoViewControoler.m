//
//  shopInfoViewControoler.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/4.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "shopInfoViewControoler.h"
#import "BGAFN.h"
#import "global.h"
#import "NSString+Md5SignString.h"
#import "GoodsDetails.h"
#import "CollectionViewCell.h"
#import "goodsDetailViewController.h"


@interface shopInfoViewControoler ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)BGAFN* BGAFNet;

@property(nonatomic,strong)NSMutableArray* AllData;

@property(nonatomic,weak)UICollectionView* collectionView;

- (IBAction)back:(id)sender;
- (IBAction)get_cat_list:(id)sender;

@end

static NSString * const reuseIdentifier = @"shopInfoViewControolerCell";

@implementation shopInfoViewControoler


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initCollectionView];
}

-(NSMutableArray *)AllData{
    if (_AllData == nil) {
        _AllData = [[NSMutableArray alloc] init];
    }
    return _AllData;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        CGFloat itemW = 150;
        CGFloat itemH = 250;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // cell的大小
        layout.itemSize = CGSizeMake(itemW,itemH);
        //计算内边距
        CGFloat inset = (screenW - 2 * layout.itemSize.width) / 3;
        layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
        // 设置每一行之间的间距
        layout.minimumLineSpacing = inset;
        
       UICollectionView* collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,100, screenW, screenH - 100) collectionViewLayout:layout];
        collection.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:collection];
        _collectionView = collection;
    }
    return _collectionView;
}

-(void)initCollectionView{
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
}

-(BGAFN *)BGAFNet{
    if (_BGAFNet == nil) {
        _BGAFNet = [[BGAFN alloc] init];
    }
    return _BGAFNet;
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)get_cat_list:(id)sender {
    [self get_cat_listWithId:0];
}
/**
 根据商品id获取商品信息
 */
-(void)get_cat_listWithId:(NSInteger)cat_id{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //dict[cat_idKey] = @(cat_id);
    dict[methodKey] = @"b2c.goods.get_all_list";//get_cat_list;
    dict[signKey] = [NSString sign:dict];
    
    [self.BGAFNet requestWithDict:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self ToModelWithDict:responseObject];
        //NSLog(@"分类列表 = %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get_cat_listerror-----%@",error);
    }];

}

/**
  字典到模型的数据转换
 */

-(void)ToModelWithDict:(id)responseObject{
    NSDictionary* dict = responseObject[@"data"];
    NSString* data = [dict objectForKey:@"items"];
    NSDictionary* allDict = [global dictionaryWithJsonString:data];
    NSArray* arr = [allDict objectForKey:@"item"];
    for(NSMutableDictionary* di in arr){
        NSString* descri = [di objectForKey:@"description"];//因为不能使用description做变量，所以要先取出来，然后移除，再改名添加，即可kvc;
        [di removeObjectForKey:@"description"];
        [di setValue:descri forKey:@"descriptions"];
        GoodsDetails* good = [GoodsDetails objectWithKeyValues:di];
        [self.AllData addObject:good];
    }
    //BGLog(@"----");
    [self.collectionView reloadData];//加载完数据以后，重新刷新
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 计算一遍内边距
    //[self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    
    // 控制尾部控件的显示和隐藏
   // self.collectionView.footerHidden = (self.deals.count == [MTDealTool collectDealsCount]);
    
    return self.AllData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.goodsDetails = self.AllData[indexPath.item];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    goodsDetailViewController *detailVc = [[goodsDetailViewController alloc] init];
    detailVc.goodsDetails = self.AllData[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];//取消选中
}

@end

//NSArray* AA = [global getGoodImgsWithString:self.goods.item_imgs];
//[self startParseXMLWithString:descri];

//        for(NSDictionary* dic in arr){
//            for(NSString* key in dic.allKeys){
//
////                if ([key isEqualToString:@"item_imgs"]) {
////                    NSArray* imgs = [global dictionaryWithJsonString:[dic objectForKey:key]];
////                    for(NSDictionary* ddict in imgs){
////                        for(NSString* str in ddict.allKeys){
////                             BGLog(@"%@",str);
////                            }
////                    }
////                    break;
////                    continue;
////                }
//                if ([key isEqualToString:@"description"]){
//                    BGLog(@"=== %@",[dic[key] class]);
//                    BGLog(@"--- %@",dic[key]);
//                }
//                //BGLog(@"%@ = %@",key,[dic objectForKey:key]);
//                //BGLog(@"key = %@",key);
//            }
//            break;
//        }
