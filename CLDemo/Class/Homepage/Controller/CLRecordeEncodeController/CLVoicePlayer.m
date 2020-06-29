//
//  CLVoicePlayer.m
//  CLDemo
//
//  Created by JmoVxia on 2020/6/28.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import "CLVoicePlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface CLVoicePlayer ()

///playerItem
@property (nonatomic, strong) AVPlayerItem *playerItem;
///player
@property (nonatomic, strong) AVPlayer *player;
///其他设备在播放
@property (nonatomic, assign) BOOL otherAudioPlaying;

@end


@implementation CLVoicePlayer

- (void)moviePlayDidEnd {
    if (self.replay) {
        [self.player seekToTime:CMTimeMake(0, 1)];
        [self.player play];
    }else {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.playerItem];
        [self.player pause];
        self.playerItem = nil;
        self.player = nil;
        if (self.otherAudioPlaying) {
            [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        }else {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
        }
        if (self.endCallback) {
            self.endCallback();
        }
    }
}
- (void)playWithItem:(AVPlayerItem *)playerItem {
    if (self.playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.playerItem];
    }
    if (playerItem) {
        self.otherAudioPlaying = [AVAudioSession sharedInstance].otherAudioPlaying;
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        self.playerItem = playerItem;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:playerItem];
        self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        [self.player play];
    }
}
///根据url播放
- (void)playWithUrl: (NSURL *)url {
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:url]];
    [self playWithItem:playerItem];
}
///停止声音
- (void)stop {
    self.replay = false;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:self.playerItem];
    [self.player pause];
    self.playerItem = nil;
    self.player = nil;
    if (self.otherAudioPlaying) {
        [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    if (self.endCallback) {
        self.endCallback();
    }
}

@end
