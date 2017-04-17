//
//  TFFileUploadManager.h
//  UploadFileTest
//
//  Created by shiwei on 16/2/21.
//  Copyright © 2016年 shiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Myname)(NSString *name);
@interface TFFileUploadManager : NSObject<NSURLConnectionDataDelegate>
@property (nonatomic,strong)NSString *Error;
@property (nonatomic,copy)Myname username;
+(instancetype)shareInstance;

-(void)uploadFileWithURL:(NSString*)urlString params:(NSDictionary*)params fileKey:(NSString*)fileKey filePath:(NSString*)filePath completeHander:(void(^)(NSURLResponse *response, NSData *data, NSError *connectionError))completeHander;


-(NSString *)error:(NSString *)Temp;

@end
