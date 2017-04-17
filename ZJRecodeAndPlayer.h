//
//  ZJRecodeAndPlayer.h
//  CRM
//
//  Created by mini on 17/1/13.
//  Copyright © 2017年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ZJRecodeAndPlayer : NSObject

///配置录音文件
+(AVAudioRecorder *)disposeRecoder:(void(^)(NSString *error))errorMsg;
///配置播放器
+(AVAudioPlayer *)playRecodeWithPath:(NSString *)path;

//零时录音文件的路劲
+(NSString *)tempRecodePath;
@end
