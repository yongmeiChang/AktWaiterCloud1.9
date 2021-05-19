//
//  AktWCMp3.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/7/26.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AktWCMp3.h"
#import <AVFoundation/AVFoundation.h>
#import "SaveDocumentArray.h"
#import "FileManagerUtil.h"

@interface AktWCMp3 ()<AVAudioRecorderDelegate>
{
   BOOL isclickStop; // 录音是否停止
}
@property (nonatomic,strong) AVAudioRecorder * audioRecorder;
@property (nonatomic,strong) NSString *filePathname;//录音文件保存名称

@end

@implementation AktWCMp3
-(void)startRecordMp3FilePathName; // 开始录音
{
    self.filePathname = [[NSString alloc] init]; // 初始化文件路径
    
    if(isclickStop){
        [[SaveDocumentArray sharedInstance] readFileName:_filePathname];
        isclickStop = false;
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    /*
     AVAudioSessionCategoryPlayAndRecord :录制和播放
     AVAudioSessionCategoryAmbient       :用于非以语音为主的应用,随着静音键和屏幕关闭而静音.
     AVAudioSessionCategorySoloAmbient   :类似AVAudioSessionCategoryAmbient不同之处在于它会中止其它应用播放声音。
     AVAudioSessionCategoryPlayback      :用于以语音为主的应用,不会随着静音键和屏幕关闭而静音.可在后台播放声音
     AVAudioSessionCategoryRecord        :用于需要录音的应用,除了来电铃声,闹钟或日历提醒之外的其它系统声音都不会被播放,只提供单纯录音功能.
     */
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    [session setActive:YES error:nil];
    
    // 录音参数
    NSDictionary *setting = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,// 编码格式
                             [NSNumber numberWithFloat:8000], AVSampleRateKey, //采样率
                             [NSNumber numberWithInt:2], AVNumberOfChannelsKey, //通道数
                             [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,  //采样位数(PCM专属)
                             [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,  //是否允许音频交叉(PCM专属)
                             [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,  //采样信号是否是浮点数(PCM专属)
                             [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,  //是否是大端存储模式(PCM专属)
                             [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,  //音质
                             nil];
    
    self.audioRecorder.delegate = self;
    //开启音频测量
    self.audioRecorder.meteringEnabled = YES;
    
    //保存路径
    NSString * DocumentfilePath = [[FileManagerUtil sharedTool] getDocumentPath];
    NSString *filePath = [NSString stringWithFormat:@"%@/tempAudio/",DocumentfilePath];
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd hh:dd:ss";//指定转date得日期格式化形式
    NSString * Date = [dateFormatter stringFromDate:date];
    Date = [Date stringByReplacingOccurrencesOfString:@":" withString:@""];
    //年月日_时分秒
    Date = [Date stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString * filename = [NSString stringWithFormat:@"%@%@.wav",[LoginModel gets].uuid,Date];
    
    self.filePathname = [filePath stringByAppendingString:filename];
    [[FileManagerUtil sharedTool] createDirectoryAtPath:filePath];
    NSURL * url =  [NSURL URLWithString:_filePathname];
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
    
    if (_audioRecorder) {
        _audioRecorder.meteringEnabled = YES;
        [_audioRecorder prepareToRecord];
        [_audioRecorder record];
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
    // 保存路径
    [[NSUserDefaults standardUserDefaults] setObject:self.filePathname forKey:@"filePathName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)stopRecordMp3FilePathName;  // 结束录音
{
    NSLog(@"停止录音");
    isclickStop = YES;
    if ([_audioRecorder isRecording]) {
        [_audioRecorder stop];
    }
}
#pragma mark - mp3转字符串
-(NSString *)mp3ToBASE64{
    self.filePathname = [[NSUserDefaults standardUserDefaults] objectForKey:@"filePathName"];
     if ([_filePathname isEqualToString:@"nil"] || [_filePathname isKindOfClass:[NSNull class]] || _filePathname.length ==0) {

      }else{
          self.filePathname = [AktUtil convertToMp3SouceFilePathName:self.filePathname];
      }
    NSData *mp3Data = [NSData dataWithContentsOfFile:self.filePathname];
    NSString *_encodedImageStr = [mp3Data base64Encoding];
    NSLog(@"===Encoded MP3:\n%@  \n data:%@",_encodedImageStr,mp3Data);
    return _encodedImageStr;
}

@end
