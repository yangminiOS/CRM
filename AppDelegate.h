//
//  AppDelegate.h
//  CRM
//
//  Created by mini on 16/8/22.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//**日历事件库**//
@property(nonatomic,strong) EKEventStore *eventStore;


@end

