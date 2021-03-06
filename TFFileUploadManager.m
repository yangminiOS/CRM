//
//  TFFileUploadManager.m
//  UploadFileTest
//
//  Created by shiwei on 16/2/21.
//  Copyright © 2016年 shiwei. All rights reserved.
//

#import "TFFileUploadManager.h"
#import <MobileCoreServices/UTType.h>

@implementation TFFileUploadManager{
    NSMutableURLRequest *request;
    NSOperationQueue *queue;
    NSURLConnection *_connection;
    NSMutableData *_reveivedData;
}

+(instancetype)shareInstance{
    static TFFileUploadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TFFileUploadManager alloc]init];
    });
    
    return manager;
}

-(void)uploadFileWithURL:(NSString *)urlString params:(NSDictionary *)params fileKey:(NSString *)fileKey filePath:(NSString *)filePath completeHander:(void (^)(NSURLResponse *, NSData *, NSError *))completeHander{
    
    NSURL *URL = [[NSURL alloc]initWithString:urlString];
    request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:30];
    NSString *boundary = @"wfWiEWrgEFA9A78512weF7106A";
    
    
    
    request.HTTPMethod = @"POST";
    request.allHTTPHeaderFields = @{
                                    @"Content-Type":[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary]
                                    };
    
    //multipart/form-data格式按照构建上传数据
    NSMutableData *postData = [[NSMutableData alloc]init];
    for (NSString *key in params) {
        NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",boundary,key];
        [postData appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
        
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [postData appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        }else if ([value isKindOfClass:[NSData class]]){
            [postData appendData:value];
        }
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //文件部分
    if (filePath != NULL) {
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        
        
        NSString *filename = [filePath lastPathComponent];
        NSString *contentType = AFContentTypeForPathExtension([filePath pathExtension]);
        
        NSString *filePair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\";\r\nContent-Type:%@\r\n\r\n",boundary,fileKey,filename,contentType];
        [postData appendData:[filePair dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:fileData];
    }

    
    
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        request.HTTPBody = postData;
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    
    _connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [_connection start];
}

#pragma mark - connection delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"reveive Response:\n%@",response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (!_reveivedData) {
        _reveivedData = [[NSMutableData alloc]init];

    }
    
    [_reveivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"received Data:\n%@",[[NSString alloc] initWithData:_reveivedData encoding:NSUTF8StringEncoding]);
    NSString *str = [[NSString alloc] initWithData:_reveivedData encoding:NSUTF8StringEncoding];
    NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    _reveivedData = NULL;
    if (dic == NULL) {
        NSString *error = @"网络异常，请稍后重试";
        self.username(error);
    }else {
     NSString *code = dic[@"code"];
     if ([code isEqualToString:@"0000"]) {
        NSString *temp = @"1111111";
        self.username(temp);
     }else if([code isEqualToString:@"1023"]){
       NSString *temp = @"token错误，请重新登录";
         
         self.username(temp);
         return;
     }else{
      NSString *msg = dic [@"msg"];
        self.username(msg);
      }
    }
    
}

-(NSString *)error:(NSString *)Temp{
    NSString *temp = Temp;
    return temp;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"fail connect:\n%@",error);
}




static inline NSString * AFContentTypeForPathExtension(NSString *extension) {
#ifdef __UTTYPE__
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
#else
#pragma unused (extension)
    return @"application/octet-stream";
#endif
}

@end
