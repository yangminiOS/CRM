//
//  NSDate+Category.m
//  CRM
//
//  Created by 杨敏 on 16/10/12.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

//间隔期限

-(NSDateComponents*)zj_intervalDeadlineFrom:(NSDate *)from calendarUnit:(NSCalendarUnit)unit{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [calendar components:unit fromDate:from toDate:self options:0];

}


/**
 *  获取N天后的日期
 */
-(NSString *)zj_getDateAfterDays:(NSInteger)afterDays dateFormat:(NSString *)formatter{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *com = [[NSDateComponents alloc]init];

    com.day = afterDays;
    
    NSDate *date = [calendar dateByAddingComponents:com toDate:self options:0];
    NSDateFormatter *form = [[NSDateFormatter alloc]init];

    form.dateFormat = formatter;

    return [form stringFromDate:date];
    
}

//获取N月后的日期

-(NSString *)zj_getDateAfterMouths:(NSInteger)afterMouths{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *com = [[NSDateComponents alloc]init];
    com.month = afterMouths;
    NSDate *date = [calendar dateByAddingComponents:com toDate:self options:0];
    
    NSDateFormatter *form = [[NSDateFormatter alloc]init];
    
    form.dateFormat = @"yyyy-MM-dd";
    
    return [form stringFromDate:date];
}

//获取N年后的日期

-(NSString *)zj_getDateAfterYears:(NSInteger)afterMouths{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *com = [[NSDateComponents alloc]init];
    com.year = afterMouths;
    NSDate *date = [calendar dateByAddingComponents:com toDate:self options:0];
    
    NSDateFormatter *form = [[NSDateFormatter alloc]init];
    
    form.dateFormat = @"yyyy-MM-dd";
    
    return [form stringFromDate:date];
}

//时间转字符串
-(NSString *)zj_getStringFromDatWithFormatter:(NSString *)formatter{
    
    NSDateFormatter *form = [[NSDateFormatter alloc]init];
    
    form.dateFormat = formatter;
    
    return [form stringFromDate:self];
}

//当前时间的具体年份 月份  天

-(NSInteger)zj_getRealTimeForRequire:(NSCalendarUnit)unit{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger time = [calendar component:unit fromDate:self];
    
    return time;
}

//获取当前的季节
-(NSInteger)zj_getSeadonFromDate{
    
    NSInteger season = 0;
    NSInteger month = [self zj_getRealTimeForRequire:NSCalendarUnitMonth];
    
    if (month <=3) {
        
        season = 1;
    }else if (month>3 &&month<=6){
        
        season = 2;
    }else if (month>6 &&month<=9){
        
        season = 3;
    }else{
        
        season = 4;
    }
    
    return season;
}

//当前月还有多少天
-(NSInteger)zj_daysInThisMouth{
    //算出来当前是几年几月几日的。得出当前月份对应的天数。
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate new]];
    NSUInteger numberOfDaysInMonth = range.length;
    
    NSInteger todayInMouth = [self zj_getRealTimeForRequire:NSCalendarUnitDay];
    return numberOfDaysInMonth - todayInMouth;
}
//当前季度还有多少天
-(NSInteger)zj_daysInThisSeason{
    
    NSInteger days = 0;
    NSInteger month = [self zj_getRealTimeForRequire:NSCalendarUnitMonth];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *toDate = nil;
    NSString *toDateString = nil;
    if (month <=3) {
        
        toDateString = [NSString stringWithFormat:@"%zd-03-31",[self zj_getRealTimeForRequire:NSCalendarUnitYear]];
        toDate = [formatter dateFromString:toDateString];
        days = [calendar components:NSCalendarUnitDay fromDate:self toDate:toDate options:0].day;

    }else if (month>3 &&month<=6){
        toDateString = [NSString stringWithFormat:@"%zd-06-30",[self zj_getRealTimeForRequire:NSCalendarUnitYear]];
        toDate = [formatter dateFromString:toDateString];
        days = [calendar components:NSCalendarUnitDay fromDate:self toDate:toDate options:0].day;

        
    }else if (month>6 &&month<=9){
        toDateString = [NSString stringWithFormat:@"%zd-09-30",[self zj_getRealTimeForRequire:NSCalendarUnitYear]];
        toDate = [formatter dateFromString:toDateString];
        days = [calendar components:NSCalendarUnitDay fromDate:self toDate:toDate options:0].day;
    }else{
        toDateString = [NSString stringWithFormat:@"%zd-12-31",[self zj_getRealTimeForRequire:NSCalendarUnitYear]];
        toDate = [formatter dateFromString:toDateString];
        days = [calendar components:NSCalendarUnitDay fromDate:self toDate:toDate options:0].day;
    }
    return days;
}
//当前年份还有多少天
-(NSInteger)zj_daysInThisYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *toDateString =[NSString stringWithFormat:@"%zd-12-31",[self zj_getRealTimeForRequire:NSCalendarUnitYear]];
    NSDate *toDate = [formatter dateFromString:toDateString];

    return [calendar components:NSCalendarUnitDay fromDate:self toDate:toDate options:0].day;

}
//返回今天  明天  还是日期

-(NSString *)zj_isDateString:(NSString *)dateString{
    
    NSString *nowString = [self zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];
    
    NSString *tomString = [self zj_getDateAfterDays:1 dateFormat:@"yyyy-MM-dd"];
    
    if ([dateString isEqualToString:nowString]) {
        
        return @"今天";
    }else if ([dateString isEqualToString:tomString]){
        
        return @"明天";
    }else{
        
        return dateString;
    }
}

//*************


@end
