//
//  ViewController.m
//  BGJDRefresh
//
//  Created by huangzhibiao on 16/4/18.
//  Copyright © 2016年 JDRefresh. All rights reserved.
//

#import "ViewController.h"
#import "BGRefresh/BGRefresh.h"

#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initScrollView];
}

/**
 初始化UIScrollView
 */
-(void)initScrollView{
    //初始化一个UITableView
    UITableView* tableview = [[UITableView alloc] init];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.frame = CGRectMake(0,64.0, screenW,screenH-64.0);
    
    BGRefresh* refresh = [[BGRefresh alloc] init];
    refresh.startBlock = ^{
        NSLog(@"开始刷新....");
    };
    refresh.endBlock = ^{
        NSLog(@"结束刷新....");
    };
    refresh.isAutoEnd = YES;//设为自动结束刷新
    refresh.refreshTime = 2.0;//设置自动刷新时间(秒为单位)
    refresh.scrollview = tableview;
    
    [self.view addSubview:tableview];
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

@end
