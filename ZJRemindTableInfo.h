//
//  CRMRemind.h
//  CRM
//
//  Created by 杨敏 on 16/9/1.
//  Copyright © 2016年 mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJRemindTableInfo : NSObject
//**自增长唯一标识**//
@property(nonatomic,assign)NSInteger  iAutoID;

//**对应的客户标号**//
@property(nonatomic,assign)NSInteger iCustomerID;

//**提醒类型**//1.生日提醒   2续贷提醒   3首期还款日期提醒
@property(nonatomic,assign)NSInteger  iRemindType;

//**是否开启提醒**//
@property(nonatomic,assign)NSInteger  iSwitch;

//**提醒时间**//
@property(nonatomic,copy)NSString *cRemindTime;

//**提醒日期**//
@property(nonatomic,copy)NSString *cRemindDate;





@end
