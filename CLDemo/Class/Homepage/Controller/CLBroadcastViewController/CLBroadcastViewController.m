//
//  CLBroadcastViewController.m
//  CLDemo
//
//  Created by AUG on 2019/9/4.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLBroadcastViewController.h"
#import "CLBroadcastView.h"
#import "CLBroadcastMainCell.h"
#import <Masonry/Masonry.h>
#import "CLGCDTimerManager.h"

@interface CLBroadcastViewController ()<CLBroadcastViewDataSource, CLBroadcastViewDelegate>

///数据源
@property (nonatomic, strong) NSMutableArray *arrayDS;
///广播view
@property (nonatomic, strong) CLBroadcastView *broadcastView;
///广播view
@property (nonatomic, strong) CLBroadcastView *broadcastView1;
///广播view
@property (nonatomic, strong) CLBroadcastView *broadcastView2;
///广播view
@property (nonatomic, strong) CLBroadcastView *broadcastView3;
///广播view
@property (nonatomic, strong) CLBroadcastView *broadcastView4;
///广播view
@property (nonatomic, strong) CLBroadcastView *broadcastView5;
///定时器
@property (nonatomic, strong) CLGCDTimer *timer;

@end

@implementation CLBroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self mas_makeConstraints];
    [self reloadData];
}
- (void)initUI {
    [self.view addSubview:self.broadcastView];
    [self.view addSubview:self.broadcastView1];
    [self.view addSubview:self.broadcastView2];
    [self.view addSubview:self.broadcastView3];
    [self.view addSubview:self.broadcastView4];
    [self.view addSubview:self.broadcastView5];
}
- (void)mas_makeConstraints {
    [self.broadcastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(60);
        make.bottom.mas_equalTo(self.broadcastView1.mas_top).offset(-90);
    }];
    [self.broadcastView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.center.mas_equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    [self.broadcastView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.top.mas_equalTo(self.broadcastView1.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    [self.broadcastView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.top.mas_equalTo(self.broadcastView2.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    [self.broadcastView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.top.mas_equalTo(self.broadcastView3.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    [self.broadcastView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.top.mas_equalTo(self.broadcastView4.mas_bottom);
        make.height.mas_equalTo(60);
    }];
}
- (void)reloadData {
    [self.broadcastView reloadData];
    [self.broadcastView1 reloadData];
    [self.broadcastView2 reloadData];
    [self.broadcastView3 reloadData];
    [self.broadcastView4 reloadData];
    [self.broadcastView5 reloadData];
    [self.timer start];
}
///广播个数
- (NSInteger)broadcastViewRows:(CLBroadcastView *)broadcast {
    return self.arrayDS.count;
}
///创建cell
- (CLBroadcastCell *)broadcastView:(CLBroadcastView *)broadcast cellForRowAtIndexIndex:(NSInteger)index {
    CLBroadcastMainCell *cell = (CLBroadcastMainCell *)[broadcast dequeueReusableCellWithIdentifier:@"CLBroadcastMainCell"];
    cell.backgroundColor = [UIColor lightGrayColor];
    NSInteger currentIndex = (index + broadcast.tag) % self.arrayDS.count;
    cell.adText = [self.arrayDS objectAtIndex:currentIndex];
    return cell;
}
///点击cell
- (void)broadcastView:(CLBroadcastView *)broadcast didSelectIndex:(NSInteger)index {
    CLLog(@"点击：%ld", index)
}
- (NSMutableArray *)arrayDS {
    if (!_arrayDS) {
        _arrayDS = [NSMutableArray array];
        [_arrayDS addObject:@"我是第一个"];
        [_arrayDS addObject:@"我是第二个"];
        [_arrayDS addObject:@"我是第三个"];
        [_arrayDS addObject:@"我是第四个"];
        [_arrayDS addObject:@"我是第五个"];
        [_arrayDS addObject:@"我是第六个"];
        [_arrayDS addObject:@"我是第七个"];
    }
    return _arrayDS;
}
- (void)scrollToNext {
    [self.broadcastView scrollToNext];
    [self.broadcastView1 scrollToNext];
    [self.broadcastView2 scrollToNext];
    [self.broadcastView3 scrollToNext];
    [self.broadcastView4 scrollToNext];
    [self.broadcastView5 scrollToNext];
}
- (CLBroadcastView *)broadcastView {
    if (!_broadcastView) {
        _broadcastView = [[CLBroadcastView alloc] init];
        [_broadcastView registerClass:[CLBroadcastMainCell class] forCellReuseIdentifier:@"CLBroadcastMainCell"];
        _broadcastView.rotationTime = 3;
        _broadcastView.dataSource = self;
        _broadcastView.delegate = self;
        _broadcastView.tag = 0;
    }
    return _broadcastView;
}
- (CLBroadcastView *)broadcastView1 {
    if (!_broadcastView1) {
        _broadcastView1 = [[CLBroadcastView alloc] init];
        [_broadcastView1 registerClass:[CLBroadcastMainCell class] forCellReuseIdentifier:@"CLBroadcastMainCell"];
        _broadcastView1.rotationTime = 1;
        _broadcastView1.dataSource = self;
        _broadcastView1.delegate = self;
        _broadcastView1.tag = 0;
    }
    return _broadcastView1;
}
- (CLBroadcastView *)broadcastView2 {
    if (!_broadcastView2) {
        _broadcastView2 = [[CLBroadcastView alloc] init];
        [_broadcastView2 registerClass:[CLBroadcastMainCell class] forCellReuseIdentifier:@"CLBroadcastMainCell"];
        _broadcastView2.rotationTime = 1;
        _broadcastView2.dataSource = self;
        _broadcastView2.delegate = self;
        _broadcastView2.tag = 1;
    }
    return _broadcastView2;
}
- (CLBroadcastView *)broadcastView3 {
    if (!_broadcastView3) {
        _broadcastView3 = [[CLBroadcastView alloc] init];
        [_broadcastView3 registerClass:[CLBroadcastMainCell class] forCellReuseIdentifier:@"CLBroadcastMainCell"];
        _broadcastView3.rotationTime = 1;
        _broadcastView3.dataSource = self;
        _broadcastView3.delegate = self;
        _broadcastView3.tag = 2;
    }
    return _broadcastView3;
}
- (CLBroadcastView *)broadcastView4 {
    if (!_broadcastView4) {
        _broadcastView4 = [[CLBroadcastView alloc] init];
        [_broadcastView4 registerClass:[CLBroadcastMainCell class] forCellReuseIdentifier:@"CLBroadcastMainCell"];
        _broadcastView4.rotationTime = 1;
        _broadcastView4.dataSource = self;
        _broadcastView4.delegate = self;
        _broadcastView4.tag = 3;
    }
    return _broadcastView4;
}
- (CLBroadcastView *)broadcastView5 {
    if (!_broadcastView5) {
        _broadcastView5 = [[CLBroadcastView alloc] init];
        [_broadcastView5 registerClass:[CLBroadcastMainCell class] forCellReuseIdentifier:@"CLBroadcastMainCell"];
        _broadcastView5.rotationTime = 1;
        _broadcastView5.dataSource = self;
        _broadcastView5.delegate = self;
        _broadcastView5.tag = 4;
    }
    return _broadcastView5;
}
- (CLGCDTimer *)timer {
    if (!_timer) {
        __weak __typeof(self) weakSelf = self;
        _timer = [[CLGCDTimer alloc] initWithInterval:2 delaySecs:2 queue:dispatch_get_main_queue() repeats:YES action:^(NSInteger __unused actionTimes) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            [strongSelf scrollToNext];
        }];
    }
    return _timer;
}



@end
