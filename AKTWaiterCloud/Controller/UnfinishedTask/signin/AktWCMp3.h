//
//  AktWCMp3.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/7/26.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AktWCMp3 : NSObject

/*第二种方法录音 播放 加密*/
-(void)startRecordcase; // 开始录音
- (void)endRecord; //结束录音
- (void)playWav;   //开始播放音频文件
-(NSString *)recordToBASE64; // 源文件 加密
-(NSString *)recordmp3ToBASE64; // mp3 加密

@end

NS_ASSUME_NONNULL_END
