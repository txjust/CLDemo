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


#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>


static void set_bits(uint8_t *bytes, int32_t bitOffset, int32_t numBits, int32_t value) {
    numBits = (unsigned int)pow(2, numBits) - 1; //this will only work up to 32 bits, of course
    uint8_t *data = bytes;
    data += bitOffset / 8;
    bitOffset %= 8;
    *((int32_t *)data) |= ((value) << bitOffset);
}



@interface CLRecordeEncodeController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) CLRecorder *recorder;
@property (nonatomic, strong) CLChatVoiceWave *waveView;

@end

@implementation CLRecordeEncodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recorder = [[CLRecorder alloc] init];
    self.recorder.mp3Path = [[Tools pathDocuments] stringByAppendingFormat:@"/testMP3.mp3"];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stopButton];
    [self.view addSubview:self.waveView];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(200);
    }];
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-200);
    }];
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    
    self.waveView.peakHeight = 50;
}

- (void)startAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
        [self.recorder startRecorder];
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        NSLog(@"%f",end - start);
        self.startButton.selected = YES;
        self.stopButton.selected = NO;
    });
}
- (void)endAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recorder stopRecorder];
        self.stopButton.selected = YES;
        self.startButton.selected = NO;
        NSData *waveSamples = [self audioWaveform:[NSURL fileURLWithPath:self.recorder.mp3Path]];
        self.waveView.waveData = waveSamples;
    });
}
- (NSData *)audioWaveform:(NSURL *)url {
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    if (asset == nil) {
        NSLog(@"asset is not defined!");
        return nil;
    }
    
    NSError *assetError = nil;
    AVAssetReader *iPodAssetReader = [AVAssetReader assetReaderWithAsset:asset error:&assetError];
    if (assetError) {
        NSLog (@"error: %@", assetError);
        return nil;
    }
    
    AVAssetReaderOutput *readerOutput = [AVAssetReaderAudioMixOutput assetReaderAudioMixOutputWithAudioTracks:asset.tracks audioSettings:outputSettings];
    
    if (! [iPodAssetReader canAddOutput: readerOutput]) {
        NSLog (@"can't add reader output... die!");
        return nil;
    }
    
    // add output reader to reader
    [iPodAssetReader addOutput: readerOutput];
    
    if (! [iPodAssetReader startReading]) {
        NSLog(@"Unable to start reading!");
        return nil;
    }
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%f",end - start);

    NSMutableData *_waveformSamples = [[NSMutableData alloc] init];
    int16_t _waveformPeak = 0;
    int _waveformPeakCount = 0;
    
    while (iPodAssetReader.status == AVAssetReaderStatusReading) {
        // Check if the available buffer space is enough to hold at least one cycle of the sample data
        CMSampleBufferRef nextBuffer = [readerOutput copyNextSampleBuffer];
        
        if (nextBuffer) {
            AudioBufferList abl;
            CMBlockBufferRef blockBuffer = NULL;
            CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(nextBuffer, NULL, &abl, sizeof(abl), NULL, NULL, kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment, &blockBuffer);
            UInt64 size = CMSampleBufferGetTotalSampleSize(nextBuffer);
            if (size != 0) {
                int16_t *samples = (int16_t *)(abl.mBuffers[0].mData);
                int count = (int)size / 2;
                
                for (int i = 0; i < count; i++) {
                    int16_t sample = samples[i];
                    if (sample < 0) {
                        sample = -sample;
                    }
                    
                    if (_waveformPeak < sample) {
                        _waveformPeak = sample;
                    }
                    _waveformPeakCount++;
                    
                    if (_waveformPeakCount >= 100) {
                        [_waveformSamples appendBytes:&_waveformPeak length:2];
                        _waveformPeak = 0;
                        _waveformPeakCount = 0;
                    }
                }
            }
            
            CFRelease(nextBuffer);
            if (blockBuffer) {
                CFRelease(blockBuffer);
            }
        }
        else {
            break;
        }
    }
    
    int16_t scaledSamples[100];
    memset(scaledSamples, 0, 100 * 2);
    int16_t *samples = _waveformSamples.mutableBytes;
    int count = (int)_waveformSamples.length / 2;
    for (int i = 0; i < count; i++) {
        int16_t sample = samples[i];
        int index = i * 100 / count;
        if (scaledSamples[index] < sample) {
            scaledSamples[index] = sample;
        }
    }
    
    int16_t peak = 0;
    int64_t sumSamples = 0;
    for (int i = 0; i < 100; i++) {
        int16_t sample = scaledSamples[i];
        if (peak < sample) {
            peak = sample;
        }
        sumSamples += sample;
    }
    uint16_t calculatedPeak = 0;
    calculatedPeak = (uint16_t)(sumSamples * 1.8f / 100);
    
    if (calculatedPeak < 2500) {
        calculatedPeak = 2500;
    }
    
    for (int i = 0; i < 100; i++) {
        uint16_t sample = (uint16_t)((int64_t)samples[i]);
        if (sample > calculatedPeak) {
            scaledSamples[i] = calculatedPeak;
        }
    }
    
    int numSamples = 100;
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
- (CLChatVoiceWave *)waveView {
    if (!_waveView) {
        _waveView = [[CLChatVoiceWave alloc] init];
    }
    return _waveView;
}
@end
