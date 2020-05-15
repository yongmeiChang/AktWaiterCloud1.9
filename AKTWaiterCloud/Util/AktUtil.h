//
//  AktUtil.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/7/26.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AktUtil : NSObject
// 获取 文件 路径 该目录保存文件需要标记 禁止同步 icloud
 + (NSString *)getDocumentPath:(NSString *)_fileName;
// 获取 缓存 路径 该目录保存文件不需要标记
+ (NSString *)getCachePath:(NSString *)_fileName;
// 获取 临时 路径 该目录保存文件 程序退出后会被清除
+ (NSString *)getTemPath:(NSString *)_fileName;

+ (NSString *)convertToMp3SouceFilePathName:(NSString *)pathName;  // 转换录音格式 mp3

// 获取当前时间
+(NSString *)getNowDateAndTime;
// 获取当前日期
+(NSString *)getNowDate;
// 截取日期格式
+(NSString *)rangeDate:(NSString *)Olddate;
// 截取日期和时间格式
+(NSString *)rangeDateAndTime:(NSString *)oldDateAndTime;

// 获取资源
+ (UIColor *)getColorFormResouce:(NSString *)key;
+ (UIFont *)getFontFormResouce:(NSString *)key;
// 对比版本号
+(BOOL)serviceOldCode:(NSString *)oldCode serviceNewCode:(NSString *)newCode;

+(NSDate *)StringtoDate:(NSString *)dateStr;

// 计算字符串的size
+ (CGSize)getNewTextSize:(NSString *)_text font:(int)_font limitWidth:(int)_width;

@end

NS_ASSUME_NONNULL_END
