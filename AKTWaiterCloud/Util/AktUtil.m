//
//  AktUtil.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/7/26.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AktUtil.h"
#import "FileManagerUtil.h"
#import "lame.h"

#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@implementation AktUtil

+ (NSString *)getDocumentPath:(NSString *)_fileName{
    NSString *documnetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documnetPath stringByAppendingPathComponent:_fileName];
}

+ (NSString *)getCachePath:(NSString *)_fileName{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [path stringByAppendingPathComponent:_fileName];
}

+ (NSString *)getTemPath:(NSString *)_fileName{
    NSString *tem = NSTemporaryDirectory();
    return [tem stringByAppendingPathComponent:_fileName];
}

+ (NSString *)convertToMp3SouceFilePathName:(NSString *)sourcePath isDeleteSourchFile:(BOOL)isDelete
{
    // 输入路径
    NSString *inPath = sourcePath;
    // 判断输入路径是否存在
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:sourcePath]) {
        NSLog(@"文件不存在");
    }
    // 输出路径
    NSString *outPath = [[sourcePath stringByDeletingPathExtension] stringByAppendingString:@".MP3"];
    @try {
        int read, write;
        
        FILE *pcm = fopen([inPath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([outPath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 8000);// 采样率
        lame_set_num_channels(lame, 2);//通道
        lame_set_quality(lame, 0);//质量
        lame_set_VBR(lame, vbr_default);
        lame_set_brate(lame, 8);
//        lame_set_mode(lame, 3);
        lame_init_params(lame);
        
        do {
            size_t size = (size_t)(2 * sizeof(short int));
            read = (int)fread(pcm_buffer, size, PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功:");
        if (isDelete) {
            
            NSError *error;
            [fm removeItemAtPath:sourcePath error:&error];
            if (error == nil) {
                NSLog(@"删除源文件成功");
            }
        }
        return outPath;
    }
}
#pragma mark - 获取时间
// 获取 当前毫秒
+(NSString *)getNowTimes{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}

// 获取当前时间 - 截止到秒
+(NSString *)getNowDateAndTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:date];
    return nowtimeStr;
}
// 获取当前日期
+(NSString *)getNowDate{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:date];
    return nowtimeStr;
}
// 截取日期格式
+(NSString *)rangeDate:(NSString *)Olddate{
    return [NSString stringWithFormat:@"%@年%@月%@日",[Olddate substringToIndex:4],[Olddate substringWithRange:NSMakeRange(5, 2)],[Olddate substringWithRange:NSMakeRange(8,2)]];
}
// 截取日期和时间格式
+(NSString *)rangeDateAndTime:(NSString *)oldDateAndTime{
     return [NSString stringWithFormat:@"%@年%@月%@日 %@时%@分",[oldDateAndTime substringToIndex:4],[oldDateAndTime substringWithRange:NSMakeRange(5, 2)],[oldDateAndTime substringWithRange:NSMakeRange(8,2)],[oldDateAndTime substringWithRange:NSMakeRange(11,2)],[oldDateAndTime substringWithRange:NSMakeRange(14,2)]];
}
#pragma mark - 文字 颜色 大小
+ (UIColor *)getColorFormResouce:(NSString *)key{
    NSString *colorStr = NSLocalizedStringFromTable(key, @"AKTColorString", @"");
    NSArray *colorAry = [colorStr componentsSeparatedByString:@","];
    return RGBACOLOR([colorAry[0] integerValue], [colorAry[1] integerValue], [colorAry[2] integerValue], [colorAry[3] integerValue]);
}

+ (UIFont *)getFontFormResouce:(NSString *)key{
    NSString *fontStr = NSLocalizedStringFromTable(key, @"AKTFontString", @"");
    NSArray *fontAry = [fontStr componentsSeparatedByString:@","];
    
    if ([fontAry[0] isEqualToString:@""])
        return [UIFont systemFontOfSize:[fontAry[1] floatValue]];
    else if ([fontAry[0] isEqualToString:@"B"])
        return [UIFont boldSystemFontOfSize:[fontAry[1] floatValue]];
    else
        return [UIFont fontWithName:fontAry[0] size:[fontAry[1] floatValue]];
}

#pragma mark - 对比版本号
+(BOOL)serviceOldCode:(NSString *)oldCode serviceNewCode:(NSString *)newCode{
    NSArray *aryOld = [oldCode componentsSeparatedByString:@"."];
    NSArray *aryNew = [newCode componentsSeparatedByString:@"."];
    /*
    if ([[aryNew objectAtIndex:0] integerValue]>[[aryOld objectAtIndex:0] integerValue]) {
        return NO;
    }else if([[aryNew objectAtIndex:0] integerValue]<[[aryOld objectAtIndex:0] integerValue]){
        return YES;
    }else{
        if ([[aryNew objectAtIndex:1] integerValue]>=[[aryOld objectAtIndex:1] integerValue]) {
            return NO;
        }else{
            return YES;
        }
    }*/
    if ([[aryNew objectAtIndex:0] integerValue]>[[aryOld objectAtIndex:0] integerValue]) {
        return NO;
    }else if ([[aryNew objectAtIndex:1] integerValue]>[[aryOld objectAtIndex:1] integerValue]){
        return NO;
    }else{
        if (aryNew.count == 3 && aryOld.count == 3) {
            if ([[aryNew objectAtIndex:2] integerValue]>=[[aryOld objectAtIndex:2] integerValue]){
                       return NO;
                   }else{
                       return YES;
                   }
        }else{
            if ([[aryNew objectAtIndex:1] integerValue]>=[[aryOld objectAtIndex:1] integerValue]){
                       return NO;
                   }else{
                       return YES;
                   }
        }
       
    }
}

#pragma mark - 日期
+(NSDate *)StringtoDate:(NSString *)dateStr{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSDate * date = [dateFormatter dateFromString:dateStr];
    return date;
}
#pragma mark -
+ (CGSize)getNewTextSize:(NSString *)_text font:(int)_font limitWidth:(int)_width{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont systemFontOfSize:_font];
    if (_font == 22)
        font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    NSDictionary *attribute = @{NSFontAttributeName:font, NSParagraphStyleAttributeName: paragraph};
    return [_text boundingRectWithSize:CGSizeMake(_width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
}

#pragma mark - 4.0APP时间相关判断
+(NSUInteger)isNewTimestatus:(NSString *)serviceEnd{ // 对比时间 是否正常 0：正常  1异常
    NSArray *aryService = [serviceEnd componentsSeparatedByString:@":"];
    NSArray *aryNowDate = [[self getNowDateAndTime] componentsSeparatedByString:@" "];
    NSArray *aryNowTime = [[aryNowDate objectAtIndex:1] componentsSeparatedByString:@":"];
    if ([[aryService objectAtIndex:0] integerValue]>=[[aryNowTime objectAtIndex:0] integerValue]) {
        return 0;
    }else if (([[aryService objectAtIndex:0] integerValue]>=[[aryNowTime objectAtIndex:0] integerValue]) && ([[aryService objectAtIndex:1] integerValue]>=[[aryNowTime objectAtIndex:1] integerValue])){
        return 0;
    }else if (([[aryService objectAtIndex:0] integerValue]>=[[aryNowTime objectAtIndex:0] integerValue]) && ([[aryService objectAtIndex:1] integerValue]>=[[aryNowTime objectAtIndex:1] integerValue]) &&([[aryService objectAtIndex:2] integerValue]>=[[aryNowTime objectAtIndex:2] integerValue])){
        return 0;
    }else{
        return 1;
    }
}
+(NSString *)getTimeFrom:(NSString *)bTime To:(NSString *)endDate{ // 计算差异的时间
    NSArray *aryBtime = [bTime componentsSeparatedByString:@":"];
    NSArray *aryEtime = [endDate componentsSeparatedByString:@":"];

    NSInteger Hours = labs([[aryBtime objectAtIndex:0] integerValue] - [[aryEtime objectAtIndex:0] integerValue]);
    NSInteger Miute = labs([[aryBtime objectAtIndex:1] integerValue] - [[aryEtime objectAtIndex:1] integerValue]);
    NSInteger Second = labs([[aryBtime objectAtIndex:2] integerValue] - [[aryEtime objectAtIndex:2] integerValue]);
    
    return [NSString stringWithFormat:@"%ld小时%ld分%ld秒",(long)Hours,(long)Miute,(long)Second];
}
// 两个时间段的差值  分钟单位
+(NSInteger)getTimeDifferenceValueFrome:(NSString *)from ToTime:(NSString *)to{
    NSArray * aryfromTime = [from componentsSeparatedByString:@":"];
    NSArray * arytoTime = [to componentsSeparatedByString:@":"];
    
    NSInteger fromH= [[NSString stringWithFormat:@"%@",aryfromTime[0]] integerValue];
    NSInteger fromM= [[NSString stringWithFormat:@"%@",aryfromTime[1]] integerValue];
//    NSInteger fromS= [[NSString stringWithFormat:@"%@",aryfromTime[2]] integerValue];
    
    NSInteger toH= [[NSString stringWithFormat:@"%@",arytoTime[0]] integerValue];
    NSInteger toM= [[NSString stringWithFormat:@"%@",arytoTime[1]] integerValue];
//    NSInteger toS= [[NSString stringWithFormat:@"%@",arytoTime[2]] integerValue];
    
    NSInteger timeAll = ((fromH-toH)*60)+(fromM-toM);
    
    return timeAll;
}
// 两个时间段的差值  秒单位
+(NSInteger)getTimeSDifferenceValueFrome:(NSString *)from ToTime:(NSString *)to{
    NSArray * aryfromTime = [from componentsSeparatedByString:@":"];
    NSArray * arytoTime = [to componentsSeparatedByString:@":"];
    
    NSInteger fromH= [[NSString stringWithFormat:@"%@",aryfromTime[0]] integerValue];
    NSInteger fromM= [[NSString stringWithFormat:@"%@",aryfromTime[1]] integerValue];
    NSInteger fromS= [[NSString stringWithFormat:@"%@",aryfromTime[2]] integerValue];
    
    NSInteger toH= [[NSString stringWithFormat:@"%@",arytoTime[0]] integerValue];
    NSInteger toM= [[NSString stringWithFormat:@"%@",arytoTime[1]] integerValue];
    NSInteger toS= [[NSString stringWithFormat:@"%@",arytoTime[2]] integerValue];
    
    NSInteger timeSAll = ((fromH-toH)*60)+((fromM-toM)*60)+(fromS-toS);
    
    return timeSAll;
}
// 秒转换成X时X分X秒
+(NSString *)secondChangeTime:(NSInteger)second{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",second/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(second%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",second%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@小时%@分%@秒",str_hour,str_minute,str_second];
    return format_time;
}
#pragma mark - 签出 出勤状态
+(NSUInteger)isstatus:(NSString *)serviceEnd{
    // 截止时间data格式
       NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
       [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
       NSDate *expireDate = [formatter dateFromString:serviceEnd];
       // 当前日历
       NSCalendar *calendar = [NSCalendar currentCalendar];
       // 需要对比的时间数据
       NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
       | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
       // 对比时间差
       NSDateComponents *dateCom = [calendar components:unit fromDate:expireDate toDate:[formatter dateFromString:[self getNowDateAndTime]] options:0];
       if(dateCom.year==0&&dateCom.month==0&&dateCom.day==0&&dateCom.hour==0&&dateCom.minute==0&&dateCom.second==0){// @"正常";
           return 0;
       }else{
           return 1;
       }
}

// 计算天数
+(NSInteger)getDaysFrom:(NSDate *)fromDate To:(NSDate *)endDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents    * comp = [calendar components:NSCalendarUnitDay
                                             fromDate:fromDate
                                                toDate:endDate
                                              options:NSCalendarWrapComponents];
//    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.day;
}
// 计算分钟
+(NSInteger)getMinuteFrom:(NSDate *)fromDate To:(NSDate *)endDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents * comp = [calendar components:NSCalendarUnitMinute
                                             fromDate:fromDate
                                                toDate:endDate
                                              options:NSCalendarWrapComponents];
//    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.minute;
}

// 计算秒
+(NSInteger)getSecondFrom:(NSDate *)fromDate To:(NSDate *)endDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents * comp = [calendar components:NSCalendarUnitSecond
                                             fromDate:fromDate
                                                toDate:endDate
                                              options:NSCalendarWrapComponents];
//    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.second;
}
// 任务签入、签出 出勤状态
+ (NSString *)NowDate:(NSDate *)nowdate ServiceEndTime:(NSString *)serviceend{
    // 截止时间data格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expireDate = [formatter dateFromString:serviceend];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:expireDate toDate:[formatter dateFromString:[self getNowDateAndTime]] options:0];
    
    if ([self isstatus:serviceend] == 0) { // 正常
        return @"正常";
    }else{
        NSString *strDay = [NSString stringWithFormat:@"%ld",[self getDaysFrom:nowdate To:expireDate]];
        NSString *strHours = [NSString stringWithFormat:@"%ld",(long)dateCom.hour];
        NSString *strMiute = [NSString stringWithFormat:@"%ld",(long)dateCom.minute];
        NSString *strSecond = [NSString stringWithFormat:@"%ld",(long)dateCom.second];
             
        if ([strDay containsString:@"-"]) {
            strDay = [strDay substringFromIndex:1];
        }
        if ([strHours containsString:@"-"]) {
            strHours = [strHours substringFromIndex:1];
        }
        if ([strMiute containsString:@"-"]) {
            strMiute = [strMiute substringFromIndex:1];
        }
        if ([strSecond containsString:@"-"]) {
            strSecond = [strSecond substringFromIndex:1];
        }
        
        NSString *strnewDay;
        NSString *strnewHours;
        NSString *strnewMiute;
        NSString *strNewSecond;
        
        if ([self getDaysFrom:nowdate To:expireDate] == 0) {
            strnewDay = @"";
        }else{
            strnewDay = [NSString stringWithFormat:@"%@天",strDay];
        }
        if ([strHours integerValue] == 0) {
            strnewHours = @"";
        }else{
            strnewHours = [NSString stringWithFormat:@"%@时",strHours];
        }
        if ([strMiute integerValue] == 0) {
            strnewMiute = @"";
        }else{
            strnewMiute = [NSString stringWithFormat:@"%@分",strMiute];
        }
        if ([strSecond integerValue] == 0) {
            strNewSecond = @"";
        }else{
            strNewSecond = [NSString stringWithFormat:@"%@秒",strSecond];
        }
        return [NSString stringWithFormat:@"%@%@%@%@",strnewDay,strnewHours,strnewMiute,strNewSecond];
    }
}
// 实际服务时长 格式：3天2小时23分22秒
+ (NSString *)actualBeginTime:(NSString *)begindate actualServiceEndTime:(NSString *)serviceend{
    // 截止时间data格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expireDate = [formatter dateFromString:serviceend];
    
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:expireDate toDate:[formatter dateFromString:begindate] options:0];
    
    
    NSString *strDay = [NSString stringWithFormat:@"%ld",(long)[self getDaysFrom:[formatter dateFromString:begindate] To:expireDate]];
        NSString *strHours = [NSString stringWithFormat:@"%ld",(long)dateCom.hour];
        NSString *strMiute = [NSString stringWithFormat:@"%ld",(long)dateCom.minute];
        NSString *strSecond = [NSString stringWithFormat:@"%ld",(long)dateCom.second];
             
        if ([strDay containsString:@"-"]) {
            strDay = [strDay substringFromIndex:1];
        }
        if ([strHours containsString:@"-"]) {
            strHours = [strHours substringFromIndex:1];
        }
        if ([strMiute containsString:@"-"]) {
            strMiute = [strMiute substringFromIndex:1];
        }
        if ([strSecond containsString:@"-"]) {
            strSecond = [strSecond substringFromIndex:1];
        }
        
        NSString *strnewDay;
        NSString *strnewHours;
        NSString *strnewMiute;
        NSString *strNewSecond;
        
        if ([self getDaysFrom:[formatter dateFromString:begindate] To:expireDate] == 0) {
            strnewDay = @"";
        }else{
            strnewDay = [NSString stringWithFormat:@"%@天",strDay];
        }
        if ([strHours integerValue] == 0) {
            strnewHours = @"";
        }else{
            strnewHours = [NSString stringWithFormat:@"%@时",strHours];
        }
        if ([strMiute integerValue] == 0) {
            strnewMiute = @"";
        }else{
            strnewMiute = [NSString stringWithFormat:@"%@分",strMiute];
        }
        if ([strSecond integerValue] == 0) {
            strNewSecond = @"";
        }else{
            strNewSecond = [NSString stringWithFormat:@"%@秒",strSecond];
        }
        return [NSString stringWithFormat:@"%@%@%@%@",strnewDay,strnewHours,strnewMiute,strNewSecond];
    
}

//比较日期大小
+(int)compareDate:(NSDate *)bdate End:(NSDate *)edate{
    NSComparisonResult result = [bdate compare:edate];
    NSLog(@"date1 : %@, date2 : %@", bdate, edate);
    //1 a>b  0 a=b  -1 a<b
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result == NSOrderedAscending){
        return -1;
    }
        return 0;
}

+ (BOOL)dx_isNullOrNilWithObject:(id)object;
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}

#pragma mark - 时间格式转换 2:2:2change 02:02:02
+(NSString *)HoursChange:(NSString *)hours{
    NSString *strH = [NSString stringWithFormat:@"%@",hours];
    if (strH.length == 1) {
        strH = [NSString stringWithFormat:@"0%@",strH];
    }else{
        strH = [NSString stringWithFormat:@"%@",strH];
    }
    return strH;
}

#pragma mark - 正则相关
+(BOOL)isValidateByRegex:(NSString *)regex Param:(NSString *)param{
     NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:param];
}
//手机号分服务商
+(BOOL)isMobileNumberClassification:(NSString *)param{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
    */
//    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186,1709
     */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189,1700
     */
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (([self isValidateByRegex:CM Param:param])
        || ([self isValidateByRegex:CU Param:param])
        || ([self isValidateByRegex:CT Param:param])
        || ([self isValidateByRegex:PHS Param:param])){
           return YES;
        }
    else{
        return NO;
    }
}

//手机号有效性
+(BOOL)isMobileNumber:(NSString *)mobile{
    NSString *regex = @"^((1[0-9][0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    BOOL isMatch = [self isValidateByRegex:regex Param:mobile];
    return isMatch;
}
// 获取当前版本号
+(NSString *)GetAppVersion{
    NSString *versionNow=[[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleShortVersionString"];
    return versionNow;
}

//电话号码与手机号码同时验证
+(BOOL)checkTelNumberAndPhone:(NSString *)tel
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^((1[3|5|7|8|9]\\d{9})|(0\\d{2,3}-\\d{7,8}))$" options:0 error:nil];
    NSTextCheckingResult *r = [regex firstMatchInString:tel options:0 range:NSMakeRange(0, tel.length)];
    return r != nil;
}
//邮箱验证
+(BOOL)checkEmail:(NSString *)email
{
    // [A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}  //^\\w+@\\w+\\.[a-zA-Z]+(\\.[a-zA-Z]+)?$
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" options:0 error:nil];
    NSTextCheckingResult *r = [regex firstMatchInString:email options:0 range:NSMakeRange(0, email.length)];
    return r != nil;
}


@end
