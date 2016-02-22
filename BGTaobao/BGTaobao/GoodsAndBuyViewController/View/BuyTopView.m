//
//  BuyTopView.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/21.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BuyTopView.h"
#import "BGCenterLineLabel.h"
#import "BGDetailViewCell.h"
#import "global.h"

@interface BuyTopView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *name_lab;//产品名称
@property (weak, nonatomic) IBOutlet UILabel *descri_lab;//产品描述
@property (weak, nonatomic) IBOutlet UILabel *nowPrice_lab;//当前价格
@property (weak, nonatomic) IBOutlet BGCenterLineLabel *oldPrice_lab;//原价
@property (weak, nonatomic) IBOutlet UIButton *collect_Btn;//收藏按钮
@property (weak, nonatomic) IBOutlet UILabel *sales_lab;//月销售量
@property (weak, nonatomic) IBOutlet UICollectionView *detailView;


@end

@implementation BuyTopView

-(void)awakeFromNib{
    [self.collect_Btn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    // 注册cell
    self.detailView.dataSource = self;
    self.detailView.delegate = self;
    [self.detailView registerNib:[UINib nibWithNibName:@"BGDetailViewCell" bundle:nil] forCellWithReuseIdentifier:@"BGDetailViewCell"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // cell的大小
    layout.itemSize = CGSizeMake(screenW,277);//动态计算itemCell的大小,以适配屏幕
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0.0;
    self.detailView.collectionViewLayout = layout;
}

-(void)dealloc{
    [self.rightRefresh free];
}

-(void)collectAction:(UIButton*)sender{
    sender.selected = sender.isSelected?NO:YES;
    
}
+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BuyTopView" owner:nil options:nil] firstObject];
}

-(void)setImages:(NSArray *)images{
    _images = images;
    BGLRRefresh* refresh = [BGLRRefresh view];
    self.rightRefresh = refresh;
    refresh.scrollview = self.detailView;
    [refresh contentWidth:images.count*screenW];
    [self.detailView reloadData];
}

#pragma mark -- UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"BGDetailViewCell";
    BGDetailViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.image = self.images[indexPath.row];
    return cell;
}


@end
