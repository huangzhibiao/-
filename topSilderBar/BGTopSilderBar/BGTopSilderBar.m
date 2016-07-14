//
//  BGTopSilderBar.m
//  topSilderBar
//
//  Created by huangzhibiao on 16/7/7.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import "BGTopSilderBar.h"
#import "BGTopSilderBarCell.h"
#import "global.h"

@interface BGTopSilderBar()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic,strong)NSArray* items;
@property(nonatomic,weak)UICollectionView* collectView;
@property(nonatomic,weak)UIView* underline;

@property(nonatomic,assign)NSInteger currentBarIndex;//当前选中item的位置

@end

static NSString* ALCELLID = @"BGTopSilderBarCell";

@implementation BGTopSilderBar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _currentBarIndex = 0;
        _items = @[@"头条",@"军事",@"政务",@"热点",@"历史",@"漫画",@"搞笑",@"科技",@"本地",@"娱乐",@"小嘎秀"];
        [self initCollectView];
        [self initUnderline];
    }
    return self;
}
/**
 初始化下划线
 */
-(void)initUnderline{
    CGSize titleSize = [global sizeWithText:[_items firstObject] font:BGFont(19.5) maxSize:CGSizeMake(screenW/itemNum, MAXFLOAT)];
    UIView* uline = [[UIView alloc] initWithFrame:CGRectMake((screenW/itemNum - titleSize.width)*0.5,48,titleSize.width,2)];
    uline.backgroundColor = UnderlineColor;
    _underline  = uline;
    [_collectView addSubview:uline];
}
/**
 初始化装载导航文字的collectView
 */
-(void)initCollectView{
    CGFloat Margin = 0;
    CGFloat W = screenW/itemNum;
    CGFloat H = 50;
    CGRect rect = CGRectMake(Margin,0,screenW,H);
    //初始化布局类(UICollectionViewLayout的子类)
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(W, H);
    layout.minimumInteritemSpacing = 0;//设置行间隔
    layout.minimumLineSpacing = 0;//设置列间隔
    //初始化collectionView
    UICollectionView* collectView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor clearColor];
    _collectView = collectView;
    //设置代理
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.showsHorizontalScrollIndicator = NO;
    // 注册cell
    [collectView registerNib:[UINib nibWithNibName:ALCELLID bundle:nil] forCellWithReuseIdentifier:ALCELLID];
    //设置水平方向滑动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self addSubview:collectView];
}
/**
 从某个item移动到另一个item
 */
-(void)setItemColorFromIndex:(NSInteger)fromIndex to:(NSInteger)toIndex{
    [self scrollToWithIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
    BGTopSilderBarCell* fromCell = (BGTopSilderBarCell*)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:0]];
    BGTopSilderBarCell* toCell = (BGTopSilderBarCell*)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
    [fromCell setTitleColor:color(93.0,93.0,93.0,1.0)];
    [fromCell setFontScale:NO];
    [toCell setTitleColor:color(243.0,39.0,66.0,1.0)];
    [toCell setFontScale:YES];
    _currentBarIndex = toIndex;
}

/**
 设置外部内容的UICollectionView
 */
-(void)setContentCollectionView:(UIScrollView *)contentCollectionView{
    _contentCollectionView = contentCollectionView;
    // 监听contentOffset
    [contentCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 重写removeFromSuperview
 */
-(void)removeFromSuperview{
    [super removeFromSuperview];
    //移除监听contentOffset
    [_contentCollectionView removeObserver:self forKeyPath:@"contentOffset"];
    _contentCollectionView = nil;
}
/**
 设置下划线的x轴距离
 */
-(void)setUnderlineX:(CGFloat)underlineX{
    _underlineX = underlineX;
    CGRect frame = _underline.frame;
    frame.origin.x = underlineX;
    _underline.frame = frame;
}
/**
 设置下划线的宽度
 */
-(void)setUnderlineWidth:(CGFloat)underlineWidth{
    _underlineWidth = underlineWidth;
    CGRect frame = _underline.frame;
    frame.size.width = underlineWidth;
    _underline.frame = frame;
}
#pragma -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BGTopSilderBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ALCELLID forIndexPath:indexPath];
    if (indexPath.row == _currentBarIndex) {
        [cell setTitleColor:SelectedColor];
        cell.BGTitleFont = BGFont(19.5);
    }else{
        [cell setTitleColor:NormalColor];
        cell.BGTitleFont = BGFont(15.0);
    }
    cell.item = _items[indexPath.row];
    return cell;
}

/**
 设置移动位置
 */
-(void)scrollToWithIndexPath:(NSIndexPath *)indexPath{
    NSInteger toRow = indexPath.row;
    if (indexPath.row > _currentBarIndex) {
        if ((indexPath.row+2) < _items.count) {
            toRow = indexPath.row+2;
        }else if((indexPath.row+1) < _items.count){
            toRow = indexPath.row+1;
        }else;
        [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toRow inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }else if (indexPath.row < _currentBarIndex){
        if ((indexPath.row-2) >= 0) {
            toRow = indexPath.row-2;
        }else if ((indexPath.row-1) >= 0){
            toRow = indexPath.row-1;
        }else;
        [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toRow inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }else{
        return;
    }
}

#pragma mark - UIScrollViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self scrollToWithIndexPath:indexPath];
    //[_contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [UIView animateWithDuration:0.5 animations:^{
        [_contentCollectionView scrollRectToVisible:CGRectMake(indexPath.row*screenW,_contentCollectionView.frame.origin.y, _contentCollectionView.frame.size.width, _contentCollectionView.frame.size.height) animated:YES];
    }];
}

#pragma mark 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath])return;
    
    int whichItem=(int)(_contentCollectionView.contentOffset.x/_contentCollectionView.frame.size.width+0.5);
    CGSize titleSize = [global sizeWithText:_items[whichItem] font:BGFont(19.5) maxSize:CGSizeMake(screenW/itemNum, MAXFLOAT)];
    if (whichItem != _currentBarIndex) {
        [self setItemColorFromIndex:_currentBarIndex to:whichItem];
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat X = _contentCollectionView.contentOffset.x/itemNum + (screenW/itemNum - titleSize.width)*0.5;
            [self setUnderlineX:X];
            [self setUnderlineWidth:titleSize.width];
        }];
        NSLog(@"item = %d",whichItem);
    }

    if (_contentCollectionView.isDragging) {
        CGFloat X = _contentCollectionView.contentOffset.x/itemNum + (screenW/itemNum - titleSize.width)*0.5;
        [self setUnderlineX:X];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
          CGFloat  X = _contentCollectionView.contentOffset.x/itemNum + (screenW/itemNum - titleSize.width)*0.5;
        [self setUnderlineX:X];
        }];
    }
    _currentBarIndex = whichItem;
    //NSLog(@"x=%f , y=%f",_collectView.contentOffset.x,_collectView.contentOffset.y);
}

@end
