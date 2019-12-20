//
//  SaveDocumentArray.h
//  AnKangTong
//
//  Created by juli on 2017/4/25.
//  Copyright © 2017年 www.3ti.us. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveDocumentArray : NSObject
/**
 初始化对象
 */
+ (SaveDocumentArray *)sharedInstance;
- (void)saveArray:(NSArray *)array;
- (NSArray *)read;

- (void)removefmdb;
- (void)deleteDocumentArray;

//沙盒存入数组
- (void)saveArray:(NSArray *)array FileName:(NSString *)fileName;
//读取沙盒数组
- (NSArray *)readFileName:(NSString *)fileName;
//删除文件
- (void)deleteFileName:(NSString *)fileName;
//删除录音文件
-(void)removeTrapWithName:(NSString *)trapName;
@end
