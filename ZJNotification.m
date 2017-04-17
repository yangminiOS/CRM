//
//  ZJNotification.m
//  CRM
//
//  Created by mini on 16/12/7.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJNotification.h"
#import "ZJFMdb.h"

@implementation ZJNotification


+(void)isAddLocalNotification{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    
    NSDate *nowDate = [NSDate new];
    
    NSString *nowString = [nowDate zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];
    

    NSDate *nowDateDay = [nowString zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];


    NSString *todayTime = [NSString stringWithFormat:@"%@ 09:00:00",nowString];
    
    NSDate *today9c = [todayTime zj_getDateFromStringWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateComponents *comp = [today9c zj_intervalDeadlineFrom:nowDate calendarUnit:NSCalendarUnitSecond];
    
    if (comp.second>0) {
        
        [self birthForDate:nowDateDay afrerDay:0];

        [self firstAndContinueForDate:nowDateDay afrerDay:0 typeID:2 timeString:@"09:00:00" typeString:@"可以续贷啦"];
        
        [self firstAndContinueForDate:nowDateDay afrerDay:0 typeID:3 timeString:@"09:00:00" typeString:@"到首期还款日了"];


    }

    [self birthForDate:nowDateDay afrerDay:1];

    [self birthForDate:nowDateDay afrerDay:2];
    [self birthForDate:nowDateDay afrerDay:3];
            

    [self firstAndContinueForDate:nowDateDay afrerDay:1 typeID:2 timeString:@"09:10:00" typeString:@"可以续贷啦"];
    [self firstAndContinueForDate:nowDateDay afrerDay:2 typeID:2 timeString:@"09:10:00" typeString:@"可以续贷啦"];
            
    [self firstAndContinueForDate:nowDateDay afrerDay:3 typeID:2 timeString:@"09:10:00" typeString:@"可以续贷啦"];


    [self firstAndContinueForDate:nowDateDay afrerDay:1 typeID:3 timeString:@"09:20:00" typeString:@"到首期还款日了"];

    [self firstAndContinueForDate:nowDateDay afrerDay:2 typeID:3 timeString:@"09:20:00" typeString:@"到首期还款日了"];

    [self firstAndContinueForDate:nowDateDay afrerDay:3 typeID:3 timeString:@"09:20:00" typeString:@"到首期还款日了"];

            
    
}

+(void)LocalNotificationWithAlertBody:(NSString *)body actionDate:(NSDate *)date
{
    
    // 1.创建本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    localNote.fireDate = date;
    
    localNote.alertBody = body;
    
    localNote.applicationIconBadgeNumber +=1;
    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}
//生日封装
+(void)birthForDate:(NSDate *)nowDateDay afrerDay:(NSInteger)days{
    

    //添加3天后的时间字符创
    NSString *afterdS = [nowDateDay zj_getDateAfterDays:days dateFormat:@"yyyy-MM-dd"];
    //3天后的具体时间
    NSDate *dateAfterd = [afterdS zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];
    //3天后的月日
    NSString *monthAndDay = [dateAfterd zj_getStringFromDatWithFormatter:@"MM-dd"];
    
    NSString *NotBirthSelect = [NSString stringWithFormat:@"SELECT COUNT (*) FROM %@ WHERE iRemindType=1 AND iSwitch=1 AND cRemindDate='%@'",ZJRemindTableName,monthAndDay];
    
    NSInteger NotBirthConut = [ZJFMdb sqlSelecteCountWithString:NotBirthSelect];
    
    if (NotBirthConut) {
        
        NSString *notDateString = [NSString stringWithFormat:@"%@ 09:00:00",afterdS];
        NSDate *notDate = [notDateString zj_getDateFromStringWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *countS= [NSString stringWithFormat:@"今天有%zd位客户过生日,快来送上祝福吧",NotBirthConut];
        
        [self LocalNotificationWithAlertBody:countS actionDate:notDate];
    }

}
//续贷提醒和首期还款封装
+(void)firstAndContinueForDate:(NSDate *)nowDateDay afrerDay:(NSInteger)days typeID:(NSInteger)type timeString:(NSString *)time typeString:(NSString *)string{
    
    //添加3天后的时间字符创
    NSString *afterdS = [nowDateDay zj_getDateAfterDays:days dateFormat:@"yyyy-MM-dd"];
    
    NSString *NotBirthSelect = [NSString stringWithFormat:@"SELECT COUNT (*) FROM %@ WHERE iRemindType=%zd AND iSwitch=1 AND cRemindDate='%@'",ZJRemindTableName,type,afterdS];
    
    NSInteger firstAndContinueConut = [ZJFMdb sqlSelecteCountWithString:NotBirthSelect];

    if (firstAndContinueConut) {
        
        NSString *notDateString = [NSString stringWithFormat:@"%@ %@",afterdS,time];

//        NSString *notDateString = [NSString stringWithFormat:@"%@",time];
        NSDate *notDate = [notDateString zj_getDateFromStringWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *countS= [NSString stringWithFormat:@"今天有%zd位客户%@，快来看看吧",firstAndContinueConut,string];
        
        [self LocalNotificationWithAlertBody:countS actionDate:notDate];
    }

}


@end
