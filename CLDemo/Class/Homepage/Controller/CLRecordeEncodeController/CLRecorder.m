//
//  CLRecorder.m
//  CLDemo
//
//  Created by JmoVxia on 2020/6/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import "CLRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "CLMp3Encoder.h"

#define INPUT_BUS 1

@interface CLRecorder ()

@property (nonatomic, assign) AudioUnit audioUnit;

@property (nonatomic, strong) CLMp3Encoder *mp3Encoder;

@property (nonatomic, copy) NSString *mp3Path;

@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, strong) NSFileHandle * handle;

@property (nonatomic, assign) BOOL otherAudioPlaying;

@property (nonatomic, strong) NSMutableData *waveformSamples;

@end

@implementation CLRecorder

static OSStatus RecordCallback(void *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp *inTimeStamp,
                               UInt32 inBusNumber,
                               UInt32 inNumberFrames,
                               AudioBufferList *ioData)
{
    AudioBufferList bufferList;
    bufferList.mNumberBuffers = 1;
    bufferList.mBuffers[0].mNumberChannels = 1;
    bufferList.mBuffers[0].mData = NULL;
    bufferList.mBuffers[0].mDataByteSize = 0;
    
    CLRecorder *recorder = (__bridge CLRecorder *)(inRefCon);
    AudioUnitRender(recorder.audioUnit, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, &bufferList);
    [recorder.mp3Encoder processAudioBufferList:bufferList];
    return noErr;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self.mp3Encoder run];
        [self initRemoteIO];
    }
    return self;
}
- (void)initRemoteIO {
    AudioUnitInitialize(self.audioUnit);
    [self initBuffer];
    [self initAudioComponent];
    [self initFormat];
    [self initAudioProperty];
    [self initRecordeCallback];
}
- (void)initBuffer {
    UInt32 flag = 0;
    AudioUnitSetProperty(self.audioUnit,
                         kAudioUnitProperty_ShouldAllocateBuffer,
                         kAudioUnitScope_Output,
                         INPUT_BUS,
                         &flag,
                         sizeof(flag));
}
- (void)initAudioComponent {
    AudioComponentDescription audioDesc;
    audioDesc.componentType = kAudioUnitType_Output;
    audioDesc.componentSubType = kAudioUnitSubType_RemoteIO;
    audioDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    audioDesc.componentFlags = 0;
    audioDesc.componentFlagsMask = 0;
    
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &audioDesc);
    AudioComponentInstanceNew(inputComponent, &_audioUnit);
}
- (void)initFormat {
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 44100;
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsNonInterleaved | kAudioFormatFlagIsPacked;
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mChannelsPerFrame = 1;
    audioFormat.mBitsPerChannel = 16;
    audioFormat.mBytesPerFrame = (audioFormat.mBitsPerChannel / 8) * audioFormat.mChannelsPerFrame;
    audioFormat.mBytesPerPacket = audioFormat.mBytesPerFrame;;
    
    AudioUnitSetProperty(self.audioUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Output,
                         INPUT_BUS,
                         &audioFormat,
                         sizeof(audioFormat));
}
- (void)initAudioProperty {
    UInt32 flag = 1;
    AudioUnitSetProperty(self.audioUnit,
                         kAudioOutputUnitProperty_EnableIO,
                         kAudioUnitScope_Input,
                         INPUT_BUS,
                         &flag,
                         sizeof(flag));
}
- (void)initRecordeCallback {
    AURenderCallbackStruct recordCallback;
    recordCallback.inputProc = RecordCallback;
    recordCallback.inputProcRefCon = (__bridge void *)self;
    AudioUnitSetProperty(self.audioUnit,
                         kAudioOutputUnitProperty_SetInputCallback,
                         kAudioUnitScope_Global,
                         INPUT_BUS,
                         &recordCallback,
                         sizeof(recordCallback));
}
- (void)startRecorder {
    self.waveformSamples = [NSMutableData data];
    self.mp3Path = [[Tools pathDocuments] stringByAppendingFormat:@"/%@.mp3", [self currentTime]];
    if (![[NSFileManager defaultManager] fileExistsAtPath: self.mp3Path]) {
        [[NSFileManager defaultManager] createFileAtPath: self.mp3Path contents:nil attributes:nil];
    }
    NSError *error;
    self.handle = [NSFileHandle fileHandleForWritingToURL:[NSURL fileURLWithPath: self.mp3Path] error:&error];
    if (!error) {
        [self activeAudioSession];
        OSStatus status = AudioOutputUnitStart(self.audioUnit);
        if (status != noErr) {
            CLLog(@"startRecorder error: %d", status);
        }
    }else {
        CLLog(@"error: %@", error);
    }
}
- (void)stopRecorder {
    OSStatus status = AudioOutputUnitStop(self.audioUnit);
    [self resumeActiveAudioSession];
    if (status != noErr) {
        CLLog(@"stopRecorder error: %d", status);
    }
}
- (void)activeAudioSession {
    self.otherAudioPlaying = [AVAudioSession sharedInstance].otherAudioPlaying;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setPreferredSampleRate:44100 error:nil];
    [audioSession setPreferredInputNumberOfChannels:1 error:nil];
    [audioSession setPreferredIOBufferDuration:0.023 error:nil];
    [audioSession setActive:YES error:nil];
}
- (void)resumeActiveAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (self.otherAudioPlaying) {
        [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
    }
}
- (void)writeData:(NSData *)data {
    [self.lock lock];
    [self.handle seekToEndOfFile];
    [self.handle writeData:data];
    [self.lock unlock];
}
- (NSString *)currentTime {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",(NSInteger)((CGFloat)time * 1000000)];
}
- (void)dealloc {
    [self.mp3Encoder stop];
    AudioUnitUninitialize(self.audioUnit);
}
- (CLMp3Encoder *)mp3Encoder {
    if (!_mp3Encoder) {
        _mp3Encoder = [[CLMp3Encoder alloc] init];
        _mp3Encoder.inputSampleRate = 44100;
        _mp3Encoder.outputSampleRate = 44100;
        _mp3Encoder.outputChannelsPerFrame = 1;
        _mp3Encoder.bitRate = 16;
        _mp3Encoder.quality = 9;
        __weak __typeof(self) weakSelf = self;
        _mp3Encoder.processingEncodedData = ^(NSData * _Nonnull mp3Data) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            [strongSelf writeData:mp3Data];
        };
    }
    return _mp3Encoder;
}
- (NSLock *)lock {
    if (!_lock) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}
@end
