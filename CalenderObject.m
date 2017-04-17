//
//  CalenderObject.m
//  CSchool
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "CalenderObject.h"
#import <EventKit/EventKit.h>
#import "AppDelegate.h"

@implementation CalenderObject


+(void)initWithTitle:(NSString *)title andIdetifider:(NSString *)idefitier WithStartTime:(NSString *)startTime andEndTime:(NSString *)endTime Location:(NSString *)location andNoticeFirTime:(double)noticeFirTime withNoticeEndTime:(double)noticeSecTime
{
    [[self alloc]initWithTitle:title andIdetifider:idefitier WithStartTime:startTime andEndTime:endTime Location:location andNoticeFirTime:noticeFirTime withNoticeEndTime:noticeSecTime];
}
-(void)initWithTitle:(NSString *)title andIdetifider:(NSString *)idefitier WithStartTime:(NSString *)startTime andEndTime:(NSString *)endTime Location:(NSString *)location andNoticeFirTime:(double)noticeFirTime withNoticeEndTime:(double)noticeSecTime
{
           //事件市场
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    EKEventStore *eventStore = appDelegate.eventStore;
        //6.0及以上通过下面方式写入事件
        if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
        {
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error)
                    {
                        //错误信息
                        // display error message here
                    }
                    else if (!granted)
                    {
                        //被用户拒绝，不允许访问日历
                        NSLog(@"用户拒绝访问日历");                        
                    }
                    else
                    {
                        EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
//                        NSDate *sDate = [NSDate dateWithTimeIntervalSince1970:[startTime  intValue]];
//                        NSDate *eDate = [NSDate dateWithTimeIntervalSince1970:[endTime intValue]];
                        NSDate *enentDate =[startTime zj_getDateFromStringWithFormatter:@"yyyy-MM-dd HH:mm"];
                        event.startDate = enentDate;
                        event.endDate   = [endTime zj_getDateFromStringWithFormatter:@"yyyy-MM-dd HH:mm"];
                        [event addAlarm:[EKAlarm alarmWithAbsoluteDate:enentDate]];
                        event.title =title;
                        event.location =location;
                        event.notes =idefitier;
                        
////                        添加提醒    默认半小时--一小时进行提醒。
//                        if (noticeFirTime||noticeSecTime) {
//                            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:60.0f * -60.0f];
//                            EKAlarm *alarm2 = [EKAlarm alarmWithRelativeOffset:60.0f*-30.0f];
//                            [event addAlarm:alarm];
//                            [event addAlarm:alarm2];
//                            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
//
//                        }else{
//                            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:noticeFirTime];
//                            EKAlarm *alarm2 = [EKAlarm alarmWithRelativeOffset:noticeSecTime];
//                            [event addAlarm:alarm];
//                            [event addAlarm:alarm2];
//                            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
//                            
//                        }
                        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                                NSError *err;
                        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    }
                });
            }];
        }
}
+(void)deleteCalenderEvent:(NSString *)startTime andEndTime:(NSString *)endTime  withIdetifier:(NSString *)idetifier
{
    [[self alloc]deleteCalenderEvent:startTime andEndTime:endTime withIdetifier:idetifier];
}

//移除日历事件中对应的事件
-(void)deleteCalenderEvent:(NSString *)startTime andEndTime:(NSString *)endTime  withIdetifier:(NSString *)idetifier
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    EKEventStore *eventStore = appDelegate.eventStore;
    
    NSString *tempS = [self getDateAfterDays:-1 fromDate:[startTime zj_getDateFromStringWithFormatter:@"yyyy-MM-dd HH:mm"]];
    
    NSString *tempE = [self getDateAfterDays:1 fromDate:[endTime zj_getDateFromStringWithFormatter:@"yyyy-MM-dd HH:mm"]];
    
    NSDateFormatter *form = [[NSDateFormatter alloc]init];
    
    [form setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    form.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate* sdate = [form dateFromString:tempS];//事件段，开始时间
    NSDate* send = [form dateFromString:tempE];//结束时间，取中间
    NSPredicate* predicate = [eventStore predicateForEventsWithStartDate:sdate
                                                                 endDate:send
                                                               calendars:nil];
    NSArray *events = [eventStore eventsMatchingPredicate:predicate];
    for (EKEvent *event in events) {
        
        if ([event.notes isEqualToString:idetifier]) {
            if([eventStore removeEvent:event span:EKSpanFutureEvents error:nil]){
            
            }
        }
        
    }
}

//转化为本地时间
-(NSDate *)changeDate:(NSDate *)originDate
{
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:originDate];
    
    NSDate *localeDate = [originDate  dateByAddingTimeInterval: interval];
    return localeDate;
}

//获取n天后的日期

-(NSString *)getDateAfterDays:(NSInteger)afterDays fromDate:(NSDate *)fromDate{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *com = [[NSDateComponents alloc]init];
    
    com.day = afterDays;
    
    NSDate *date = [calendar dateByAddingComponents:com toDate:fromDate options:0];
    
    NSDateFormatter *form = [[NSDateFormatter alloc]init];

    
    form.dateFormat = @"yyyy-MM-dd HH:mm";

 
    return  [form stringFromDate:date];
;
    
}

@end
