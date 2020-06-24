//
//  CLMp3Encoder.h
//  CLDemo
//
//  Created by JmoVxia on 2020/6/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLMp3Encoder : NSObject

@property (nonatomic, assign, readonly) BOOL   running;
@property (nonatomic, assign) double inputSampleRate; //输入buffer帧率
@property (nonatomic, assign) double outputSampleRate; //编码输出帧率
@property (nonatomic, assign) int  outputChannelsPerFrame; //输出频道数 单声道还是双声道
@property (nonatomic, assign) int  bitRate; //输出频道数 单声道还是双声道
@property (nonatomic, assign) int  quality; // 0 - 9 (high - low)
 
@property (nonatomic, copy) void(^processingEncodedData)(NSData *mp3Data);


- (void)run;
 
- (void)stop;
 
- (void)processAudioBufferList:(AudioBufferList)audioBufferList;


@end

NS_ASSUME_NONNULL_END
