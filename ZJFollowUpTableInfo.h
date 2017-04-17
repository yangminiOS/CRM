//
//  CRMFollowUp.h
//  CRM
//
//  Created by 杨敏 on 16/9/1.
//  Copyright © 2016年 mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJFollowUpTableInfo : NSObject

//**自增长唯一标识符**//
@property(nonatomic,assign)NSInteger iAutoID;

//**对应的客户标号**//
@property(nonatomic,assign)NSInteger iCustomerID;

//**跟进信息文本内容**//
@property(nonatomic,copy)NSString *cText;

//**跟进信息信息图片地址，以;间隔**//
@property(nonatomic,copy)NSString *cPhotoUrl;

//**跟进信息录音文件地址，以；间隔**//
@property(nonatomic,copy)NSString *cVoiceUrl;

//**是否设置提醒**//1设置  0不设置
@property(nonatomic,assign)NSInteger  iRemind;

//**提醒时间**//
@property(nonatomic,copy)NSString *cRemindTime;
//**跟进信息录入日期**//
@property(nonatomic,copy)NSString *cLogDate;

//**跟进信息录入时间**//
@property(nonatomic,copy)NSString *cLogTime;

//**星期几**//
@property(nonatomic,copy) NSString *cWeekDay;
//****************************************************************
//自定义属性

//**装载自己的模型数组**//
@property(nonatomic,strong) NSMutableArray *followModelArray;
//**照片数组**//
@property(nonatomic,strong) NSMutableArray *photosArray;
//**录音名字数组**//
@property(nonatomic,strong) NSMutableArray *recodeNameArray;

//**cell高度**//
@property(nonatomic,assign)CGFloat cellHeight;

//**************************自定义
//**跟进提醒的具体时间**//
@property(nonatomic,strong) NSString *dateString;

@end
