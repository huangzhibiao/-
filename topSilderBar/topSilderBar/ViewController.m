//
//  ViewController.m
//  topSilderBar
//
//  Created by huangzhibiao on 16/7/7.
//  Copyright © 2016年 Biao. All rights reserved.
//
#warning 特别标注 -> 这里可以使用UICollectionView和UIScrollView来做各各页面，此默认使用UIScrollView来添加不同的UIViewController来做，而UICollectionView是通过BGTopSilderBarCell来做个个页面,看自己习惯哪一种
#import "ViewController.h"
#import "global.h"
#import "BGHomePageTopGoodsCell.h"
#import "BGTopSilderBar.h"
#import "oneController.h"
#import "twoViewController.h"
static NSString* ALCELLID = @"BGHomePageTopGoodsCell";

@interface ViewController()//<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,weak)BGTopSilderBar* silderBar;
//@property(nonatomic,weak)UICollectionView* collectView;
@property(nonatomic,weak)UIScrollView* scrollView;
@property(nonatomic,assign)int currentBarIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self initCollectView];//初始化底部滑动的collectionView
    [self initScrollView];
    [self initSilderBar];//初始化顶部BGTopSilderBar
}

/**
 初始化BGTopSilderBar
 */
-(void)initSilderBar{
    BGTopSilderBar* silder = [[BGTopSilderBar alloc] initWithFrame:CGRectMake(0,20,screenW, 50)];
    //silder.contentCollectionView = _collectView;//_collectView必须要在前面初始化,不然这里值为nil
    silder.contentCollectionView = _scrollView;//_scrollView必须要在前面初始化,不然这里值为nil
    _silderBar = silder;
    [self.view addSubview:silder];
}

/**
初始化UIScrollView
*/
-(void)initScrollView{
    UIScrollView* scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0,75,screenW,screenH-75);
    scroll.contentSize = CGSizeMake(11*screenW,screenH-75);//contentSize的宽度等于顶部滑动栏的item个数乘与屏幕宽度screenW
    scroll.pagingEnabled = YES;
    _scrollView = scroll;
    [self.view addSubview:scroll];
    [self addChildViewController];
}

/**
 添加子控制器
 */
-(void)addChildViewController{
    for(int i=0;i<11;i++){
        if (i%2) {
            twoViewController* twoCon = [[twoViewController alloc] init];
            twoCon.index = i;
            [self addChildViewController:twoCon];
            twoCon.view.frame = CGRectMake(i*screenW,0,screenW,screenH-75);
            [_scrollView addSubview:twoCon.view];
        }else{
            oneController* oneCon = [[oneController alloc] init];
            oneCon.index = i;
            [self addChildViewController:oneCon];
            oneCon.view.frame = CGRectMake(i*screenW,0,screenW,screenH-75);
            [_scrollView addSubview:oneCon.view];
        }
    }
}
///**
// 初始化底部滑动的collectionView
// */
//-(void)initCollectView{
//    CGFloat Margin = 0;
//    CGFloat W = screenW;
//    CGFloat H = screenH-75;
//    CGRect rect = CGRectMake(Margin,75, W,H);
//    //初始化布局类(UICollectionViewLayout的子类)
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//    layout.itemSize = CGSizeMake(W, H);
//    layout.minimumInteritemSpacing = 0;//设置行间隔
//    layout.minimumLineSpacing = 0;//设置列间隔
//    //初始化collectionView
//    UICollectionView* collectView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
//    collectView.tag = 0;
//    collectView.backgroundColor = [UIColor clearColor];
//    _collectView = collectView;
//    //设置代理
//    collectView.delegate = self;
//    collectView.dataSource = self;
//    collectView.showsHorizontalScrollIndicator = NO;
//    // 注册cell
//    [collectView registerNib:[UINib nibWithNibName:ALCELLID bundle:nil] forCellWithReuseIdentifier:ALCELLID];
//    //设置水平方向滑动
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    //设置分页
//    collectView.pagingEnabled = YES;
//    [self.view addSubview:collectView];
//}
//
//#pragma -- UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 11;//此处页面的张数要跟顶部滑动栏的item个数一样
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//        BGHomePageTopGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ALCELLID forIndexPath:indexPath];
//    cell.backgroundColor = color(rand()%255,rand()%255,rand()%255,1.0);
//        return cell;
//}

@end
