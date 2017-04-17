//
//  ZJYearAndMonthView.h
//  CRM
//
//  Created by mini on 16/11/9.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJYearAndMonthView;

@protocol ZJYearAndMonthViewDelegate <NSObject>

-(void)ZJYearAndMonthView:(ZJYearAndMonthView *)view isChoose:(BOOL)choose;

-(void) ZJYearAndMonthView:(ZJYearAndMonthView *)view date:(NSDate*)date;

@end

@interface ZJYearAndMonthView : UIView


//**代理方法**//
@property(nonatomic,weak) id<ZJYearAndMonthViewDelegate>delegate;


@end
