//
//  ZJYearAndMonthView.m
//  CRM
//
//  Created by mini on 16/11/9.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJYearAndMonthView.h"
#import "DVYearMonthDatePicker.h"//年月选择器

@interface ZJYearAndMonthView ()<DVYearMonthDatePickerDelegate>

@end

@implementation ZJYearAndMonthView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    UIButton *cancelbutton = [[UIButton alloc]init];
    [self addSubview:cancelbutton];
    cancelbutton.frame = CGRectMake(0, 0, zjScreenWidth/2.0, 40);
    cancelbutton.tag = 1;
    [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelbutton setBackgroundColor:ZJColor00D3A3];
    
    [cancelbutton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *donebutton = [[UIButton alloc]init];
    [self addSubview:donebutton];
    donebutton.frame = CGRectMake(zjScreenWidth/2.0, 0, zjScreenWidth/2.0, 40);
    donebutton.tag = 2;
    [donebutton setTitle:@"确定" forState:UIControlStateNormal];
    [donebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [donebutton setBackgroundColor:ZJColor00D3A3];
    
    [donebutton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = CGRectMake(0, 40, zjScreenWidth, zjScreenHeight/3);
    
    DVYearMonthDatePicker *dvDate = [[DVYearMonthDatePicker alloc]initWithFrame:frame];
    dvDate.dvDelegate = self;
    [self addSubview:dvDate];
    [dvDate selectToday];
//    [dvDate setupMinYear:2013 maxYear:2033];//设定最小年限好最大年
    
}


#pragma mark   代理方法
- (void)yearMonthDatePicker:(DVYearMonthDatePicker *)yearMonthDatePicker didSelectedDate:(NSDate *)date {
    
    [self.delegate ZJYearAndMonthView:self date:date];
    
}
#pragma mark---------点击Button

-(void)clickButton:(UIButton *)button{
    
    [self.delegate ZJYearAndMonthView:self isChoose:YES];
}

@end
