//
//  CLMp3Encoder.m
//  CLDemo
//
//  Created by JmoVxia on 2020/6/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import "CLMp3Encoder.h"
#import "lame.h"

const int MP3_BUFF_SIZE = 4096;

@interface CLMp3Encoder ()
{
    lame_t lame;
    unsigned char mp3_buffer[MP3_BUFF_SIZE];
    short int *pcmData1;
    short int *pcmData2;
    dispatch_queue_t _encodeQueue;
}

@end


@implementation CLMp3Encoder

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self jn__setup];
    }
    return self;
}
 
- (void)jn__setup
{
    _encodeQueue = dispatch_queue_create("jn.mp3Encoder", DISPATCH_QUEUE_SERIAL);
    _inputSampleRate = [AVAudioSession sharedInstance].sampleRate;
    _outputSampleRate = [AVAudioSession sharedInstance].sampleRate;
    _outputChannelsPerFrame = 1;
    _bitRate = 16;
    _quality = 5;
}
 
- (void)run
{
    [self setupLameIfNeeded];
    _running = YES;
}
 
- (void)stop
{
    _running = NO;
    [self closeLame];
}
 
- (void)setupLameIfNeeded
{
    if (lame == NULL) {
        lame = lame_init();
        lame_set_in_samplerate(lame,_inputSampleRate);//采样播音速度，值越大播报速度越快，反之。
        lame_set_quality (lame, _quality); /* 2=high 5 = medium 7=low 音 质 */
        lame_set_VBR(lame, vbr_default);
        lame_set_brate(lame, _bitRate);
        lame_set_out_samplerate(lame, _outputSampleRate);
        lame_set_num_channels(lame, _outputChannelsPerFrame);
        lame_init_params(lame);
    }
}
 
- (void)closeLame
{
    if (lame) {
        lame_close(lame);
        lame = NULL;
    }
}
 
- (void)processAudioBufferList:(AudioBufferList)audioBufferList
{
    if(!_running){
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(_encodeQueue, ^{
        __strong typeof(weakSelf) sSelf = weakSelf;
        int channels = audioBufferList.mBuffers[0].mNumberChannels;
        short int *pcmData = audioBufferList.mBuffers[0].mData;
        int size = audioBufferList.mBuffers[0].mDataByteSize / (sizeof(short int) * channels);
        int bytesWritten = 0;
        NSData *data = nil;
        if (channels == 2) {
            bytesWritten = lame_encode_buffer_interleaved(sSelf->lame, pcmData, size, sSelf->mp3_buffer, MP3_BUFF_SIZE);
        }
        else if (channels == 1){
            if (sSelf->pcmData1 == NULL) {
                sSelf->pcmData1 = pcmData;
            }
            if (sSelf->pcmData2 == NULL) {
                sSelf->pcmData2 = pcmData;
            }
            if (sSelf->pcmData1 && sSelf->pcmData2) {
                bytesWritten = lame_encode_buffer(sSelf->lame, sSelf->pcmData1, sSelf->pcmData2,size, sSelf->mp3_buffer, MP3_BUFF_SIZE);
                sSelf->pcmData1 = NULL;
                sSelf->pcmData2 = NULL;
 
            }
        }
        if (bytesWritten && sSelf.processingEncodedData) {
            data = [[NSData alloc] initWithBytes:sSelf->mp3_buffer length:bytesWritten];
            sSelf.processingEncodedData(data);
        }
    });
}
- (void)dealloc {
    [self stop];
}
@end
