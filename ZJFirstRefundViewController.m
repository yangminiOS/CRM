//
//  ZJFirstRefundViewController.m
//  CRM
//
//  Created by 杨敏 on 16/10/12.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJFirstRefundViewController.h"
#import "ZJDatePickView.h"
#import "NSDate+Category.h"

#define defaults  [NSUserDefaults standardUserDefaults]

@interface ZJFirstRefundViewController ()<ZJDatePickViewDelegate>

{
    BOOL isAdd;
}
@property (weak, nonatomic) IBOutlet UIButton *dayButton;
@property (weak, nonatomic) IBOutlet UIButton *yearButton;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

//**时间选择器**//
@property(nonatomic,strong) ZJDatePickView *dateView;

//**是否开启提醒**//
@property(nonatomic,assign)NSInteger isSwitch;
@end

@implementation ZJFirstRefundViewController

-(ZJDatePickView *)dateView{
    if (!_dateView) {
        
        _dateView = [[ZJDatePickView alloc]initWithFrame:CGRectMake(0, self.view.height, self.view.width, 0)];
        _dateView.delegate = self;
        [self.view addSubview:_dateView];
        
    }
    return _dateView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航
    [self setupNavi];
    [self setupUI];
    
}



#pragma mark   设置导航
-(void)setupNavi{
    self.navigationItem.title=@"首期还款提醒";
    UIButton *back = [UIButton zj_creatDefaultLeftButton];
    
    [back addTarget:self action:@selector(firstBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
}

#pragma mark   返回键

-(void)firstBack{
    
    [self.delegate ZJFirstView:self switctButton:_isSwitch date:self.yearButton.titleLabel.text];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark   设置界面
-(void)setupUI{
    
    [self.switchButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    [self.switchButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
    //边框
    [self.yearButton.layer setMasksToBounds:YES];
    [self.yearButton.layer setBorderWidth:1.0];
    
    //    圆角
    self.yearButton.layer.cornerRadius = 2.0;
    self.yearButton.clipsToBounds = YES;
    

    //dayButton
    [self.dayButton setBackgroundImage:[UIImage imageNamed:@"UN-rectangle"] forState:UIControlStateNormal];
    
    [self.dayButton setTitle:[defaults objectForKey:@"firstloan"] forState:UIControlStateNormal];
    
    [self.dayButton setBackgroundImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateSelected];
    
    self.yearButton.backgroundColor = ZJColorFFFFFF;
    //字体颜色
    [self.yearButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    //字体颜色
    [self.yearButton setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
    
    self.remindLabel.text = @"点击开启首期还款日提醒";
    
    //设置值
    [self.yearButton setTitle:self.ReTimeString forState:UIControlStateNormal];

    //如果openRimend =1  开启
    if (self.openRemind) {
        
        [self clickSwitchButton:self.switchButton];

        
    }
    
    
}


- (IBAction)clickSwitchButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        self.isSwitch = 1;
    }else{
        
        self.isSwitch = 0;
    }
    self.dayButton.selected = sender.selected;
    self.yearButton.selected = sender.selected;
    
    self.yearButton.layer.borderColor = self.yearButton.selected?ZJColor00D3A3.CGColor:ZJColor505050.CGColor;
    
    self.remindLabel.text = sender.selected?@"点击关闭首期还款日提醒":@"点击开启首期还款日提醒";
}

#pragma mark   点击日期
- (IBAction)clickYearButton:(UIButton *)sender {
    if (isAdd)return;
    self.dateView.dateModel = ZJDatePickViewDateModel;
    self.dateView.minDate = [self.loanTimeString zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];
    self.dateView.nowDate = [self.ReTimeString zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.dateView.frame = CGRectMake(0, self.view.height-(40+self.view.height/3.0), self.view.width, 40+self.view.height/3.0);
        
    }];
    isAdd = YES;
    
}

#pragma mark   ZJDatePickView代理方法
-(void)ZJDatePickView:(ZJDatePickView *)view datePickView:(UIDatePicker *)datePick{
    
    if (view.dateModel ==ZJDatePickViewDateModel ) {
        
        NSString *stringDate = [datePick.date zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];
        
        [self.yearButton setTitle:stringDate forState:UIControlStateNormal];
        NSDate *date = [self.loanTimeString zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];
        NSDateComponents *com = [datePick.date zj_intervalDeadlineFrom:date calendarUnit:NSCalendarUnitDay];
        [self.dayButton setTitle:[NSString stringWithFormat:@"%zd",com.day] forState:UIControlStateNormal];
    }else{
        
        NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
        
        [dateFormate setDateFormat:@"HH:mm"];
        
        NSString *stringDate = [dateFormate stringFromDate:datePick.date];
        
    }
    
    
}
#pragma mark   ZJDatePickView代理方法
-(void)ZJDatePickView:(ZJDatePickView *)view isChoose:(BOOL)choose{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.dateView.frame = CGRectMake(0, self.view.height, self.view.width, 0);
    }];
    isAdd = NO;
    
}


@end
