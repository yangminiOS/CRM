//
//  ZJKeyChainStore.h
//  CRM
//
//  Created by 蒙建东 on 16/12/14.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJKeyChainStore : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;
@end
