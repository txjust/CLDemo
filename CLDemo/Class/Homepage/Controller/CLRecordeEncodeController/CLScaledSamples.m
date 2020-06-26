//
//  CLScaledSamples.m
//  CLDemo
//
//  Created by JmoVxia on 2020/6/26.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import "CLScaledSamples.h"

@implementation CLScaledSamples

+ (NSData *)scaledWaveformSamples: (NSData *)waveData {
    NSMutableData *data = [NSMutableData dataWithData:waveData];
    int16_t scaledSamples[100];
    memset(scaledSamples, 0, 100 * 2);
    int16_t *samples = data.mutableBytes;
    int count = (int)data.length / 2;
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
        sumSamples += peak;
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
    return [NSData dataWithBytes:scaledSamples length:100 * 2];
}

@end
