//
//  ZJUser.h
//  CRM
//
//  Created by 蒙建东 on 16/12/1.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJUser : NSObject<NSCoding>
//名称
@property(nonatomic,copy)NSString *Name;
//头像图片
@property (nonatomic,strong)NSString *Head;
//性别
@property (nonatomic,copy)NSString *Sex;
//登录的类型
@property (nonatomic,copy)NSString *Logintype;
//手机号
@property (nonatomic,copy)NSString *Phone;
//城市
@property (nonatomic,copy)NSString *City;

@property (nonatomic,strong)UIImage *Image;


+(ZJUser *)shareUser;
@end
