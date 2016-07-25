//
//  NSData+AES.h
//  Smile
//
//  Created by 周 敏 on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)
/**
 *  解密
 */
- (NSString *)AES256DecryptWithKeyString:(NSString *)key; //解密
/**
 *  加密
 */
- (NSData *)AES256EncryptWithKey:(NSString *)key;


/**
 *  NSData解密成NSData
 *
 *  @param key
 *
 *  @return 解密后的字符串
 */
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
