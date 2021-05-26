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

@interface AktWCMp3 ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
   BOOL isclickStop; // 录音是否停止
    AVAudioPlayer * player;//必须为全局变量
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
          self.filePathname = [AktUtil convertToMp3SouceFilePathName:self.filePathname isDeleteSourchFile:NO];
      }
    NSData *mp3Data = [NSData dataWithContentsOfFile:self.filePathname];
    NSString *_encodedImageStr = [mp3Data base64Encoding];
    NSLog(@"===Encoded MP3:\n%@  \n data:%@",_encodedImageStr,mp3Data);
    return _encodedImageStr;
}

#pragma mark - mp3 case2
-(void)startRecordcase{
    //删除上次生成的文件，保留最新文件
   NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([NSTemporaryDirectory() stringByAppendingString:@"myselfRecord.mp3"]) {
        [fileManager removeItemAtPath:[NSTemporaryDirectory() stringByAppendingString:@"myselfRecord.mp3"] error:nil];
      }
   //默认就是wav格式，是无损的
if ([fileManager fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"recordAudio.wav"]]) {
    [fileManager removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"recordAudio.wav"] error:nil];
    
}
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
   //设置录音格式 AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
   //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）, 采样率必须要设为11025才能使转化成mp3格式后不会失真
     [recordSetting setValue:[NSNumber numberWithFloat:16000] forKey:AVSampleRateKey];
     //录音通道数 1 或 2 ，要转换成mp3格式必须为双通道
     [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
 //线性采样位数 8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
[recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
// 设置录制音频采用高位优先的记录格式
[recordSetting setValue:[NSNumber numberWithBool:YES] forKey:AVLinearPCMIsBigEndianKey];
// 设置采样信号采用浮点数
[recordSetting setValue:[NSNumber numberWithBool:YES] forKey:AVLinearPCMIsFloatKey];
//存储录音文件
NSURL * recordUrl = [NSURL URLWithString:[NSTemporaryDirectory()stringByAppendingPathComponent:@"recordAudio.wav"]];
//初始化录音对象
    NSError * error;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordUrl settings:recordSetting error:&error];

if (error) {

NSLog(@"%@",error.description);
return;
}
    self.audioRecorder.delegate = self;
    //开启音量检测
    self.audioRecorder.meteringEnabled = YES;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];//得到音频会话单例对象
    //如果不是正在录音
    if (![self.audioRecorder isRecording]) {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//设置类别,表示该应用同时支持播放和录音
        [audioSession setActive:YES error:nil];//激活当前应用的音频会话,此时会阻断后台音乐的播放.
        [self.audioRecorder prepareToRecord];//准备录音
        [self.audioRecorder record];//开始录音
        //暂停录音

   //        [audioRecorder pause];
        
    }
}

//结束录音
- (void)endRecord
{
    [self.audioRecorder stop];  //录音停止
}

//录音结束后代理

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{

[[AVAudioSession sharedInstance] setActive:NO error:nil];//一定要在录音停止以后再关闭音频会话管理（否则会报错），此时会延续后台音乐播放

if (!flag) return;
    
}

//开始播放音频文件

- (void)playWav{

//获取音频文件url
//  NSURL * url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"recordAudio.wav"]];
//获取录音数据
NSData * wavData = [NSData dataWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"recordAudio.wav"]];
NSError * error;
//    AVAudioPlayer * player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
player = [[AVAudioPlayer alloc]initWithData:wavData error:&error];
    player.delegate = self;
    if (error) {
    NSLog(@"语音播放失败,%@",error);
    return;

}

//播放器的声音会自动切到receiver，所以听起来特别小，如果需要从speaker出声，需要自己设置。

[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];

// 单独设置音乐的音量（默认1.0，可设置范围为0.0至1.0，两个极端为静音、系统音量）：
player.volume = 1.0;

//    修改左右声道的平衡（默认0.0，可设置范围为-1.0至1.0，两个极端分别为只有左声道、只有右声道）：
player.pan = -1;

//    设置播放速度（默认1.0，可设置范围为0.5至2.0，两个极端分别为一半速度、两倍速度）：
player.rate = 2.0;

//    设置循环播放（默认1，若设置值大于0，则为相应的循环次数，设置为-1可以实现无限循环）：
player.numberOfLoops = 0;
//    player.currentTime = 0;
//调用prepareToPlay方法，这样可以提前获取需要的硬件支持，并加载音频到缓冲区。在调用play方法时，减少开始播放的延迟。
[player prepareToPlay];

//    开始播放音乐：
[player play];
}

//播放完成代理

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
NSLog(@"停止播放");
//调用pause或stop来暂停播放，这里的stop方法的效果也只是暂停播放，不同之处是stop会撤销prepareToPlay方法所做的准备。
[player stop];
player = nil;
    }
}
#pragma mark - 加密
-(NSString *)recordToBASE64; // 源文件 base64转码
{
    NSData * wavData = [NSData dataWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"recordAudio.wav"]];
    NSString * encodedRecordStr = [wavData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedRecordStr;
}
-(NSString *)recordmp3ToBASE64; // mp3 加密
{
//    NSData * wavData = [NSData dataWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"recordAudio.wav"]]; // 获取录音文件

    NSString *strdatamp3 = [AktUtil convertToMp3SouceFilePathName:[NSTemporaryDirectory() stringByAppendingPathComponent:@"recordAudio.wav"] isDeleteSourchFile:YES]; // 转成MP3
    NSData *mp3Data = [NSData dataWithContentsOfFile:strdatamp3];
    
    NSString * encodedRecordStr = [mp3Data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedRecordStr;
}

@end
