//
//  FileManagerUtil.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/12.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "FileManagerUtil.h"
@implementation FileManagerUtil

static FileManagerUtil * a_instance = nil;

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        a_instance = [[self alloc] init];
    });
    return a_instance;
}

-(NSString *)getDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    return documentDirectory;
}

-(void)createDirectoryAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSLog(@"first run");
//        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        NSString *directryPath = [path stringByAppendingPathComponent:@"imageViews"];
//        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
//        NSString *filePath = [directryPath stringByAppendingPathComponent:@"test.plist"];
//        NSLog(@"%@",filePath);
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

-(void)createFileAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}
@end
