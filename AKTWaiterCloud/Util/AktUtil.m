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
+ (NSString *)convertToMp3SouceFilePathName:(NSString *)pathName
{
    // 文件路径
    NSString * DocumentfilePath = [[FileManagerUtil sharedTool] getDocumentPath];
    NSString *filePathOld = [NSString stringWithFormat:@"%@/tempAudio/",DocumentfilePath];
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd hh:dd:ss";//指定转date得日期格式化形式
    NSString * Date = [dateFormatter stringFromDate:date];
    Date = [Date stringByReplacingOccurrencesOfString:@":" withString:@""];
    //年月日_时分秒
    Date = [Date stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@.mp3", appDelegate.userinfo.id,Date];
    NSString *filePath = [filePathOld stringByAppendingString:fileName];
    NSLog(@"%@",filePath);
    
    @try {
        int read,write;
        //只读方式打开被转换音频文件
        FILE *pcm = fopen([pathName cStringUsingEncoding:1], "rb");
        fseek(pcm, 4 * 1024, SEEK_CUR);//删除头，否则在前一秒钟会有杂音
        //只写方式打开生成的MP3文件
        FILE *mp3 = fopen([filePath cStringUsingEncoding:1], "wb");
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        //这里要注意，lame的配置要跟AVAudioRecorder的配置一致，否则会造成转换不成功
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 8000);//采样率
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            
            //以二进制形式读取文件中的数据
            read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            //二进制形式写数据到文件中  mp3_buffer：数据输出到文件的缓冲区首地址  write：一个数据块的字节数  1:指定一次输出数据块的个数   mp3:文件指针
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
        
    } @catch (NSException *exception) {
        NSLog(@"======%@",[exception description]);
    } @finally {
        NSLog(@"MP3生成成功!!! %@",filePath);
        return filePath;
    }
}

// 获取当前时间
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

+(BOOL)serviceOldCode:(NSString *)oldCode serviceNewCode:(NSString *)newCode{
    NSArray *aryOld = [oldCode componentsSeparatedByString:@"."];
    NSArray *aryNew = [newCode componentsSeparatedByString:@"."];
    if ([[aryNew objectAtIndex:0] integerValue]>[[aryOld objectAtIndex:0] integerValue]) {
        return NO;
    }else if([[aryNew objectAtIndex:0] integerValue]<[[aryOld objectAtIndex:0] integerValue]){
        return YES;
    }else{
        if ([[aryNew objectAtIndex:1] integerValue]>[[aryOld objectAtIndex:1] integerValue]) {
            return NO;
        }else{
            return YES;
        }
    }
}

+(NSDate *)StringtoDate:(NSString *)dateStr{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-mm-dd hh:mm:ss";
    NSDate * date = [dateFormatter dateFromString:dateStr];
    return date;
}

+ (CGSize)getNewTextSize:(NSString *)_text font:(int)_font limitWidth:(int)_width{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont systemFontOfSize:_font];
    if (_font == 22)
        font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    NSDictionary *attribute = @{NSFontAttributeName:font, NSParagraphStyleAttributeName: paragraph};
    return [_text boundingRectWithSize:CGSizeMake(_width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
}

@end
