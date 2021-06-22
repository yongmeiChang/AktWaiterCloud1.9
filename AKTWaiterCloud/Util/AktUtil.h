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

+ (NSString *)convertToMp3SouceFilePathName:(NSString *)sourcePath isDeleteSourchFile:(BOOL)isDelete;  // 转换录音格式 mp3
// 获取 当前毫秒
+(NSString *)getNowTimes;
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

// 任务签入、签出 出勤状态
+(NSInteger)getDaysFrom:(NSDate *)fromDate To:(NSDate *)endDate;
// 计算分钟
+(NSInteger)getMinuteFrom:(NSDate *)fromDate To:(NSDate *)endDate;
+(NSInteger)getSecondFrom:(NSDate *)fromDate To:(NSDate *)endDate;// 计算秒
+(NSUInteger)isstatus:(NSString *)serviceEnd;
+ (NSString *)NowDate:(NSDate *)nowdate ServiceEndTime:(NSString *)serviceend;
// 实际服务时长 格式：3天2小时23分22秒
+ (NSString *)actualBeginTime:(NSString *)begindate actualServiceEndTime:(NSString *)serviceend;
//比较日期大小
+(int)compareDate:(NSDate *)bdate End:(NSDate *)edate;
/**4.0 时间计算**/
+(NSUInteger)isNewTimestatus:(NSString *)serviceEnd; // 对比时间是否异常 1异常
+(NSString *)getTimeFrom:(NSString *)bTime To:(NSString *)endDate; // 计算差异的时间
+(NSInteger)getTimeDifferenceValueFrome:(NSString *)from ToTime:(NSString *)to; // 两个时间段相差分钟
// 两个时间段的差值  秒单位
+(NSInteger)getTimeSDifferenceValueFrome:(NSString *)from ToTime:(NSString *)to;
// 秒转换成X时X分X秒
+(NSString *)secondChangeTime:(NSInteger)second;

/**判断对象是否为空
 *  PS：nil、NSNil、@""、@0 以上4种返回YES
 *  @return YES 为空  NO 为实例对象
 */
+ (BOOL)dx_isNullOrNilWithObject:(id)object;

#pragma mark - 时间格式转换 2:2:2change 02:02:02
+(NSString *)HoursChange:(NSString *)hours;

#pragma mark - 正则相关
+(BOOL)isValidateByRegex:(NSString *)regex Param:(NSString *)param;
//手机号分服务商
+(BOOL)isMobileNumberClassification:(NSString *)param;
//手机号有效性
+(BOOL)isMobileNumber:(NSString *)mobile;
// 获取APP版本号
+(NSString *)GetAppVersion;
//电话号码与手机号码同时验证
+(BOOL)checkTelNumberAndPhone:(NSString *)tel;
//邮箱验证
+(BOOL)checkEmail:(NSString *)email;
// 图片压缩
+ (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize;

@end

NS_ASSUME_NONNULL_END
