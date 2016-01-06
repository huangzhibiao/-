//
//  BuyViewController.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/21.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BuyViewController.h"
#import "BuyTopView.h"
#import "BuyMiddleView.h"
#import "global.h"
#import "BuyBottomView.h"
#import "MyOrderTopTabBar.h"

#define TopViewH 380
#define MiddleViewH 195
#define BottomH 52
#define TopTabBarH [global pxTopt:100]


@interface BuyViewController ()<UIScrollViewDelegate,MyOrderTopTabBarDelegate>

@property(nonatomic,weak)MyOrderTopTabBar* TopTabBar;

@property (weak, nonatomic) UIScrollView *MyScrollView;
@property (weak, nonatomic) BuyTopView* topView;
@property (weak, nonatomic) BuyMiddleView* middleView;
@property (weak, nonatomic) BuyBottomView* bottomView;

@property (assign,nonatomic) Boolean isFirstPage;

@end

@implementation BuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isFirstPage = true;
    [self initView];
}

-(UIScrollView *)MyScrollView{
    if (_MyScrollView == nil) {
        UIScrollView* scroll = [[UIScrollView alloc] init];
        _MyScrollView = scroll;
        scroll.delegate = self;
        scroll.frame = CGRectMake(0, 0, screenW, screenH-BottomH);
        scroll.alwaysBounceVertical = YES;
        scroll.showsVerticalScrollIndicator = NO;
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
    BuyTopView* topView = [BuyTopView view];
    self.topView = topView;
    topView.frame = CGRectMake(0,0, screenW, TopViewH);
    [self.MyScrollView addSubview:topView];
    BuyMiddleView* middleView = [BuyMiddleView view];
    self.middleView = middleView;
    middleView.frame = CGRectMake(0,CGRectGetMaxY(topView.frame) + 6, screenW, MiddleViewH);
    [self.MyScrollView addSubview:middleView];
    BuyBottomView* bottomView = [BuyBottomView view];
    self.bottomView = bottomView;
    CGFloat bottomViewY = 0.0;
    if (iphone6plus) {
        bottomViewY = self.MyScrollView.frame.size.height - BottomH;
    }else{
        bottomViewY = CGRectGetMaxY(middleView.frame);
    }
    bottomView.frame = CGRectMake(0,bottomViewY, screenW, BottomH);
    [self.MyScrollView addSubview:bottomView];
    [self initBottomView];
    //初始化第二个页面
    [self addSecondPageTopTabBar];
    self.MyScrollView.contentSize = CGSizeMake(screenW, TopViewH + MiddleViewH + BottomH);
}
/**
 添加第二个页面顶部tabBar
 */
-(void)addSecondPageTopTabBar{
    NSArray* array  = @[@"图文详情",@"宝贝评价",@"宝贝咨询"];
    MyOrderTopTabBar* tabBar = [[MyOrderTopTabBar alloc] initWithArray:array] ;
    tabBar.frame = CGRectMake(0, CGRectGetMaxY(self.bottomView.frame), screenW, TopTabBarH);
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.delegate = self;
    self.TopTabBar = tabBar;
    [self.MyScrollView addSubview:tabBar];
}
#pragma -- <UIScrollViewDelegate>
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat value = scrollView.contentSize.height - scrollView.frame.size.height;
//    int temp = abs((int)value);
//    if ((scrollView.contentOffset.y>(temp+50)) && self.isFirstPage) {
//        self.isFirstPage = false;
//        scrollView.contentSize = CGSizeMake(screenW, TopViewH + MiddleViewH + BottomH + TopTabBarH);
//        scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height-TopTabBarH);
//        NSLog(@"拖拽 超过距离 --- ");
//    }
//    
//}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate && (scrollView.contentOffset.y>0)) {
    scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height-TopTabBarH);
    scrollView.contentSize = CGSizeMake(screenW, TopViewH + MiddleViewH + BottomH + TopTabBarH);
        //NSLog(@"%f,%f,%d",scrollView.contentSize.height);
    }else{
        
    }
}
#pragma -- MyOrderTopTabBarDelegate(顶部标题栏delegate)
-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index{
    NSLog(@"点击了 －－－ %ld",index);
}
@end
