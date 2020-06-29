//
//  CLRecordeEncodeController.m
//  CLDemo
//
//  Created by JmoVxia on 2020/6/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import "CLRecordeEncodeController.h"
#import "CLRecorder.h"
#import "CLDemo-Swift.h"
#import <AVFoundation/AVFoundation.h>
#import "CLVoicePlayer.h"

static void set_bits(uint8_t *bytes, int32_t bitOffset, int32_t numBits, int32_t value) {
    numBits = (unsigned int)pow(2, numBits) - 1; //this will only work up to 32 bits, of course
    uint8_t *data = bytes;
    data += bitOffset / 8;
    bitOffset %= 8;
    *((int32_t *)data) |= ((value) << bitOffset);
}



@interface CLRecordeEncodeController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) CLRecorder *recorder;
@property (nonatomic, strong) CLChatVoiceWave *waveView;
@property (nonatomic, strong) CLVoicePlayer *player;

@end

@implementation CLRecordeEncodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recorder = [[CLRecorder alloc] init];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.waveView];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(90);
        make.top.mas_equalTo(200);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200);
        make.right.mas_equalTo(-90);
    }];
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    self.waveView.peakHeight = 50;
}

- (void)startAction {
    if (!self.startButton.selected) {
        NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
        [self.recorder startRecorder];
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        CLLog(@"%f",end - start);
        CLLog(@"%@",self.recorder.mp3Path);
    }else {
        [self.recorder stopRecorder];
        if (self.recorder.mp3Path.length > 0) {
            NSData *waveSamples = [self audioWaveform];
            self.waveView.waveData = waveSamples;
        }
    }
    self.startButton.selected = !self.startButton.selected;
}
- (void)playAction {
    if (self.recorder.mp3Path.length > 0) {
        if (!self.playButton.isSelected) {
            [self.player playWithUrl:[NSURL fileURLWithPath:self.recorder.mp3Path]];
        }else {
            [self.player stop];
        }
        self.playButton.selected = !self.playButton.selected;
    }
}
- (NSData *)audioWaveform {
    int sampleCount = 100;
    int16_t scaledSamples[sampleCount];
    memset(scaledSamples, 0, sampleCount * 2);
    int16_t *samples = self.recorder.waveformSamples.mutableBytes;
    int count = (int)self.recorder.waveformSamples.length / 2;
    for (int i = 0; i < count; i++) {
        int16_t sample = samples[i];
        int index = i * sampleCount / count;
        if (scaledSamples[index] < sample) {
            scaledSamples[index] = sample;
        }
    }
    int16_t peak = 0;
    int64_t sumSamples = 0;
    for (int i = 0; i < sampleCount; i++) {
        int16_t sample = scaledSamples[i];
        if (peak < sample) {
            peak = sample;
        }
        sumSamples += sample;
    }
    uint16_t calculatedPeak = 0;
    calculatedPeak = (uint16_t)(sumSamples * 1.8f / sampleCount);

    if (calculatedPeak < 2500) {
        calculatedPeak = 2500;
    }

    for (int i = 0; i < sampleCount; i++) {
        uint16_t sample = (uint16_t)((int64_t)samples[i]);
        if (sample > calculatedPeak) {
            scaledSamples[i] = calculatedPeak;
        }
    }

    int numSamples = sampleCount;
    int number = 5;
    int bitstreamLength = (numSamples * number) / 8 + (((numSamples * number) % 8) == 0 ? 0 : 1);
    NSMutableData *result = [[NSMutableData alloc] initWithLength:bitstreamLength];
    {
        int32_t maxSample = peak;
        uint16_t const *samples = (uint16_t *)scaledSamples;
        uint8_t *bytes = result.mutableBytes;

        for (int i = 0; i < numSamples; i++) {
            int32_t value = MIN(31, ABS((int32_t)samples[i]) * 31 / maxSample);
            set_bits(bytes, i * number, number, value & 31);
        }
    }
    return result;
}


- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [[UIButton alloc] init];
        [_startButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
        [_startButton setTitle:@"结束" forState:UIControlStateSelected];
        [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_playButton setTitle:@"播放" forState:UIControlStateNormal];
        [_playButton setTitle:@"停止" forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (CLChatVoiceWave *)waveView {
    if (!_waveView) {
        _waveView = [[CLChatVoiceWave alloc] init];
    }
    return _waveView;
}
- (CLVoicePlayer *)player {
    if (!_player) {
        _player = [[CLVoicePlayer alloc] init];
    }
    return _player;
}
@end
