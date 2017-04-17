//
//  ZJDatePickView.h
//  CRM
//
//  Created by mini on 16/10/13.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZJdateViewModel){
    ZJDatePickViewDateAndHoursModel,
    ZJDatePickViewDateModel,
    ZJDatePickViewHoursModel
};

@class ZJDatePickView;


@protocol ZJDatePickViewDelegate <NSObject>

-(void)ZJDatePickView:(ZJDatePickView *)view isChoose:(BOOL)choose;

-(void)ZJDatePickView:(ZJDatePickView *)view datePickView:(UIDatePicker*)datePick;



@end

@interface ZJDatePickView : UIView

//**代理方法**//
@property(nonatomic,weak) id<ZJDatePickViewDelegate>delegate;

//**模式**//
@property(nonatomic,assign)ZJdateViewModel dateModel;

//**最小时间日期**//
@property(nonatomic,strong) NSDate *minDate;
//**当前日期**//
@property(nonatomic,strong)NSDate *nowDate;

@end
