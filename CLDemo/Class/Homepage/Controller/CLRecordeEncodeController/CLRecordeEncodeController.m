//
//  CLRecordeEncodeController.m
//  CLDemo
//
//  Created by JmoVxia on 2020/6/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import "CLRecordeEncodeController.h"
#import "CLRecorder.h"
@interface CLRecordeEncodeController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) CLRecorder *recorder;

@end

@implementation CLRecordeEncodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stopButton];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(200);
    }];
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-200);
    }];
    
//    NSDate *waveData = 
    
    
}
- (void)startAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recorder startRecorder];
        self.startButton.selected = YES;
        self.stopButton.selected = NO;
    });
}
- (void)endAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recorder stopRecorder];
        self.stopButton.selected = YES;
        self.startButton.selected = NO;
    });
}
- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [[UIButton alloc] init];
        [_startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
        [_startButton setTitle:@"开始" forState:UIControlStateSelected];
        [_startButton setTitle:@"开始" forState:UIControlStateHighlighted];
        [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}
- (UIButton *)stopButton {
    if (!_stopButton) {
        _stopButton = [[UIButton alloc] init];
        [_stopButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_stopButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_stopButton setTitle:@"结束" forState:UIControlStateNormal];
        [_stopButton setTitle:@"结束" forState:UIControlStateSelected];
        [_stopButton setTitle:@"结束" forState:UIControlStateHighlighted];
        [_stopButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}
- (CLRecorder *)recorder {
    if (!_recorder) {
        _recorder = [[CLRecorder alloc] init];
        _recorder.mp3Path = [[Tools pathDocuments] stringByAppendingFormat:@"/testMP3.mp3"];
    }
    return _recorder;
}
@end
