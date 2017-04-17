//
//  ZJGoalTableInfo.h
//  CRM
//
//  Created by mini on 16/10/22.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJGoalTableInfo : NSObject
//**自增长唯一标识**//
@property(nonatomic,assign)NSInteger  iAutoID;

//**类型  月度  季度  年**//
@property(nonatomic,copy)NSString *type;

//**goal目标金额**//
@property(nonatomic,assign)NSInteger goalCount;

//**已完成目标**//
@property(nonatomic,assign)CGFloat completeCount;

//**具体月份 季度 年份**//
@property(nonatomic,copy)NSString *tag;

//**year**//
@property(nonatomic,copy)NSString *year;

//自定义
//**判断是否可以编辑**//
@property(nonatomic,assign,getter=isHidden)BOOL hidden;

//**是否是季度**//
@property(nonatomic,assign)BOOL isSeason;
@end
