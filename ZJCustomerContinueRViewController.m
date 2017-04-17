//
//  ZJCustomerContinueRViewController.m
//  CRM
//
//  Created by mini on 16/10/12.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomerContinueRViewController.h"
#import "ZJDatePickView.h"
#import "NSDate+Category.h"
#import "ZJYearAndMonthView.h"




#define defaults  [NSUserDefaults standardUserDefaults]
@interface ZJCustomerContinueRViewController ()<ZJDatePickViewDelegate>
{
    BOOL isAdd;
}

@property (weak, nonatomic) IBOutlet UIButton *mouthButton;
@property (weak, nonatomic) IBOutlet UIButton *yearButton;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

//**时间选择器**//
@property(nonatomic,strong) ZJDatePickView *dateView;

//**判断是否开启提醒**//
@property(nonatomic,assign)NSInteger isSwitch;

@end

@implementation ZJCustomerContinueRViewController

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
    self.navigationItem.title=@"续贷提醒";
    
    UIButton *back = [UIButton zj_creatDefaultLeftButton];
    
    [back addTarget:self action:@selector(continueBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
}

-(void)continueBack{
    
    [self.delegate ZJCustomerContinue:self switctButton:self.isSwitch date:self.yearButton.titleLabel.text];
    
    [self.navigationController popViewControllerAnimated:YES];


}



-(void)setupUI{
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //
    [self.switchButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    [self.switchButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
    //边框
    [self.yearButton.layer setMasksToBounds:YES];
    [self.yearButton.layer setBorderWidth:1.0];
    
//    圆角
    self.yearButton.layer.cornerRadius = 2.0;
    
    //mouthButton
    [self.mouthButton setTitle:[defaults objectForKey:@"continueloan"] forState:UIControlStateNormal];
    [self.mouthButton setBackgroundImage:[UIImage imageNamed:@"UN-rectangle"] forState:UIControlStateNormal];
    [self.mouthButton setBackgroundImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateSelected];
    
    
    self.yearButton.backgroundColor = ZJColorFFFFFF;
    //字体颜色
    [self.yearButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    //字体颜色
    [self.yearButton setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
    

    //设置值
    [self.yearButton setTitle:self.CTimeString forState:UIControlStateNormal];
    
    
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
    
    self.mouthButton.selected = sender.selected;
    self.yearButton.selected = sender.selected;
    
    self.yearButton.layer.borderColor = self.yearButton.selected?ZJColor00D3A3.CGColor:ZJColor505050.CGColor;
    
    self.remindLabel.text = sender.selected?@"点击关闭续贷提醒":@"点击开启续贷提醒";
    
}
#pragma mark   点击获取日期
- (IBAction)clickYearButton:(UIButton *)sender {
    if (isAdd)return;
    self.dateView.dateModel = ZJDatePickViewDateModel;
    self.dateView.minDate = [self.loanTimeString zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];
    self.dateView.nowDate = [self.CTimeString zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.dateView.frame = CGRectMake(0, self.view.height-(40+self.view.height/3.0), self.view.width, 40+self.view.height/3.0);
        
    }];
    isAdd = YES;
    
}



#pragma mark   ZJDatePickView代理方法
-(void)ZJDatePickView:(ZJDatePickView *)view datePickView:(UIDatePicker *)datePick{
    
    if (view.dateModel ==ZJDatePickViewDateModel ) {
        
        NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
        
        [dateFormate setDateFormat:@"yyyy-MM-dd"];
        
        NSString *stringDate = [dateFormate stringFromDate:datePick.date];
        
        [self.yearButton setTitle:stringDate forState:UIControlStateNormal];
        
         NSDate *date = [self.loanTimeString zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];
        NSDateComponents *com = [datePick.date zj_intervalDeadlineFrom:date calendarUnit:NSCalendarUnitMonth];
        [self.mouthButton setTitle:[NSString stringWithFormat:@"%zd",com.month] forState:UIControlStateNormal];
    }else{
        
        NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
        
        [dateFormate setDateFormat:@"HH:mm"];
        
        NSString *stringDate = [dateFormate stringFromDate:datePick.date];
        
    }
    
}

-(void)ZJDatePickView:(ZJDatePickView *)view isChoose:(BOOL)choose{
    
    if (!choose) {
        
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.dateView.frame = CGRectMake(0, self.view.height, self.view.width, 0);
    }];
    isAdd = NO;

}


@end
