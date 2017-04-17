//
//  ZJPhotosTool.h
//  CRM
//
//  Created by mini on 16/9/27.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJSaveTool : NSObject

//照片地址
+(NSMutableArray *)zj_savePhotos:(NSMutableArray *)photosArray path:(NSString *)path UUIDName:(NSString *)UUID;
//头像地址
+(NSString *)zj_saveIconImg:(UIImage *)image path:(NSString *)path didChange:(BOOL)isChange;
//录音地址
+(void)zj_moveFileFromPath:(NSString *)path toPath:(NSString *)newPath fileName:(NSArray *)fileName;
//获取GUID
+(NSString *)zj_stringWithGUID;
@end
