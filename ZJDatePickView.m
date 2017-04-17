//
//  ZJDatePickView.m
//  CRM
//
//  Created by mini on 16/10/13.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJDatePickView.h"
@interface  ZJDatePickView()

//日期
@property(nonatomic,weak) UIDatePicker *datePick;
//小时分钟
@property(nonatomic,weak) UIDatePicker *hoursPick;
//日期和小时分钟
@property(nonatomic,weak) UIDatePicker *dateHoursPick;

//****//
@property(nonatomic,assign)BOOL choose;
@end

@implementation ZJDatePickView

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

}

-(void)setDateModel:(ZJdateViewModel)dateModel{
    _dateModel = dateModel;
    UIDatePicker *dateView = nil;
    if (dateModel == ZJDatePickViewDateModel) {

        if (_hoursPick) {
            
            [_hoursPick removeFromSuperview];
            _hoursPick = nil;
        }
        
        if (_dateHoursPick) {
            
            [_dateHoursPick removeFromSuperview];
            _dateHoursPick = nil;
            
        }
        
        dateView = [[UIDatePicker alloc]init];
        [self addSubview:dateView];
        self.datePick = dateView;
        dateView.datePickerMode = UIDatePickerModeDate;
        
    }else if(dateModel ==ZJDatePickViewHoursModel){
        
        if (_datePick) {
            
            [_datePick removeFromSuperview];
            _datePick = nil;
        }
        
        if (_dateHoursPick) {
            
            [_dateHoursPick removeFromSuperview];
            _dateHoursPick = nil;
            
        }
        dateView = [[UIDatePicker alloc]init];
        [self addSubview:dateView];
        self.hoursPick = dateView;
        self.hoursPick.datePickerMode = UIDatePickerModeTime;

    }else{
        if (_hoursPick) {
            
            [_hoursPick removeFromSuperview];
            _hoursPick = nil;
        }
        if (_datePick) {
            
            [_datePick removeFromSuperview];
            _datePick = nil;
        }
        dateView = [[UIDatePicker alloc]init];
        [self addSubview:dateView];
        self.dateHoursPick = dateView;
        self.dateHoursPick.datePickerMode = UIDatePickerModeDateAndTime;
        
    }
    dateView.backgroundColor = ZJColorDCDCDC;
    dateView.frame = CGRectMake(0, 40, zjScreenWidth, zjScreenHeight/3);
    [dateView addTarget:self action:@selector(clickDateView:) forControlEvents:UIControlEventValueChanged];
}
//最小时间
-(void)setMinDate:(NSDate *)minDate{
    _minDate = minDate;
    _datePick.minimumDate = minDate;
}

//当前展示的时间
-(void)setNowDate:(NSDate *)nowDate{
    _nowDate = nowDate;
    _datePick.date = nowDate;
}

-(void)clickButton:(UIButton *)button{
    
    if (button.tag == 1) {
        self.choose = NO;
    }else{
        
        self.choose = YES;
    }
    
    [self.delegate ZJDatePickView:self isChoose:self.choose];
    
}

-(void)clickDateView:(UIDatePicker *)dateView
{
    [self.delegate ZJDatePickView:self datePickView:dateView];
    
}

@end
