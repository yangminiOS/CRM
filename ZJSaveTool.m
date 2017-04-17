//
//  ZJPhotosTool.m
//  CRM
//
//  Created by mini on 16/9/27.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJSaveTool.h"

@implementation ZJSaveTool
//照片地址
+(NSMutableArray *)zj_savePhotos:(NSMutableArray *)photosArray path:(NSString *)path UUIDName:(NSString *)UUID{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *array = [NSMutableArray array];
    NSString *picturePath = nil;
    NSString *imgName = nil;
    for (NSInteger i = 0; i< photosArray.count;i++ ) {
        UIImage *img = photosArray[i];
            
        NSData *dataImg = UIImageJPEGRepresentation(img, 0.7);
        imgName = [NSString stringWithFormat:@"img%@%zd.jpg",UUID,i];
        picturePath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",imgName]];
        
        [fileManager createFileAtPath:picturePath contents:dataImg attributes:nil];
        [array addObject:imgName];

    }
    return array;
    
}

//头像地址
+(NSString *)zj_saveIconImg:(UIImage *)image path:(NSString *)path didChange:(BOOL)isChangeIcon{
    
    if (!isChangeIcon)return @"";
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSData *dataImg = UIImageJPEGRepresentation(image, 0.7);
    NSString *iconPath = [path stringByAppendingString:@"/icon.png"];
    
    [fileManager createFileAtPath:iconPath contents:dataImg attributes:nil];

    
    return @"icon.png";
}

//录音地址
+(void)zj_moveFileFromPath:(NSString *)path toPath:(NSString *)newPath fileName:(NSArray *)fileName{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSInteger i = 0; i<fileName.count; i++) {
        
        NSString *oldFile = [path stringByAppendingPathComponent:fileName[i]];
        NSString *newFile = [newPath stringByAppendingPathComponent:fileName[i]];
        [fileManager moveItemAtPath:oldFile toPath:newFile error:nil];
    }
}
//获取GUID
+(NSString *)zj_stringWithGUID{
    
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *UUIDString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return UUIDString;
}

@end
