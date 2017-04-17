//
//  ZJGtasksTableInfo.h
//  CRM
//
//  Created by mini on 16/10/26.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJGtasksTableInfo : NSObject

//**自增长唯一标识**//
@property(nonatomic,assign)NSInteger  iAutoID;

//**代办事宜内容**//
@property(nonatomic,copy)NSString *contentText;

//**日期**//
@property(nonatomic,copy)NSString *dateString;

//**具体时间  时分秒**//
@property(nonatomic,copy)NSString *timeString;

//**星期**//
@property(nonatomic,copy)NSString *weekString;

//**完成还是代办**//
@property(nonatomic,assign)NSInteger completeOrGtasks;





@end
