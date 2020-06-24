//
//  CLDataWriter.h
//  CLDemo
//
//  Created by JmoVxia on 2020/6/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLDataWriter : NSObject

- (void)writeBytes:(void *)bytes length:(NSUInteger)length toPath:(NSString *)path;

- (void)writeData:(NSData *)data toPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
