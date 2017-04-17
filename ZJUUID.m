//
//  ZJUUID.m
//  CRM
//
//  Created by 蒙建东 on 16/12/14.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJUUID.h"
#import "ZJKeyChainStore.h"
@implementation ZJUUID
+(NSString *)getUUID
{
    NSString * strUUID = (NSString *)[ZJKeyChainStore load:@"com.company.app.usernamepassword"];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [ZJKeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    return strUUID;
}
@end
