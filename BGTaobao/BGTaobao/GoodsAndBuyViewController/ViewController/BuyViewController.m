//
//  BuyViewController.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/21.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BuyViewController.h"
#import "global.h"
#import "BuyTopView.h"
#import "BuyMiddleView.h"
#import "BuyBottomView.h"
#import "MyOrderTopTabBar.h"
#import "MJRefresh.h"
#import "NaviBase.h"

#define TopViewH 380
#define MiddleViewH 195
#define BottomH 52
#define TopTabBarH [global pxTopt:100]
#define NaviBarH 64.0

@interface BuyViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MyOrderTopTabBarDelegate>

@property(nonatomic,weak)MyOrderTopTabBar* TopTabBar;
@property(nonatomic,weak)UIView* NavBarView;

@property (weak, nonatomic) UIScrollView *MyScrollView;
@property (weak, nonatomic) BuyTopView* topView;
@property (weak, nonatomic) BuyMiddleView* middleView;
@property (weak, nonatomic) BuyBottomView* bottomView;
@property (weak, nonatomic) UITableView* detailTableview;
@property (weak, nonatomic)MJRefreshHeaderView* header;
@property (assign, nonatomic)float TopViewScale;


@end

@implementation BuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TopViewScale = 1.0;
    [self initView];
    [self addNavBarView];//提示,要在最后添加
}

/**
 添加导航栏背后的View
 */
-(void)addNavBarView{
    UIView* view = [[UIView alloc] init];
    self.NavBarView = view;
    view.frame = CGRectMake(0, 0, screenW, 64.0);
    [self.view addSubview:view];
}
-(void)viewDidDisappear:(BOOL)animated{
    //释放下拉刷新内存
    [self.header free];
    [self.MyScrollView removeFromSuperview];
    [super viewDidDisappear:animated];
}
-(UIScrollView *)MyScrollView{
    if (_MyScrollView == nil) {
        UIScrollView* scroll = [[UIScrollView alloc] init];
        _MyScrollView = scroll;
        scroll.delegate = self;
        scroll.frame = CGRectMake(0.0, 0.0, screenW, screenH-BottomH);
        scroll.pagingEnabled = YES;//进行分页
        scroll.showsVerticalScrollIndicator = NO;
        scroll.tag = 0;
        [self.view addSubview:scroll];
    }
    return _MyScrollView;
}
/**
 添加底部购买按钮和加入购物车按钮的view
 */
-(void)initBottomView{
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(0,CGRectGetMaxY(self.MyScrollView.frame), screenW, BottomH);
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnW = 100;
    CGFloat btnH = 52;
    CGFloat margin = 3;
    //加入购物车按钮
    CGFloat aX = screenW - btnW;
    UIButton* aBtn = [[UIButton alloc] init];
    aBtn.frame = CGRectMake(aX, 0, btnW, btnH);
    [aBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    aBtn.backgroundColor = color(250.0, 63.0, 51.0, 1.0);
    [aBtn addTarget:self action:@selector(addShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:aBtn];
    
    //立即购买按钮
    CGFloat bX = screenW - 2*btnW - margin;
    UIButton* bBtn = [[UIButton alloc] init];
    bBtn.frame = CGRectMake(bX, 0, btnW, btnH);
    [bBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [bBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bBtn.backgroundColor = color(0.0, 162.0, 154.0, 1.0);
    [bBtn addTarget:self action:@selector(nowBuy:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bBtn];

    
    [self.view addSubview:view];
}
/**
 加入购物车按钮点击动作
 */
-(void)addShoppingCar:(id)sender{
    NSLog(@"加入购物车");
}
/**
 立即购买按钮动作
 */
-(void)nowBuy:(id)sender{
     NSLog(@"购买");
}
/**
 初始化相关的view
 */
-(void)initView{
    //初始化第一个页面
    //初始化第一个页面的父亲view
    UIView* firstPageView = [[UIView alloc] init];
    firstPageView.frame = CGRectMake(0, 0, screenW, screenH - BottomH);
    BuyTopView* topView = [BuyTopView view];
    self.topView = topView;
    topView.frame = CGRectMake(0,0, screenW, TopViewH);
    [firstPageView addSubview:topView];
    BuyMiddleView* middleView = [BuyMiddleView view];
    self.middleView = middleView;
    middleView.frame = CGRectMake(0,CGRectGetMaxY(topView.frame) + 6, screenW, MiddleViewH);
    [firstPageView addSubview:middleView];
    BuyBottomView* bottomView = [BuyBottomView view];
    self.bottomView = bottomView;
    CGFloat bottomViewY = 0.0;
    if (iphone6plus) {
        bottomViewY = self.MyScrollView.frame.size.height - BottomH;
    }else{
        bottomViewY = CGRectGetMaxY(middleView.frame);
    }
    bottomView.frame = CGRectMake(0,bottomViewY, screenW, BottomH);
    [firstPageView addSubview:bottomView];
    [self.MyScrollView addSubview:firstPageView];
    [self initBottomView];
    //初始化第二个页面
    [self addSecondPageTopTabBar];
    // 设置scrollview内容区域大小
    self.MyScrollView.contentSize = CGSizeMake(screenW, (screenH - BottomH)*2);
}
/**
 添加第二个页面顶部tabBar
 */
-(void)addSecondPageTopTabBar{
    //初始化第二个页面的父亲view
    UIView* secondPageView = [[UIView alloc] init];
    secondPageView.frame = CGRectMake(0, screenH - BottomH, screenW, screenH - BottomH);
    NSArray* array  = @[@"图文详情",@"宝贝评价",@"宝贝咨询"];
    MyOrderTopTabBar* tabBar = [[MyOrderTopTabBar alloc] initWithArray:array] ;
    tabBar.frame = CGRectMake(0,NaviBarH, screenW, TopTabBarH);
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.delegate = self;
    self.TopTabBar = tabBar;
    [secondPageView addSubview:tabBar];
    //初始化一个UITableView
    UITableView* tableview = [[UITableView alloc] init];
    self.detailTableview = tableview;
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.tag = 1;
    tableview.frame = CGRectMake(0, CGRectGetMaxY(tabBar.frame), screenW,secondPageView.frame.size.height - tabBar.frame.size.height-NaviBarH);
    MJRefreshHeaderView* RheaderView = [MJRefreshHeaderView header];
    RheaderView.scrollView = tableview;
    self.header = RheaderView;
    RheaderView.beginRefreshingBlock = ^(MJRefreshBaseView* refreshView){
        NSOperationQueue* Queue = [[NSOperationQueue alloc] init];
        [Queue addOperationWithBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    self.MyScrollView.contentOffset = CGPointMake(0, 0);
                } completion:^(BOOL finished) {
                    self.MyScrollView.scrollEnabled = YES;
                }];
                [self.header endRefreshing];
            });
        }];
    };

    [secondPageView addSubview:tableview];
    [self.MyScrollView addSubview:secondPageView];
}
#pragma -- <UIScrollViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@" --== %f",scrollView.contentOffset.y);
    if(scrollView.tag == 0){
        if(scrollView.contentOffset.y<0){
            if(self.TopViewScale<1.01){
                self.TopViewScale += 0.00015f;
                [self.topView.icon_img setTransform:CGAffineTransformScale(self.topView.icon_img.transform, self.TopViewScale, self.TopViewScale)];
            }
            scrollView.contentOffset = CGPointMake(0, 0);
        }else{
            self.NavBarView.backgroundColor = color(0.0,162.0,154.0, scrollView.contentOffset.y/(screenH-BottomH));
        }
        if(scrollView.contentOffset.y == (screenH-BottomH)){
            scrollView.scrollEnabled = NO;
        }else if (scrollView.contentOffset.y == -NaviBarH && !scrollView.isDragging){
            [UIView animateWithDuration:0.3 animations:^{
                scrollView.contentOffset = CGPointMake(0, 0);
            }];
        }else;
    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSLog(@" endd-- %f",self.TopViewScale);
    self.TopViewScale = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.topView.icon_img setTransform:CGAffineTransformIdentity];//恢复原来的大小
    }];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //NSLog(@" -- %f",scrollView.contentOffset.y);
}

#pragma -- MyOrderTopTabBarDelegate(顶部标题栏delegate)
-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index{
    NSLog(@"点击了 －－－ %ld",index);
}
#pragma -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
    
}

#pragma -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

@end
