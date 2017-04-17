//
//  CalenderObject.h
//  CSchool
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalenderObject : NSObject
/**
 *  添加日历事件
 *
 *  @param title         日历标题
 *  @param idefitier     日历事件唯一标示
 *  @param startTime     日历事件开始时间  *传时间戳
 *  @param endTime       日历事件结束时间  *传时间戳
 *  @param location      事件地点
 *  @param noticeFirTime 闹钟开始时间  传0时 第一次提醒时间为事件发生时  传nil时第一次提醒是一小时前  double类型的数据
 *  @param noticeSecTime 闹钟结束时间  传0时 第二次提醒时间为事件发生时  传nil时第一次提醒是半小时前  double类型数据
 */
+(void)initWithTitle:(NSString *)title andIdetifider:(NSString *)idefitier WithStartTime:(NSString *)startTime andEndTime:(NSString *)endTime Location:(NSString *)location andNoticeFirTime:(double)noticeFirTime withNoticeEndTime:(double)noticeSecTime;
/**
 *  移除相应的日历事件
 *
 *  @param startTime 日历事件开始时间
 *  @param endTime   日历事件结束时间
 *  @param idetifier 日历事件唯一标示
 */
+(void)deleteCalenderEvent:(NSString *)startTime andEndTime:(NSString *)endTime  withIdetifier:(NSString *)idetifier;


@end
