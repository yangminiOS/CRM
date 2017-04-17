//
//  ZJRecodeAndPlayer.m
//  CRM
//
//  Created by mini on 17/1/13.
//  Copyright © 2017年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJRecodeAndPlayer.h"

static AVAudioRecorder * _recoder = nil;

static AVAudioPlayer * _player = nil;

@implementation ZJRecodeAndPlayer


//配置录音文件

+(AVAudioRecorder *)disposeRecoder:(void(^)(NSString *error))errorMsg{
    
    
    if (!_recoder) {
        
        NSError *error;
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        
        if (error) {//扬声设备已坏
            
            NSString *errotText = @"扬声器设备损坏，无法正常录音";
            errorMsg(errotText);
            
        }else{//设备正常
            
            [session setActive:YES error:nil];
            [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            
            NSString *path = NSTemporaryDirectory();
            
            NSString *recodeName = @"tempRecode.caf";
            
            NSString *recodePath = [path stringByAppendingPathComponent:recodeName];
            
            NSMutableDictionary *setting = [NSMutableDictionary dictionary];
            
            setting[AVFormatIDKey] = @(kAudioFormatAppleIMA4);
            // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
            setting[AVSampleRateKey] = @(44100);
            // 音频通道数 1 或 2
            setting[AVNumberOfChannelsKey] = @(1);
            // 线性音频的位深度  8、16、24、32
            setting[AVLinearPCMBitDepthKey] = @(8);
            //录音的质量
            setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];
            
//            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:AVAudioQualityLow],AVEncoderAudioQualityKey,[NSNumber numberWithInt:16],AVEncoderBitRateKey,[NSNumber numberWithInt:2],AVNumberOfChannelsKey,[NSNumber numberWithFloat:44100.0],AVSampleRateKey,nil];
            
            _recoder = [[AVAudioRecorder alloc]initWithURL:[[NSURL alloc]initFileURLWithPath:recodePath isDirectory:YES] settings:setting error:nil];
            
            [_recoder recordForDuration:recordDuration];
            
            [_recoder prepareToRecord];

        }
        
    }
        
    return _recoder;
    
    
}

//播放器

+(AVAudioPlayer *)playRecodeWithPath:(NSString *)path{
    
    if (_player) {
        
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:path isDirectory:YES] error:nil];
    }
    return _player;
}


+(NSString *)tempRecodePath{
    
    NSString *path = NSTemporaryDirectory();
    
    NSString *recodeName = @"tempRecode.caf";
    
    NSString *recodePath = [path stringByAppendingPathComponent:recodeName];
    
    return recodePath;
    
}

@end
