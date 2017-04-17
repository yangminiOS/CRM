//
//  ZJDirectorie.h
//  CRM
//
//  Created by mini on 16/9/27.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJDirectorie : NSObject

//穿件根文件夹
+(void)crecteRootDirectoryWithPath:(NSString *)path;

//创建每个客户的文件夹
+(void)crecteCuetomerDirectoryName:(NSString *)name;

//录音问津存放地址
+(NSString *)getVoicePathWithDirectoryName:(NSString *)name;

//照片文件存放地址
+(NSString *)getImagePathWithDirectoryName:(NSString *)name;

//创建文件
+(void)createFileWithPath:(NSString *)path fileName:(NSString *)name;

//删除文件
+(void)deleteDirWithPath:(NSString *)path;


@end
