//
//  CLScaledSamples.h
//  CLDemo
//
//  Created by JmoVxia on 2020/6/26.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLScaledSamples : NSObject

+ (NSData *)scaledWaveformSamples: (NSData *)waveData;

@end

NS_ASSUME_NONNULL_END
