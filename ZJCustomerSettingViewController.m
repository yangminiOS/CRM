//
//  ZJCustomerSettingViewController.m
//  CRM
//
//  Created by mini on 16/9/18.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomerSettingViewController.h"
#import <Masonry.h>

@interface ZJCustomerSettingViewController ()<UITextFieldDelegate>

//天数
@property(nonatomic,weak)UITextField *dayTextField;

//月数
@property(nonatomic,weak)UITextField *mouthTextField;

@end

@implementation ZJCustomerSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZJBackGroundColor;
    
    //设置导航栏
    [self setupNavigation];
    
    //布局视图
    [self setupUI];
}
#pragma mark   设置导航栏
-(void)setupNavigation{
    
    self.navigationItem.title = @"客户管理设置";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem zj_BarButtonItemWithTitle:@"完成" titleColor:[UIColor whiteColor] target:self action:@selector(clickFinishButtonItem)];
    
  
}
//导航栏右边完成按钮
-(void)clickFinishButtonItem{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //首期还款日提醒
    NSInteger first = self.dayTextField.text.integerValue;
    
    NSInteger contin= self.mouthTextField.text.integerValue;
    
    if (first<1) {
        first = 30;

    }
    
    if (contin<1) {
        //续贷提醒
        contin = 6;
        
    }
    
    NSString *firstLoan = [NSString stringWithFormat:@"%zd",first];
    
    NSString *continueRemind = [NSString stringWithFormat:@"%zd",contin];

    [defaults setObject:firstLoan forKey:@"firstloan"];
    
    [defaults setObject:continueRemind forKey:@"continueloan"];


    [defaults synchronize];
    
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark   布局视图

-(void)setupUI{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    
    [self.view addGestureRecognizer:tap];
    
    CGFloat margin = PX2PT(30);
    
    CGFloat textSize = ZJTextSize45PX;
    
    //背景View
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, PX2PT(380))];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:backView];
    
    //首期还款日提醒
    
    UILabel *refund = [[UILabel alloc]init];
    
    refund.text = @"首期还款日提醒";
    
    refund.font = [UIFont systemFontOfSize:textSize];
    
    refund.textColor = ZJColor00D3A3;
    
    [refund zj_adjustWithMin];
    
    [backView addSubview:refund];
    
    refund.centerY = backView.height/4;
    
    refund.x = ZJmargin40;
    
    CGFloat height = refund.height;
    
    //竖直分割线
    
    UIView *separator1  = [[UIView alloc]init];
    separator1.backgroundColor = ZJColorDCDCDC;
    
    [backView addSubview:separator1];
    
    [separator1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(refund.mas_right).offset(margin);
        make.width.mas_equalTo(ZJseparatorWH);
        make.height.mas_equalTo(PX2PT(110));
        make.centerY.mas_equalTo(refund);
        
    }];
    //放款后
    
    UILabel *loan = [[UILabel alloc]init];
    [backView addSubview:loan];
    loan.text = @"放款后";
    loan.font = [UIFont systemFontOfSize:textSize];
    loan.textColor = ZJColorDCDCDC;
    CGFloat loanW = [loan.text zj_getStringRealWidthWithHeight:height fountSize:textSize];
    [loan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(separator1.mas_right).offset(margin);
        make.width.mas_equalTo(loanW);
        make.height.mas_equalTo(refund);
        make.centerY.mas_equalTo(refund); 
        
    }];
    
    //天
    
    UILabel *day = [[UILabel alloc]init];
    
    [backView addSubview:day];

    day.text = @"天";
    day.font = [UIFont  systemFontOfSize:textSize];
    day.textColor = ZJColorDCDCDC;
    CGFloat dayW = [day.text zj_getStringRealWidthWithHeight:height fountSize:textSize];
    
    [day mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(backView.mas_right).offset(-ZJmargin40);
        make.width.mas_equalTo(dayW);
        make.centerY.mas_equalTo(loan);
        make.height.mas_equalTo(loan);
    }];
    
    //第一条水平分割线
    
    UIView *horizontal1 = [[UIView alloc]init];
    
    [backView addSubview: horizontal1];
    
    horizontal1.backgroundColor = ZJColorDCDCDC;
    
    [horizontal1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(loan);
        
        make.right.mas_equalTo(backView);
        
        make.height.mas_equalTo(ZJseparatorWH);
        
        make.top.mas_equalTo(backView.mas_top).offset(PX2PT(190));
    }];
    
    //textfield
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UITextField *dayText = [[UITextField alloc]init];
    dayText.keyboardType = UIKeyboardTypeNumberPad;
    dayText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    dayText.text = [defaults objectForKey:@"firstloan"];
    dayText.delegate = self;
    [backView addSubview:dayText];
    self.dayTextField = dayText;
    
    dayText.textAlignment = NSTextAlignmentCenter;
    
    dayText.font = [UIFont systemFontOfSize:textSize];
    
    dayText.textColor = ZJColor505050;
    
    [dayText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(loan.mas_right);
        make.right.mas_equalTo(day.mas_left);
        make.height.mas_equalTo(loan);
        make.top.mas_equalTo(loan);

    }];
    
    //续贷提醒
    
    UILabel *continueL = [[UILabel alloc]init];
    
    continueL.text = @"续贷提醒";
    
    continueL.font = [UIFont systemFontOfSize:textSize];
    
    continueL.textColor = ZJColor00D3A3;
    
    [continueL zj_adjustWithMin];
    
    continueL.centerY = 3*backView.height/4;
    
    continueL.x = ZJmargin40;
    [backView addSubview:continueL];
    //分割性
    
    UIView *separator2  = [[UIView alloc]init];
    
    separator2.backgroundColor = ZJColorDCDCDC;
    [backView addSubview:separator2];
    
    [separator2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.width.height.mas_equalTo(separator1);
        make.centerY.mas_equalTo(continueL);
        
    }];
    
    //放款后2
    
    UILabel *loan2 = [[UILabel alloc]init];
    [backView addSubview:loan2];
    loan2.text = @"放款后";
    loan2.font = [UIFont systemFontOfSize:textSize];
    loan2.textColor = ZJColorDCDCDC;
    [loan2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(separator2.mas_right).offset(margin);
        make.width.mas_equalTo(loanW);
        make.height.mas_equalTo(continueL);
        make.centerY.mas_equalTo(continueL);
        
    }];
    
    //月
    
    UILabel *mouth = [[UILabel alloc]init];
    
    [backView addSubview:mouth];
    
    mouth.text = @"月";
    mouth.font = [UIFont  systemFontOfSize:textSize];
    mouth.textColor = ZJColorDCDCDC;
    [mouth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.mas_equalTo(day);
        make.centerY.mas_equalTo(loan2);
    }];

    
    //
    
    UITextField *mouthText = [[UITextField alloc]init];
    mouthText.keyboardType = UIKeyboardTypeNumberPad;
    mouthText.clearButtonMode = UITextFieldViewModeWhileEditing;

    mouthText.text = [defaults objectForKey:@"continueloan"];
    mouthText.delegate = self;
    [backView addSubview:mouthText];
    self.mouthTextField = mouthText;
    
    mouthText.textAlignment = NSTextAlignmentCenter;
    
    mouthText.font = [UIFont systemFontOfSize:textSize];
    
    mouthText.textColor = ZJColor505050;
    
    [mouthText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.height.mas_equalTo(dayText);
        make.top.mas_equalTo(loan2);
        
    }];
    //第2条水平分割线
    
    UIView *horizontal2 = [[UIView alloc]init];
    
    [backView addSubview: horizontal2];
    
    horizontal2.backgroundColor = ZJColorDCDCDC;
    
    [horizontal2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(backView);
        
        make.height.mas_equalTo(ZJseparatorWH);
        
        make.bottom.mas_equalTo(backView);
    }];

}

-(void)tapView{
    
    [self.dayTextField resignFirstResponder];
    
    [self.mouthTextField resignFirstResponder];
}

#pragma mark   textFielddelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * temp = [textField.text stringByAppendingString:string];

    
    if (textField ==self.dayTextField&&([temp zj_isStringAccordWith:@"^[1-9][0-9]{0,2}?$"])) {
        
        return YES;
        
    }else if (textField == self.mouthTextField&&([temp zj_isStringAccordWith:@"^[1-9][0-9]{0,2}?$"])){
        
        return YES;
    }
    
    return NO;
}

@end
