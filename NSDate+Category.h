//
//  NSDate+Category.h
//  CRM
//
//  Created by 杨敏 on 16/10/12.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

//间隔期限
-(NSDateComponents*)zj_intervalDeadlineFrom:(NSDate *)from calendarUnit:(NSCalendarUnit)unit;
//获取N天后的日期

-(NSString *)zj_getDateAfterDays:(NSInteger)afterDays dateFormat:(NSString *)formatter;

//获取N月后的日期

-(NSString *)zj_getDateAfterMouths:(NSInteger)afterMouths;

//获取N年后的日期

-(NSString *)zj_getDateAfterYears:(NSInteger)afterMouths;

//从时间回去字符长
-(NSString *)zj_getStringFromDatWithFormatter:(NSString *)formatter;
//当前时间的具体年份 月份  天

-(NSInteger)zj_getRealTimeForRequire:(NSCalendarUnit)unit;

//获取当前的季节
-(NSInteger )zj_getSeadonFromDate;

//当前月还有多少天
-(NSInteger)zj_daysInThisMouth;
//当前季度还有多少天
-(NSInteger)zj_daysInThisSeason;
//当前年份患有多少天
-(NSInteger)zj_daysInThisYear;
//返回今天  明天  还是日期

-(NSString *)zj_isDateString:(NSString *)dateString;

@end
