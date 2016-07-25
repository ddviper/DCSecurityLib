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
/**
 *  进度block回调
 *
 *  @param progress 整体进度不是一个文件的解密进度
 */
typedef void(^CPDecryptMediaFileProgressBlock)(float progress);

/**
 *  解密完成后回调的block
 *
 *  @param error 如果为空则解密成功
 */
typedef void(^CPDecryptMediaFileComplitionBlock)(NSError *error);

@interface CPMediaDecryptTool : NSObject

/**
 *  初始化工具类
 *
 *  @return 工具类
 */
+ (instancetype)defaultDecryptTool;
/**
 *  解密当前文件夹及文件夹下的所有音/视频文件
 *
 *  @param filePath   当前文件目录
 *  @param header     salt头长度
 *  @param key        加密的Key值
 *  @param progress   进度block
 *  @param complition 完成回调block
 */
- (void)decryptWithsuperFilePath:(NSString *)filePath  headerLength:(NSString *)header keyValue:(NSString *)key progress:(CPDecryptMediaFileProgressBlock)progress complition:(CPDecryptMediaFileComplitionBlock)complition;


@end
