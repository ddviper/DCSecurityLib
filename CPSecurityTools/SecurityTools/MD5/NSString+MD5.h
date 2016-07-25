//
//  NSString+MD5.h
//  CPENDEcryptTools
//
//  Created by collegepre on 16/6/24.
//  Copyright © 2016年 collegepre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

/**
 *  字符串MD5加密
 *
 *  @return 加密后的MD5值
 */
- (NSString *)md5String;

/**
 *  计算文件大文件的MD5值
 *
 *  @param path       文件的路径
 *  @param dataLength 文件分段MD5加密的字节长
 *
 *  @return 文件的Md5值
 */
+ (NSString*)fileMD5withFilePath:(NSString*)path readingDataLength:(NSInteger)dataLength;


- (NSString *) sha1;


@end
