//
//  CLDataWriter.m
//  CLDemo
//
//  Created by JmoVxia on 2020/6/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import "CLDataWriter.h"
#import "CLScaledSamples.h"

@interface CLDataWriter ()

@property (nonatomic, strong) NSLock *lock;

@end

@implementation CLDataWriter

- (void)writeBytes:(void *)bytes length:(NSUInteger)length toPath:(NSString *)path {
    NSData *data = [NSData dataWithBytes:bytes length:length];
    [self writeData:data toPath:path];
}

- (void)writeData:(NSData *)data toPath:(NSString *)path {
    [self.lock lock];
    NSString *savePath = path;
    if (![[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
        [[NSFileManager defaultManager] createFileAtPath:savePath contents:nil attributes:nil];
    }
    NSFileHandle * handle = [NSFileHandle fileHandleForWritingAtPath:savePath];
    [handle seekToEndOfFile];
    [handle writeData:data];
    
    NSData *waveData = [CLScaledSamples scaledWaveformSamples: data];
    
    [self.lock unlock];
}

- (NSLock *)lock {
    if (_lock == nil) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}
@end
