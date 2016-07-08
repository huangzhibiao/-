//
//  ViewController.m
//  topSilderBar
//
//  Created by huangzhibiao on 16/7/7.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import "ViewController.h"
#import "global.h"
#import "BGHomePageTopGoodsCell.h"
#import "BGTopSilderBar.h"
static NSString* ALCELLID = @"BGHomePageTopGoodsCell";

@interface ViewController()<UICollectionViewDataSource,UICollectionViewDelegate,BGTopSilderBarDelegate>

@property(nonatomic,weak)BGTopSilderBar* silderBar;
@property(nonatomic,weak)UICollectionView* collectView;
@property(nonatomic,assign)int currentBarIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initSilderBar];//初始化顶部BGTopSilderBar
    [self initCollectView];//初始化底部滑动的collectionView
}

/**
 初始化BGTopSilderBar
 */
-(void)initSilderBar{
    BGTopSilderBar* silder = [[BGTopSilderBar alloc] initWithFrame:CGRectMake(0,20,screenW, 50)];
    silder.delegate = self;
    _silderBar = silder;
    [self.view addSubview:silder];
}
/**
 初始化底部滑动的collectionView
 */
-(void)initCollectView{
    CGFloat Margin = 0;
    CGFloat W = screenW;
    CGFloat H = screenH-75;
    CGRect rect = CGRectMake(Margin,75, W,H);
    //初始化布局类(UICollectionViewLayout的子类)
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(W, H);
    layout.minimumInteritemSpacing = 0;//设置行间隔
    layout.minimumLineSpacing = 0;//设置列间隔
    //初始化collectionView
    UICollectionView* collectView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
    collectView.tag = 0;
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
    //设置分页
    collectView.pagingEnabled = YES;
//    // 监听contentOffset
//    [collectView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
//    //设置_collectView滑动到某个位置
//    [collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self.view addSubview:collectView];
}

#pragma -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 11;//此处页面的张数要跟顶部滑动栏的item个数一样
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        BGHomePageTopGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ALCELLID forIndexPath:indexPath];
    cell.backgroundColor = color(rand()%255,rand()%255,rand()%255,1.0);
        return cell;
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int whichItem=(int)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5);
    CGSize titleSize = [global sizeWithText:_silderBar.items[whichItem] font:BGFont(19.5) maxSize:CGSizeMake(screenW/itemNum, MAXFLOAT)];
    if (whichItem != _currentBarIndex) {
        [_silderBar setItemColorFromIndex:_currentBarIndex to:whichItem];
        [UIView animateWithDuration:0.5 animations:^{
            _silderBar.underlineWidth = titleSize.width;
        }];
         NSLog(@"item = %d",whichItem);
    }
    if (_collectView.isDragging) {
        _silderBar.underlineX = _collectView.contentOffset.x/itemNum + (screenW/itemNum - titleSize.width)*0.5;
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _silderBar.underlineX = _collectView.contentOffset.x/itemNum + (screenW/itemNum - titleSize.width)*0.5;
        }];
    }
    _currentBarIndex = whichItem;
}

#pragma mark - BGTopSilderBarDelegate

-(void)SBcollectionView:(UICollectionView *)SBcollectionView didSelectItemAtIndex:(NSInteger)index{
    [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

//#pragma mark 监听UIScrollView的contentOffset属性
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if (![@"contentOffset" isEqualToString:keyPath])return;
//    //_silderBar.underlineX = _collectView.contentOffset.x/6;
//    //NSLog(@"x=%f , y=%f",_collectView.contentOffset.x,_collectView.contentOffset.y);
//}

@end
