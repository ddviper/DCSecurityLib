//
//  ViewController.m
//  CPSecurityTools
//
//  Created by collegepre on 16/7/4.
//  Copyright © 2016年 collegepre. All rights reserved.
//

#import "ViewController.h"
#import "CPSecurityTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
    [[CPMediaDecryptTool defaultDecryptTool] decryptWithsuperFilePath:path headerLength:@"42" keyValue:@"111" progress:^(float progress) {
        
    } complition:^(NSError *error) {
        NSLog(@"机密完成--%@",error);
    }];
}

- (void)test{
    
    //  设置文件流的缓冲区
//    setbuffer(<#FILE *#>, <#char *#>, <#int#>)
    //    重设文件流的读写位置为文件开头
//    rewind(<#FILE *#>)
    
    //  写文件函数(将数据流写入文件中)
//    fwrite(<#const void *restrict#>, <#size_t#>, <#size_t#>, <#FILE *restrict#>)
    //      移动文件流的读写位置
//    fseek(<#FILE *#>, <#long#>, <#int#>)
    
    // 打开文件函数，并获得文件句柄
//    freopen(<#const char *restrict#>, <#const char *restrict#>, <#FILE *restrict#>)
    
//    fread()         读文件函数(从文件流读取数据)
//    fread(<#void *restrict#>, <#size_t#>, <#size_t#>, <#FILE *restrict#>)
    
//    fopen()        文件打开函数(结果为文件句柄
//    fopen(<#const char *restrict#>, <#const char *restrict#>)
    
//    fflush()        更新缓冲区
//    fflush(<#FILE *#>)
    
//    feof()          检查文件流是否读到了文件尾
//    feof(<#FILE *#>)
    
//    fclose()        关闭打开的文件
//    fclose(<#FILE *#>)
    
//    write()         写文件函数
//    sync()         写文件函数(将缓冲区数据写回磁盘)
//    write(<#int#>, <#const void *#>, <#size_t#>)
//    sync()
    
//    read()         读文件函数(由已打开的文件读取数据)
//    read(<#int#>, <#void *#>, <#size_t#>)
//    lseek()        移动文件的读写位置
//    lseek(<#int#>, <#off_t#>, <#int#>)
//    fsync()        将缓冲区数据写回磁盘
//    fsync(<#int#>)
    
//    creat()         创建文件函数
//    close()         关闭文件
//    creat(<#const char *#>, <#mode_t#>)
//    close(<#int#>)
}

- (void)filetest{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"demo"];
    
    [[CPMediaDecryptTool defaultDecryptTool] decryptWithsuperFilePath:path headerLength:@"42" keyValue:@"111" progress:^(float progress) {
        NSLog(@"%f",progress);
    } complition:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
