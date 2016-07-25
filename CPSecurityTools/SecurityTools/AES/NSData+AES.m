//
//  NSData+AES.h
//  Smile
//
//  Created by 周 敏 on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NSData+AES.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key 
{//加密
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + 100;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) 
    {
       return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

- (NSString *)AES256EncryptWithKeyString:(NSString *)key
{
//    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decry = [self AES256EncryptWithKey:key];
    NSString *descryStr = [[NSString alloc] initWithData:decry encoding:NSUTF8StringEncoding];
    return descryStr;
}



- (NSData *)AES256DecryptWithKey:(NSString *)key   //解密
{
    
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));

    BOOL suc = [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    if (!suc) return [NSData data];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + 100;
    void *buffer = malloc(bufferSize);
//    size_t numBytesEncrypted = 0;

    //同理，解密中，密钥也是32位的
//    const void *keyPtr2 = [key bytes];
//    char (*keyPtr)[32] = keyPtr2;
//    
//    //对于块加密算法，输出大小总是等于或小于输入大小加上一个块的大小
//    //所以在下边需要再加上一个块的大小
//    NSUInteger dataLength = [self length];
//    size_t bufferSize = dataLength + 32;
//    void *buffer = malloc(bufferSize);
//    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding/*这里就是刚才说到的PKCS7Padding填充了*/ | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,/* 初始化向量(可选) */
                                          [self bytes], dataLength,/* 输入 */
                                          buffer, bufferSize,/* 输出 */
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

- (NSString *)AES256DecryptWithKeyString:(NSString *)key
{
    if(self){
    NSData *decry = [self AES256DecryptWithKey:key];
    NSString *descryStr = [[NSString alloc] initWithData:decry encoding:NSUTF8StringEncoding];
    return descryStr;
    }
    else{
        return @"";
    }
}

@end
