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
#import "CLDataWriter.h"

#define INPUT_BUS 1

@interface CLRecorder ()

@property (nonatomic, assign) AudioUnit audioUnit;

@property (nonatomic, strong) CLMp3Encoder *mp3Encoder;

@property (nonatomic, strong) CLDataWriter *dataWriter;

@property (nonatomic, assign) NSTimeInterval startDuration;

@property (nonatomic, assign) NSTimeInterval endDuration;

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
    [self initAudioSession];
    [self initBuffer];
    [self initAudioComponent];
    [self initFormat];
    [self initAudioProperty];
    [self initRecordeCallback];
}
- (void)initAudioSession {
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [audioSession setPreferredSampleRate:44100 error:&error];
    [audioSession setPreferredInputNumberOfChannels:1 error:&error];
    [audioSession setPreferredIOBufferDuration:0.05 error:&error];
    [audioSession setActive:YES error:nil];
    
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
- (void)initAudioProperty {
    UInt32 flag = 1;
    AudioUnitSetProperty(self.audioUnit,
                         kAudioOutputUnitProperty_EnableIO,
                         kAudioUnitScope_Input,
                         INPUT_BUS,
                         &flag,
                         sizeof(flag));
}
- (void)startRecorder {
//    if ([[NSFileManager defaultManager] fileExistsAtPath:self.mp3Path])
//    {
//        [[NSFileManager defaultManager] removeItemAtPath:self.mp3Path error:nil];
//    }
    AudioOutputUnitStart(self.audioUnit);
    self.startDuration = [[NSDate date] timeIntervalSince1970];
}
- (void)stopRecorder {
    AudioOutputUnitStop(self.audioUnit);
    self.endDuration = [[NSDate date] timeIntervalSince1970];
    NSLog(@"当前录制时长   %f", self.endDuration - self.startDuration);
}
- (void)dealloc {
    AudioUnitUninitialize(self.audioUnit);
    [self.mp3Encoder stop];
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
            [strongSelf.dataWriter writeData:mp3Data toPath:strongSelf.mp3Path];
        };
    }
    return _mp3Encoder;
}
- (CLDataWriter *)dataWriter {
    if (!_dataWriter) {
        _dataWriter = [[CLDataWriter alloc] init];
    }
    return _dataWriter;
}
@end
