//
//  ZJDirectorie.m
//  CRM
//
//  Created by mini on 16/9/27.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJDirectorie.h"
#import "ZJFMdb.h"
#import "ZJCustomerItemsTableInfo.h"

@implementation ZJDirectorie
//创建文件夹
///Users/mini/Library/Developer/CoreSimulator/Devices/98E9E9D3-EF21-44D0-9E4C-FFB764E11511/data/Containers/Data/Application/EFCE7794-D6C0-4A9F-92EA-292B4B260CB5/Documents.mycrm.db
+(void)crecteRootDirectoryWithPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [path stringByAppendingPathComponent:@"nologin"];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:filePath isDirectory:&isDir]) {
        //创建文件夹
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        //插入原始数据
        [ZJFMdb sqlInsertOriginalDate];

    }
}
//创建每个客户的文件夹
+(void)crecteCuetomerDirectoryName:(NSString *)name{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *imgPath= [NSString stringWithFormat:@"%@/nologin/%@/img",ZJDocumentPath,name];
        
    NSString *voicePath= [NSString stringWithFormat:@"%@/nologin/%@/voice",ZJDocumentPath,name];

    [fileManager createDirectoryAtPath:imgPath withIntermediateDirectories:YES attributes:nil error:nil];

    [fileManager createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
}

//录音问津存放文件夹
+(NSString *)getVoicePathWithDirectoryName:(NSString *)name{
    
    NSString *path = [NSString stringWithFormat:@"%@/nologin/%@/voice",ZJDocumentPath,name];
    return path;
}

//照片文件存放地址
+(NSString *)getImagePathWithDirectoryName:(NSString *)name{
    
    NSString *path = [NSString stringWithFormat:@"%@/nologin/%@/img",ZJDocumentPath,name];
    return path;
}

//创建文件
+(void)createFileWithPath:(NSString *)path fileName:(NSString *)name{
    
}

+(void)deleteDirWithPath:(NSString *)path;
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *dirPath = [NSString stringWithFormat:@"%@/nologin/%@",ZJDocumentPath,path];
    [fileManager removeItemAtPath:dirPath error:nil];
    
}


@end
