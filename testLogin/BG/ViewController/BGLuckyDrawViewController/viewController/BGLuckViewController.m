//
//  BGLuckViewController.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/30.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BGLuckViewController.h"
#import "global.h"
#import "TabButton.h"

#define scroll_H (iphone6?1131.0:1249.0)
#define BGLuckBackground_H (iphone6?1065.0:1176.0)
#define BGLuckSmallBackground_W (iphone6?300.0:331.0)
#define BGLuckSmallBackground_H (iphone6?279.0:308.0)
#define BGLuckSmallBackground_MarginTop (iphone6?181.0:200.0)
#define BGLuckSmallFive_W (iphone6?94.0:104.0)
#define BGLuckSmallFive_H (iphone6?48.0:53.0)
#define BGLuckSmallFive__MarginTop (iphone6?425.0:469.0)
#define BGLamp_WH (iphone6?12.0:13.0)
#define BGLuckItem_W (iphone6?87.0:96.0)
#define BGLuckItem_H (iphone6?72.0:80.0)
#define BGLuckItem_TLR (iphone6?12.0:13.0)
#define BGLuckItem_Margin (iphone6?4.0:5.0)
#define BGLuckBorderSubView_W (iphone6?277.0:306.0)
#define BGLuckBorderSubView_H (iphone6?234.0:258.0)
#define BGLuckInfoView_MarginTop (iphone6?831.0:917.0)
#define BGLuckInfoView_W (iphone6?349.0:385.0)
#define BGLuckInfoView_H (iphone6?184.0:203.0)
#define BGLuckInfoView_L (iphone6?13.0:14.0)

@interface BGLuckViewController ()
@property (weak, nonatomic) UIScrollView *MyScrollView;
@property (weak, nonatomic) UIImageView* borderImageView;//中奖框
@property (weak, nonatomic) UIView* borderSubView;//中奖框中的字view
@property (weak, nonatomic) UIButton* lastItem;//记录转到的奖项
@property (weak, nonatomic) UIView* luckInfoView;//展示中奖信息的view
@property (strong, nonatomic) NSMutableArray* luckInfos;//存放中奖信息
@property (assign ,nonatomic) NSInteger currentLuckIndex;//记录当前指到的中奖信息
@property (assign, nonatomic) BOOL lampFlash;
@property (assign, nonatomic) float beginLuck;//开始抽奖标志

- (IBAction)back:(id)sender;

@end

@implementation BGLuckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lampFlash = true;
    self.currentLuckIndex = 0;
    [self initMyScrollView];//初始化MyScrollView及里面的相关控件
    [self addLamp];//添加奖框上的小灯
    [self addLuckItem];//添加奖项
    [self addLuckPeopleInfo];//添加中奖人展示信息项
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.lampFlash = false;
}
/**
 初始化存放中奖信息数组
 */
-(NSMutableArray *)luckInfos{
    if (_luckInfos == nil) {
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        [arr addObject:@"尾号***1的朋友,恭喜您中了一罐蛋白粉"];
        [arr addObject:@"尾号***2的朋友,恭喜您中了一罐蛋白粉"];
        [arr addObject:@"尾号***3的朋友,恭喜您中了一瓶鱼油"];
        [arr addObject:@"尾号***4的朋友,恭喜您中了一部6s"];
        [arr addObject:@"尾号***5的朋友,恭喜您中了一罐蛋白粉"];
        _luckInfos = arr;
    }
    return _luckInfos;
}
/**
 在get函数中初始化MyScrollView
 */
-(void)initMyScrollView{
    if (_MyScrollView == nil) {
        CGFloat tempW;
        UIScrollView* scroll = [[UIScrollView alloc] init];
        _MyScrollView = scroll;
        scroll.alwaysBounceVertical = YES;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.frame = CGRectMake(0, 64, screenW, screenH);
        scroll.contentSize = CGSizeMake(screenW,scroll_H);
        //背景图片
        UIImageView* iv = [[UIImageView alloc] init];
        iv.userInteractionEnabled = YES;//设置可交互
        iv.image = [UIImage imageNamed:@"BGLuckBackground"];
        iv.frame = CGRectMake(0,0,screenW,BGLuckBackground_H);
        //奖项背景框
        UIImageView* iv1 = [[UIImageView alloc] init];
        self.borderImageView = iv1;
        iv1.userInteractionEnabled = YES;//设置可交互
        iv1.image = [UIImage imageNamed:@"BGLuckSmallBackground"];
        tempW = BGLuckSmallBackground_W;
        iv1.frame = CGRectMake((screenW-tempW)*0.5,BGLuckSmallBackground_MarginTop,BGLuckSmallBackground_W,BGLuckSmallBackground_H);
        //边框小饰品
        UIImageView* iv2 = [[UIImageView alloc] init];
        iv2.userInteractionEnabled = YES;//设置可交互
        iv2.image = [UIImage imageNamed:@"BGLuckSmallFive"];
        tempW = BGLuckSmallFive_W;
        iv2.frame = CGRectMake(screenW-tempW,BGLuckSmallFive__MarginTop,BGLuckSmallFive_W,BGLuckSmallFive_H);
        //中奖信息
        UIView* LuckInfoView = [[UIView alloc] init];
        self.luckInfoView = LuckInfoView;
        LuckInfoView.frame = CGRectMake(BGLuckInfoView_L, BGLuckInfoView_MarginTop, BGLuckInfoView_W, BGLuckInfoView_H);
        [scroll addSubview:iv];
        [scroll addSubview:iv1];
        [scroll addSubview:iv2];
        [scroll addSubview:LuckInfoView];
        [self.view addSubview:scroll];
    }
}

/**
 添加小灯
 */
-(void)addLamp{
    int count = 7;
    CGFloat SBackW = BGLuckSmallBackground_W;
    CGFloat WH = BGLamp_WH;
    CGFloat Margin = (SBackW - WH*count)/(count-1);
    for(int i=0;i<count;i++){
        UIImageView* iv = [[UIImageView alloc] init];
        if (i%2) {
            iv.image = [UIImage imageNamed:@"BGLuckLamp0"];
        }else{
            iv.image = [UIImage imageNamed:@"BGLuckLamp2"];
        }
        iv.frame = CGRectMake(i*(Margin+WH), 0, WH,WH);
        [self.borderImageView addSubview:iv];
    }
    CGFloat SBackH = iphone6?260.0:287.0;
    Margin = (SBackH - WH*count)/(count-1);
    for(int i=1;i<6;i++){
        for(int j=0;j<2;j++){
            UIImageView* iv = [[UIImageView alloc] init];
            if (i%2) {
                iv.image = [UIImage imageNamed:@"BGLuckLamp1"];
            }else{
                iv.image = [UIImage imageNamed:@"BGLuckLamp3"];
            }
            iv.frame = CGRectMake(j*(SBackW-WH),i*(Margin+WH), WH,WH);
            [self.borderImageView addSubview:iv];
        }
    }
    Margin = (SBackW - WH*count)/(count-1);
    for(int i=0;i<count;i++){
        UIImageView* iv = [[UIImageView alloc] init];
        if (i%2) {
            iv.image = [UIImage imageNamed:@"BGLuckLamp0"];
        }else{
            iv.image = [UIImage imageNamed:@"BGLuckLamp2"];
        }
        iv.frame = CGRectMake(i*(Margin+WH),SBackH-WH, WH,WH);
        [self.borderImageView addSubview:iv];
    }
    [self BeginflashLamp];//开启小灯闪烁
}
/**
 小灯闪烁程序
 */
-(void)BeginflashLamp{
    //创建多线
    dispatch_queue_t queue = dispatch_queue_create("BeginflashLamp", NULL);
    NSInteger count = self.borderImageView.subviews.count;
    //创建一个子线程
    dispatch_async(queue, ^{
        while(self.lampFlash){
            for(int i=0;i<count;i++){
                [NSThread sleepForTimeInterval:0.01];//秒为单位
                //回到主线程
                dispatch_sync(dispatch_get_main_queue(), ^{
                    UIImageView* iv = self.borderImageView.subviews[i];
                    if ([iv isKindOfClass:[UIImageView class]]){
                        NSString* name = [NSString stringWithFormat:@"BGLuckLamp%d",(rand()%4)];
                        iv.image = [UIImage imageNamed:name];
                    }
                    //NSLog(@"------%@",[iv class]);
                });
            }
        }
    });
    
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
/**
 在奖框内添加奖项
 */
-(void)addLuckItem{
    UIView* view = [[UIView alloc] init];
    self.borderSubView = view;
    view.backgroundColor = [UIColor blackColor];
    view.frame = CGRectMake(BGLuckItem_TLR, BGLuckItem_TLR,BGLuckBorderSubView_W,BGLuckBorderSubView_H);
    [self.borderImageView addSubview:view];
    for(int i=0;i<3;i++){
        for(int j=0;j<3;j++){
            NSString* name = [NSString stringWithFormat:@"BGLuckItem%d",i*3+j];
            if (1==i && 1==j) {
                UIButton* beginLuck = [[UIButton alloc] init];
                [beginLuck setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
                [beginLuck addTarget:self action:@selector(beginLuckAction) forControlEvents:UIControlEventTouchUpInside];
                beginLuck.frame = CGRectMake(j*(BGLuckItem_W+BGLuckItem_Margin) + BGLuckItem_Margin,i*(BGLuckItem_H+BGLuckItem_Margin)+BGLuckItem_Margin , BGLuckItem_W, BGLuckItem_H);
                beginLuck.tag = i*3+j;
                [self.borderSubView addSubview:beginLuck];
            }else{
                TabButton* luckItem = [[TabButton alloc] init];
                [luckItem setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
                [luckItem setImage:[UIImage imageNamed:@"BGGoodLuck"] forState:UIControlStateSelected];
                luckItem.frame = CGRectMake(j*(BGLuckItem_W+BGLuckItem_Margin) + BGLuckItem_Margin,i*(BGLuckItem_H+BGLuckItem_Margin)+BGLuckItem_Margin , BGLuckItem_W, BGLuckItem_H);
                luckItem.tag = i*3+j;
                [self.borderSubView addSubview:luckItem];
            }
        }
    }
}
/**
 添加中奖人展示信息项
 */
-(void)addLuckPeopleInfo{
    [self loopLuckPeopleInfo];
}
/**
 中奖人信息轮转
 */
-(void)loopLuckPeopleInfo{
    //创建多线
    dispatch_queue_t queue = dispatch_queue_create("loopLuckPeopleInfo", NULL);
    //创建一个子线程
    dispatch_async(queue, ^{
        while(self.lampFlash){
            //NSLog(@"-------***------");
            [NSThread sleepForTimeInterval:1.5];
            //回到主线程
            dispatch_sync(dispatch_get_main_queue(), ^{
                //NSLog(@"-count-%ld",self.luckInfoView.subviews.count);
                [UIView animateWithDuration:1.0 animations:^{
                    for(UILabel* lab in self.luckInfoView.subviews){
                        if(CGRectGetMaxY(lab.frame)<=(BGLuckInfoView_H-5.0)){
                            lab.frame = CGRectMake(lab.frame.origin.x, lab.frame.origin.y+lab.frame.size.height, lab.frame.size.width, lab.frame.size.height);
                        }else{
                            [lab removeFromSuperview];
                        }
                    }
                }];
            });
            [NSThread sleepForTimeInterval:0.5];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.0 animations:^{
                    if(self.luckInfoView.subviews.count<5){
                        UILabel* newLab = [[UILabel alloc] init];
                        [newLab setTextColor:[UIColor yellowColor]];
                        if(self.currentLuckIndex>=self.luckInfos.count){
                            self.currentLuckIndex = 0;
                        }
                        if (self.luckInfos.count>0){
                            newLab.text = self.luckInfos[self.currentLuckIndex++];
                        }
                        newLab.font = BGFont(14.0);
                        newLab.textAlignment  = NSTextAlignmentLeft;
                        newLab.frame = CGRectMake(15.0,5.0, BGLuckInfoView_W,BGLuckInfoView_H*0.2f);
                        [self.luckInfoView addSubview:newLab];
                    }
                }];
            });
        }
    });

}

/**
 监听点击开始抽奖按钮点击事件
 */
-(void)beginLuckAction{
    if (self.beginLuck>0) {
        NSLog(@"正在抽奖中....");
        return;
    }
    NSLog(@"开始抽奖....");
    self.lastItem.selected = NO;
    self.beginLuck = 4.0;
    float LuckTimes = self.beginLuck*0.5f;
    float LuckNum = rand()%8;
    //创建多线
    dispatch_queue_t queue = dispatch_queue_create("beginLuckAction", NULL);
    //创建一个子线程
    dispatch_async(queue, ^{
        NSMutableArray* allItems = [[NSMutableArray alloc] init];
        [allItems addObject:self.borderSubView.subviews[0]];
        [allItems addObject:self.borderSubView.subviews[1]];
        [allItems addObject:self.borderSubView.subviews[2]];
        [allItems addObject:self.borderSubView.subviews[5]];
        [allItems addObject:self.borderSubView.subviews[8]];
        [allItems addObject:self.borderSubView.subviews[7]];
        [allItems addObject:self.borderSubView.subviews[6]];
        [allItems addObject:self.borderSubView.subviews[3]];
        float allNum = 0.0;
        float temp = 0.0;
        NSTimeInterval time = 0.0;
        while(self.beginLuck > 0){
            for(int i=0;i<allItems.count;i++){
                if (self.beginLuck > LuckTimes) {
                    allNum++;
                }else{
                    allNum--;
                }
                
                TabButton* item = allItems[i];
                //回到主线程
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if ([item isKindOfClass:[TabButton class]]) {
                        item.selected = YES;
                        self.lastItem.selected = NO;
                        self.lastItem = item;
                    }

                });
                if (self.beginLuck < 1.0 && i == LuckNum) {
                    NSString* message;
                    switch (i) {
                        case 0:
                        case 4:
                            message = @"恭喜您中了iphone6s";
                            break;
                        case 1:
                             message = @"恭喜您中了一瓶鱼油";
                            break;
                        case 2:
                        case 6:
                            message = @"恭喜您中了一罐植物蛋白粉";
                            break;
                        case 3:
                            message = @"恭喜您中了5元代金劵";
                            break;
                        case 5:
                            message = @"谢谢参与";
                            break;
                        case 7:
                            message = @"恭喜您中了10元代金劵";
                            break;
                        default:
                            break;
                    }
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.luckInfos addObject:[NSString stringWithFormat:@"尾号****的朋友%@",message]];
                        [self AlertWithTitle:@"" message:message];
                        });
                    break;
                }
                temp = (self.beginLuck-LuckTimes)>0.0?(self.beginLuck-LuckTimes):(LuckTimes-self.beginLuck);
                time = (temp/4.0f + (32.0-allNum)*0.015f)*0.2f;
                [NSThread sleepForTimeInterval:time];//秒为单位
                NSLog(@"--- %f",allNum);
            }//for(int i=0;i<allItems.count;i++)
            self.beginLuck -= 0.5f;
        }//while(self.beginLuck > 0)
        [allItems removeAllObjects];
        allItems = nil;
    });
}
#pragma -- 对应行的点击操作
/**
 弹出相关提示信息
 */
-(void)AlertWithTitle:(NSString*)title message:(NSString*)message{
    UIAlertController* AlertControl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [AlertControl addAction:ok];
    [self presentViewController:AlertControl animated:YES completion:^{}];
}
@end
