//
//  CLVoicePlayer.h
//  CLDemo
//
//  Created by JmoVxia on 2020/6/28.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLVoicePlayer : NSObject

///重新播放
@property (nonatomic, copy) void (^endCallback) (void);

///重新播放
@property (nonatomic, assign) BOOL replay;

///根据url播放
- (void)playWithUrl: (NSURL *)url;

///停止声音
- (void)stop;


@end

NS_ASSUME_NONNULL_END
