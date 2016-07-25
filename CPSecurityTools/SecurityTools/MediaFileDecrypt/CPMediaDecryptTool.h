//
//  CPMediaDecryptTool.h
//  CPSecurityTools
//
//  Created by collegepre on 16/7/4.
//  Copyright © 2016年 collegepre. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CPMediaDecryptTypeNone, // 未知类型
    CPMediaDecryptTypeMP3,  // MP3类型
    CPMediaDecryptTypeMP4,  // MP4类型
    CPMediaDecryptTypeAVI   // AVI类型
} CPMediaDecryptType;

typedef void(^CPDecryptMediaFileProgressBlock)(float progress);

typedef void(^CPDecryptMediaFileComplitionBlock)(NSError *error);

@interface CPMediaDecryptTool : NSObject



+ (instancetype)defaultDecryptTool;

- (void)decryptWithsuperFilePath:(NSString *)filePath  headerLength:(NSString *)header keyValue:(NSString *)key progress:(CPDecryptMediaFileProgressBlock)progress complition:(CPDecryptMediaFileComplitionBlock)complition;


@end
