//
//  CPMediaDecryptTool.m
//  CPSecurityTools
//
//  Created by collegepre on 16/7/4.
//  Copyright © 2016年 collegepre. All rights reserved.
//

#import "CPMediaDecryptTool.h"

@interface CPMediaDecryptTool()
@property (copy,nonatomic) CPDecryptMediaFileProgressBlock progressBlock;
@property (copy,nonatomic) CPDecryptMediaFileComplitionBlock complitionBlock;

@property (copy,nonatomic) CPDecryptMediaFileComplitionBlock singleComplitionBlock;

// 接收数据的Data
@property (nonatomic, strong) NSData *readData;

// 文件长度
@property (nonatomic, assign,readonly) NSInteger  fileLength;

// 当前解密的文件长度
@property (nonatomic, assign) NSInteger  currnentLength;

// 线程控制
@property (nonatomic, strong) NSOperationQueue *oprationQ;

@end


@implementation CPMediaDecryptTool

- (NSOperationQueue *)oprationQ{
    if (!_oprationQ) {
        _oprationQ = [[NSOperationQueue alloc] init];
        _oprationQ.maxConcurrentOperationCount = 2;
    }
    return _oprationQ;
}


+ (instancetype)defaultDecryptTool{
    CPMediaDecryptTool *tool =  [[CPMediaDecryptTool alloc] init];
    
    tool.currnentLength = 0;
    tool.readData = [NSData data];
    return tool;
}

/**
 *  解密目录下所有的音视频文件
 *
 *  @param filePath   文件目录
 *  @param header     解密头
 *  @param key        解密码
 *  @param progress   进度block
 *  @param complition 完成调用的block
 */
- (void)decryptWithsuperFilePath:(NSString *)filePath headerLength:(NSString *)header keyValue:(NSString *)key progress:(CPDecryptMediaFileProgressBlock)progress complition:(CPDecryptMediaFileComplitionBlock)complition
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *arr = [manager subpathsAtPath:filePath];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *subPath in arr) {
        if ([self mediaTypeWithFilePath:subPath]) {
            NSString  *mediaPath = [filePath stringByAppendingPathComponent:subPath];
            [temp addObject:mediaPath];
        }
    }
    
    //    NSLog(@"dsadsa");
    
    __block NSInteger successNum = 0;
    for (int i = 0;i < temp.count;i++)
    {
        NSString *mediaPath = temp[i];
        
        NSBlockOperation *opration = [NSBlockOperation blockOperationWithBlock:^{
            if ([self mediaTypeWithFilePath:mediaPath]) {
                BOOL isSuc = [self addDecryptFileWithMediaPath:mediaPath index:i header:header.integerValue key:key.integerValue];
                NSLog(@"解密--%d",isSuc);
                if (isSuc) {
                    successNum++;
                    if (successNum == temp.count) {
                        NSError *error;
                        complition(error);
                    }else{
                        float pro = (float)successNum / temp.count;
                        progress(pro);
                    }
                }else{
                    NSError *error = [NSError errorWithDomain:@"解密文件失败..." code:101 userInfo:@{@"filePath":[filePath stringByAppendingPathComponent:mediaPath]}];
                    complition(error);
                    return;
                }
            }
        }];
        
        [self.oprationQ addOperation:opration];
    }
}


/**
 *  解密视音频文件
 *
 *  @param mediaPath 视音频文件路径
 *  @param index     数组中文件路径下标
 *
 *  @return 是否解密成功
 */
- (BOOL)addDecryptFileWithMediaPath:(NSString *)mediaPath index:(NSInteger)index  header:(NSInteger)header key:(NSInteger)key{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *subPath = mediaPath;
    // 文件类型
    NSString *pathExtension = [subPath pathExtension];
    
    // 视音频文件路径的前路径
    NSString *prePath = [subPath stringByDeletingLastPathComponent];
    
    // 当前文件名
    NSString *tempfilePath = [NSString stringWithFormat:@"%@/ios_temp_%ld.%@",prePath,index,pathExtension];
    [manager removeItemAtPath:tempfilePath error:nil];
    [manager createFileAtPath:tempfilePath contents:nil attributes:nil];
    
    // 创建读写FILE
    FILE *readFile;
    FILE *writeFile;
    readFile = fopen([subPath cStringUsingEncoding:NSUTF8StringEncoding], "rb+");
    writeFile = fopen([tempfilePath cStringUsingEncoding:NSUTF8StringEncoding], "a+");
    
    
    NSDictionary *attributes = [manager attributesOfItemAtPath:subPath error:nil];
    
    _fileLength = ((NSNumber *)[attributes objectForKey:@"NSFileSize"]).integerValue;
    
    int decodeKey = (int)key;
    if (self.fileLength > header) {
        self.currnentLength = header;
        BOOL isSuc =  decodeFile(readFile, self.fileLength, self.currnentLength, writeFile,decodeKey);
        if (isSuc) {
            if([manager removeItemAtPath:mediaPath error:nil]){
                isSuc =  [manager moveItemAtPath:tempfilePath toPath:mediaPath error:nil];
            }else{
                isSuc = NO;
            }
        }
        return isSuc;
    }else{
        return NO;
    }
}


/**
 *  C函数解密视频
 *
 *  @param file         待解密的文件File
 *  @param fileLength   文件长度
 *  @param currentLegth 当前解密的文件长度
 *  @param direcFile    目标存储目录
 */
BOOL decodeFile(FILE *file,long fileLength,long currentLegth,FILE *direcFile,int key){
    BOOL isSucessed;
    
    NSInteger readLength = 1024 * 1024 * 10;
    if (fileLength - currentLegth > readLength) {
        // 指针指向首字节
        //读取文件
        // 成功，返回0，失败返回-1
        int set = fseek(file, currentLegth, SEEK_SET);
        if (set == 0) {
            Byte *buffer = malloc(sizeof(Byte) * readLength);
            fread(buffer, readLength, sizeof(Byte), file);
            currentLegth += readLength;
            //设置读取位置
            
            printf("递归-fseek--%d\n",set);
            for (int i = 0 ; i < readLength; i++) {
                *(buffer + i ) -= key;
            }
            
            size_t writedData =  fwrite(buffer, sizeof(Byte), readLength, direcFile);
            if (writedData == readLength) {
                isSucessed = YES;
            }else{
                isSucessed = NO;
            }
            free(buffer);
            if (isSucessed) {
                return  decodeFile(file, fileLength, currentLegth,direcFile,key);
            }else{
                return isSucessed;
            }
            // 递归
        }
    }else{
        if(fileLength - currentLegth  > 0){
            long length = fileLength - currentLegth;
            int set = fseek(file, currentLegth, SEEK_SET);
            if (set == 0) {
                Byte *buffer = malloc(sizeof(Byte) * length);
                
                fread(buffer, length, sizeof(Byte), file);
                
                currentLegth += length;
                //设置读取位置
                for (int i = 0 ; i < length; i++) {
                    *(buffer + i ) -= key;
                }
                
                size_t writedData = fwrite(buffer, sizeof(Byte), length, direcFile);
                
                printf("最终-fseek--%d",set);
                if (writedData == length) {
                    isSucessed = YES;
                }else{
                    isSucessed = NO;
                }
                
                // 释放内存
                free(buffer);
                
                // 关闭文件
                fclose(file);
                fclose(direcFile);
                
            }
        }
    }
    return isSucessed;
}

/**
 *  解密当个文件的方法 <不可用 性能差>
 *
 *  @param filePath 单个文件的路径
 */
- (BOOL)decryptWithsubFilePath:(NSString *)filePath headerLength:(NSInteger)heder keyValue:(NSInteger)key{
    BOOL isSuccess = NO;
    if ([filePath hasSuffix:@".avi"]||[filePath hasSuffix:@".mp4"])
    {
        // 文件类型
        NSString *pathExtension = [filePath pathExtension];
        
        //        filePath = [filePath stringByDeletingPathExtension];
        
        NSString *currentName = [filePath lastPathComponent];
        filePath = [filePath stringByDeletingLastPathComponent];
        
        NSString *tempfilePath = [NSString stringWithFormat:@"%@/ios_temp.%@",filePath,pathExtension];
        filePath = [filePath stringByAppendingPathComponent:currentName];
        
        
        NSMutableData *data = [NSMutableData dataWithContentsOfFile:filePath];
        
        // 去除多余的头位置
        NSRange range = NSMakeRange(0, heder);
        [data replaceBytesInRange:range withBytes:NULL length:0];
        Byte *testByte = (Byte *)[data bytes];
        for(int i = 0 ;i < [data length]; i++ )
        {
            *(testByte + i) -= key;
        }
        
        isSuccess =  [data writeToFile:tempfilePath atomically:YES];
        if (isSuccess) {
            NSFileManager *fileManage = [NSFileManager defaultManager];
            BOOL isDelete =  [fileManage removeItemAtPath:filePath error:nil];
            if (isDelete) {
                isSuccess = [fileManage moveItemAtPath:tempfilePath toPath:filePath error:nil];
            }
        }
    }
    return isSuccess;
}


/**
 *  分段式解密视频目录  <不可用 性能差>
 *
 *  @param filePath 文件路径
 *  @param key      解密Key
 */
- (void)decryptMediaFilePieceWithFilePath:(NSString *)filePath header:(NSString *)header key:(NSString *)key complition:(CPDecryptMediaFileComplitionBlock)complition{
    
    if (complition) {
        self.singleComplitionBlock = ^(NSError *error){
            complition(error);
        };
    }
    complition = self.singleComplitionBlock;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDictionary *attributes = [manager attributesOfItemAtPath:filePath error:nil];
    
    //获取文件长度
    _fileLength = ((NSNumber *)[attributes objectForKey:@"NSFileSize"]).integerValue - header.integerValue;
    
    if (self.fileLength <= 0) {
        NSLog(@"文件字节数为空");
        return;
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSInteger readLength = 1024 * 1024 * 10;
    
    // 设置初始位置
    [fileHandle seekToFileOffset:42];
    
    // /Users/Wade/Library/Developer/CoreSimulator/Devices/A73C5ACF-81D4-46B9-A69B-F2830E90B2FB/data/Containers/Data/Application/972AACA2-9EF1-4ACD-B77C-984772D0E3D8/Documents/demo.mp4
    // 文件类型名  .mp4
    NSString *pathExtension = [filePath pathExtension];
    
    //filePath = [filePath stringByDeletingPathExtension];
    NSString *fileComponentPath = [filePath stringByDeletingLastPathComponent];
    
    NSString *directPath = [NSString stringWithFormat:@"%@/ios_temp.%@",fileComponentPath,pathExtension];;
    
    [manager removeItemAtPath:directPath error:nil];
    // 开始解密
    [manager createFileAtPath:directPath contents:nil attributes:nil];
    
    // 开始解密
    [self decodeDataWithFileHandle:fileHandle  readLength:readLength directPath:directPath filePath:filePath key:key];
}

/**
 *  视频文件递归解密  <不可用 性能差>
 *
 *  @param fileHandle   文件Hangle
 *  @param fileLength    文件长度
 *  @param currentLength 当前解密的长度
 *  @param readLength    每次解密的长度
 *  @param directPath   解密后目标目录
 */
- (void)decodeDataWithFileHandle:(NSFileHandle *)fileHandle readLength:(NSInteger)readLength directPath:(NSString *)directPath filePath:(NSString *)filePath key:(NSString *)key
{
    NSFileHandle *writeHandle =  [NSFileHandle fileHandleForWritingAtPath:directPath];
    if (self.fileLength - self.currnentLength >= readLength) {
        [fileHandle seekToFileOffset:self.currnentLength];
        self.currnentLength += readLength;
        NSData *data =  [fileHandle readDataOfLength:readLength];
        //        Byte *readByte1 = (Byte *)[data bytes];
        
        Byte *readByte = malloc(sizeof(Byte) * readLength);
        
        [data getBytes:readByte length:sizeof(Byte) * readLength];
        for(int i = 0 ;i < readLength; i++ )
        {
            *(readByte + i) -= key.integerValue;
        }
        
        NSData *deData = [NSData dataWithBytes:readByte length:readLength];
        
        [writeHandle seekToEndOfFile];
        [writeHandle writeData:deData];
        free(readByte);
        data = nil;
        deData = nil;
        // 递归
        [self decodeDataWithFileHandle:fileHandle readLength:readLength directPath:directPath filePath:filePath key:key];
        
    }else{
        NSFileManager *manger = [NSFileManager defaultManager];
        if (self.fileLength - self.currnentLength > 0) {
            [fileHandle seekToFileOffset:self.currnentLength];
            NSData *data =  [fileHandle readDataOfLength:self.fileLength - self.currnentLength];
            Byte *readByte = (Byte *)[data bytes];
            for(int i = 0 ;i < [data length]; i++ )
            {
                *(readByte + i) -= key.integerValue;
            }
            [writeHandle seekToEndOfFile];
            [writeHandle writeData:data];
            [writeHandle closeFile];
            [fileHandle closeFile];
            data = nil;
            [manger removeItemAtPath:filePath error:nil];
            
            BOOL isSuccess = [[NSFileManager defaultManager] moveItemAtPath:directPath toPath:filePath error:nil];
            NSError *error;
            if (isSuccess) {
                self.singleComplitionBlock(error);
            }else{
                error = [NSError errorWithDomain:@"替换文件失败" code:1001 userInfo:nil];
                self.singleComplitionBlock(error);
            }
            self.currnentLength = self.fileLength;
            
            
        }else{
            // 结束
            [writeHandle closeFile];
            [fileHandle closeFile];
            
            [manger removeItemAtPath:filePath error:nil];
            BOOL isSuccess = [manger moveItemAtPath:directPath toPath:filePath error:nil];
            NSError *error;
            if (isSuccess) {
                self.singleComplitionBlock(error);
            }else{
                error = [NSError errorWithDomain:@"替换文件失败" code:1001 userInfo:nil];
                self.singleComplitionBlock(error);
            }
            
        }
    }
}


/**
 *  根据文件路径判断媒体文件类型
 *
 *  @param filePath 文件路径
 *
 *  @return 媒体类型值
 */
- (CPMediaDecryptType)mediaTypeWithFilePath:(NSString *)filePath{
    if ([filePath hasSuffix:@".MP4"]||[filePath hasSuffix:@".mp4"]) {
        return CPMediaDecryptTypeMP4;
    }else if([filePath hasSuffix:@".MP3"]||[filePath hasSuffix:@".mp3"]){
        return CPMediaDecryptTypeMP3;
    }else if([filePath hasSuffix:@".AVI"]||[filePath hasSuffix:@".avi"]){
        return CPMediaDecryptTypeAVI;
    }else {
        return CPMediaDecryptTypeNone;
    }
}



@end
