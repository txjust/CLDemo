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
{
    AudioUnit audioUnit;
    CLMp3Encoder *mp3Encoder;
//    AudioBufferList *buffList;
}

@end


@implementation CLRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
        mp3Encoder = [[CLMp3Encoder alloc] init];
        mp3Encoder.inputSampleRate = 96000;
        mp3Encoder.outputSampleRate = 96000;
        mp3Encoder.outputChannelsPerFrame = 1;
        mp3Encoder.bitRate = 16;
        mp3Encoder.quality = 9;
        [mp3Encoder run];
        AudioUnitInitialize(audioUnit);
        [self initRemoteIO];
    }
    
    return self;
}

- (void)setProcessingEncodedData:(void (^)(NSData *))processingEncodedData {
    _processingEncodedData = processingEncodedData;
    mp3Encoder.processingEncodedData = processingEncodedData;
}

- (void)initRemoteIO {
    [self initAudioSession];
    
    [self initBuffer];
    
    [self initAudioComponent];
    
    [self initFormat];
    
    [self initAudioProperty];
    
    [self initRecordeCallback];
    
//    [self initPlayCallback];
}

- (void)initAudioSession {
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [audioSession setPreferredSampleRate:96000 error:&error];
    [audioSession setPreferredInputNumberOfChannels:1 error:&error];
    [audioSession setPreferredIOBufferDuration:0.05 error:&error];
}

- (void)initBuffer {
    UInt32 flag = 0;
    AudioUnitSetProperty(audioUnit,
                         kAudioUnitProperty_ShouldAllocateBuffer,
                         kAudioUnitScope_Output,
                         INPUT_BUS,
                         &flag,
                         sizeof(flag));
    
//    buffList = (AudioBufferList *)malloc(sizeof(AudioBufferList));
//    buffList->mNumberBuffers = 1;
//    buffList->mBuffers[0].mNumberChannels = 1;
//    buffList->mBuffers[0].mDataByteSize = 2048 * sizeof(short);
//    buffList->mBuffers[0].mData = (short *)malloc(sizeof(short) * 2048);
}

- (void)initAudioComponent {
    AudioComponentDescription audioDesc;
    audioDesc.componentType = kAudioUnitType_Output;
    audioDesc.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
    audioDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    audioDesc.componentFlags = 0;
    audioDesc.componentFlagsMask = 0;
    
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &audioDesc);
    AudioComponentInstanceNew(inputComponent, &audioUnit);
}

- (void)initFormat {
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 96000;
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mChannelsPerFrame = 1;
    audioFormat.mBitsPerChannel = 16;
    audioFormat.mBytesPerFrame = (audioFormat.mBitsPerChannel / 8) * audioFormat.mChannelsPerFrame;
    audioFormat.mBytesPerPacket = (audioFormat.mBitsPerChannel / 8) * audioFormat.mChannelsPerFrame;;
    
    AudioUnitSetProperty(audioUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Output,
                         INPUT_BUS,
                         &audioFormat,
                         sizeof(audioFormat));
//    AudioUnitSetProperty(audioUnit,
//                         kAudioUnitProperty_StreamFormat,
//                         kAudioUnitScope_Input,
//                         OUTPUT_BUS,
//                         &audioFormat,
//                         sizeof(audioFormat));
}

- (void)initRecordeCallback {
    AURenderCallbackStruct recordCallback;
    recordCallback.inputProc = RecordCallback;
    recordCallback.inputProcRefCon = (__bridge void *)self;
    AudioUnitSetProperty(audioUnit,
                         kAudioOutputUnitProperty_SetInputCallback,
                         kAudioUnitScope_Global,
                         INPUT_BUS,
                         &recordCallback,
                         sizeof(recordCallback));
}

//- (void)initPlayCallback {
//    AURenderCallbackStruct playCallback;
//    playCallback.inputProc = PlayCallback;
//    playCallback.inputProcRefCon = (__bridge void *)self;
//    AudioUnitSetProperty(audioUnit,
//                         kAudioUnitProperty_SetRenderCallback,
//                         kAudioUnitScope_Global,
//                         OUTPUT_BUS,
//                         &playCallback,
//                         sizeof(playCallback));
//}

- (void)initAudioProperty {
    UInt32 flag = 1;
    AudioUnitSetProperty(audioUnit,
                         kAudioOutputUnitProperty_EnableIO,
                         kAudioUnitScope_Input,
                         INPUT_BUS,
                         &flag,
                         sizeof(flag));
//    AudioUnitSetProperty(audioUnit,
//                         kAudioOutputUnitProperty_EnableIO,
//                         kAudioUnitScope_Input,
//                         OUTPUT_BUS,
//                         &flag,
//                         sizeof(flag));

}

#pragma mark - callback function

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
    AudioUnitRender(recorder->audioUnit, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, &bufferList);
    [recorder->mp3Encoder processAudioBufferList:bufferList];
    return noErr;
}

//static OSStatus PlayCallback(void *inRefCon,
//                            AudioUnitRenderActionFlags *ioActionFlags,
//                            const AudioTimeStamp *inTimeStamp,
//                            UInt32 inBusNumber,
//                            UInt32 inNumberFrames,
//                            AudioBufferList *ioData) {
//    XYRecorder *recorder = (__bridge XYRecorder *)(inRefCon);
//    AudioUnitRender(recorder->audioUnit, ioActionFlags, inTimeStamp, 1, inNumberFrames, ioData);
//    return noErr;
//}

#pragma mark - public methods

- (void)startRecorder {
    AudioOutputUnitStart(audioUnit);
}

- (void)stopRecorder {
    AudioOutputUnitStop(audioUnit);
}

- (void)dealloc {
    AudioUnitUninitialize(audioUnit);
}

@end
