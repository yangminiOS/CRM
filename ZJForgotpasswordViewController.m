//
//  ZJForgotpasswordViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/24.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJForgotpasswordViewController.h"
#import "CartoonUtils.h"
#import "AFNetworking.h"
#import "ZJLoginViewControllerViewController.h"

#import "MBProgressHUD.h"//菊花
#import "ZJCaptchaTimerManager.h"//倒计时对象单例
@interface ZJForgotpasswordViewController ()<UITextFieldDelegate>
{
    //验证码按钮
    UIButton *_Verification;
    //验证码
    UITextField *_passwordTextField;
    //手机号码
    UITextField *_PhoneTexeField;
    //新密码
    UITextField *_NewPasswordTextField;
}


@property (nonatomic, assign) __block int timeout;

@end

@implementation ZJForgotpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = ZJBackGroundColor;
    
    
    [self loadSyte];
}


- (void)loadSyte{
    //顶部文字
    UILabel *pass = [[UILabel alloc]init];
    pass.textAlignment = NSTextAlignmentLeft;
    [pass zj_labelText:@"请通过手机号验证身份后重置密码" textColor:ZJColor505050 textSize:ZJTextSize35PX];
    pass.x = PX2PT(40);
    pass.y = PX2PT(60);
    [pass zj_adjustWithMin];
    [self.view addSubview:pass];
    
    UIView *UPView = [[UIView alloc]initWithFrame:CGRectMake(0, pass.height + PX2PT(60 + 60), zjScreenWidth, PX2PT(600))];
    UPView.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:UPView];
    
    //虚线
    [UPView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)]];
    [UPView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, PX2PT(200) - 1, zjScreenWidth, 1)]];
    [UPView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, PX2PT(400) - 1, zjScreenWidth, 1)]];
    [UPView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, PX2PT(600) - 1, zjScreenWidth, 1)]];
    [UPView addSubview:[self setSeparatorViewWithFrame:CGRectMake(zjScreenWidth - PX2PT(312) - 1, PX2PT(200), 1, PX2PT(200))]];
    
    //手机号文本输入
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(PX2PT(40),0,zjScreenWidth - PX2PT(40) ,PX2PT(200))];
    NSString *holderText = @"请输入手机号";
    textField.delegate = self;
    _PhoneTexeField = textField;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:ZJColorDCDCDC
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:ZJTextSize45PX]
                        range:NSMakeRange(0, holderText.length)];
    textField.attributedPlaceholder = placeholder;
    [UPView addSubview:textField];
    
    //验证码文本输入
    UITextField *PhonetextField = [[UITextField alloc]initWithFrame:CGRectMake(PX2PT(40),PX2PT(200) + 1,zjScreenWidth - PX2PT(312) - 10,PX2PT(200))];
    NSString *PhoneholderText = @"请输入验证码";
    PhonetextField.delegate = self;
    _passwordTextField = PhonetextField;
    PhonetextField.keyboardType = UIKeyboardTypeNumberPad;
    PhonetextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSMutableAttributedString *Phoneplaceholder = [[NSMutableAttributedString alloc] initWithString:PhoneholderText];
    [Phoneplaceholder addAttribute:NSForegroundColorAttributeName
                        value:ZJColorDCDCDC
                        range:NSMakeRange(0, PhoneholderText.length)];
    [Phoneplaceholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:ZJTextSize45PX]
                        range:NSMakeRange(0, PhoneholderText.length)];
    PhonetextField.attributedPlaceholder = Phoneplaceholder;
    [UPView addSubview:PhonetextField];
    
    //新密码文本输入
    UITextField *PasswordtextField = [[UITextField alloc]initWithFrame:CGRectMake(PX2PT(40),PX2PT(400) + 1,zjScreenWidth - PX2PT(312) - 1,PX2PT(200))];
    PasswordtextField.delegate = self;
    _NewPasswordTextField = PasswordtextField;
    NSString *PasswordholderText = @"请输入新密码";
    PasswordtextField.secureTextEntry = YES;
    PasswordtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSMutableAttributedString *Passwordplaceholder = [[NSMutableAttributedString alloc] initWithString:PasswordholderText];
    [Passwordplaceholder addAttribute:NSForegroundColorAttributeName
                             value:ZJColorDCDCDC
                             range:NSMakeRange(0, PasswordholderText.length)];
    [Passwordplaceholder addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:ZJTextSize45PX]
                             range:NSMakeRange(0, PasswordholderText.length)];
    PasswordtextField.attributedPlaceholder = Passwordplaceholder;
    [UPView addSubview:PasswordtextField];
    
    //获取验证码按钮
    UIButton *obtain = [[UIButton alloc]initWithFrame:CGRectMake(UPView.width - PX2PT(312), PX2PT(200) + 1, PX2PT(312),PX2PT(200))];
    _Verification = obtain;
    
    [obtain setTitle:@"获取验证码" forState:UIControlStateNormal];
    [obtain setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    obtain.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    obtain.tag = 1;
    [obtain addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [UPView addSubview:obtain];
    
    //新密码隐藏按钮
    UIButton *passwordButton = [[UIButton alloc]initWithFrame:CGRectMake(zjScreenWidth - PX2PT(100 + 40), PX2PT(470), PX2PT(100), PX2PT(58))];
    [passwordButton setImage:[UIImage imageNamed:@"I_close"] forState:UIControlStateNormal];
    [passwordButton setImage:[UIImage imageNamed:@"I_open"] forState:UIControlStateSelected];
    [passwordButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    passwordButton.tag = 2;
    [UPView addSubview:passwordButton];
    
    UILabel *passwordComposition = [[UILabel alloc]init];
    passwordComposition.textAlignment = NSTextAlignmentLeft;
    [passwordComposition zj_labelText:@"密码由6-16位英文字母、数字组成" textColor:ZJColor505050 textSize:ZJTextSize35PX];
    passwordComposition.x = PX2PT(40);
    passwordComposition.y = PX2PT(40 + 60 + 60) + pass.height + UPView.height;
    [passwordComposition zj_adjustWithMin];
    [self.view addSubview:passwordComposition];
    
    UIView *lastView = [[UIView alloc]initWithFrame:CGRectMake(0, PX2PT(40 + 60 + 60 + 40) + pass.height + UPView.height + passwordComposition.height, zjScreenWidth, PX2PT(428))];
    lastView.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:lastView];
    
    //确定按钮
    UIButton *DeterButton = [[UIButton alloc]initWithFrame:CGRectMake(PX2PT(60), PX2PT(100), PX2PT(1122), PX2PT(128))];

    [DeterButton setBackgroundImage:[UIImage imageNamed:@"Send-blessings"]  forState:UIControlStateNormal];
    [DeterButton setBackgroundImage:[UIImage imageNamed:@"Send-blessings"]  forState:UIControlStateSelected];
    [DeterButton setTitle:@"确定" forState:UIControlStateNormal];
    DeterButton.tag = 3;
    [DeterButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [lastView addSubview:DeterButton];
    
}

//创建虚线
-(UIView *)setSeparatorViewWithFrame:(CGRect)frame  {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = ZJColorDCDCDC;
    view.frame = frame;
    return view;
    
}
- (void)Click:(UIButton *)sender{
   
    switch (sender.tag) {
        case 1:
        {
            if (_PhoneTexeField.text.length < 11) {
                [self autorAlertViewWithMsg:@"请输入正确的手机号"];
                break;
            }
            
            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
            __weak __typeof(self) weakself=self;
            [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                if (status ==AFNetworkReachabilityStatusNotReachable) {
                    [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
                }else{
                    [weakself SendVerificationCode];
                    
                }
            }];
            //开始检测
            [manager startMonitoring];
    
        }
            break;
        case 2:
        {
            sender.selected = !sender.selected;
            _NewPasswordTextField.secureTextEntry = !_NewPasswordTextField.secureTextEntry;
        }
            break;
        case 3:
        {
            if (_PhoneTexeField.text.length < 1) {
                [_PhoneTexeField becomeFirstResponder];
                [self autorAlertViewWithMsg:@"请输入手机号"];
                break;
            }else if (_passwordTextField.text.length < 1){
                [_passwordTextField becomeFirstResponder];
                [self autorAlertViewWithMsg:@"请输入正确的验证码"];
                break;
            }else if (_NewPasswordTextField.text.length < 6){
                [_NewPasswordTextField becomeFirstResponder];
                [self autorAlertViewWithMsg:@"密码长度至少为6位"];
                break;
            }
            
            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
            __weak __typeof(self) weakself=self;
            [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
               
                if (status ==AFNetworkReachabilityStatusNotReachable) {
                    [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
                }else{
                    [weakself LoginZJ];
                    
                }
            }];
            //开始检测
            [manager startMonitoring];

            }
            break;
        default:
            break;
    }
    
}


//向服务器获取验证码
- (void)SendVerificationCode{
    
    _Verification.userInteractionEnabled = NO;
    __weak __typeof(self) weakself=self;
    [CartoonUtils requestWithAnimation:_PhoneTexeField.text andType:@"fp" andCallback:^(id obj) {
        NSString *str = obj;
        if ([str isEqualToString:@"网络异常，请稍后重试"]) {
            [weakself autorAlertViewWithMsg:str];
            _Verification.userInteractionEnabled = YES;
            return ;
        }
        if (str != NULL) {
            NSString *urldecode = [str zj_urlDecode];
            [weakself autorAlertViewWithMsg:urldecode];
            _Verification.userInteractionEnabled = YES;
        }else {
            _timeout = 60; //倒计时时间
            [weakself timerCountDown];
        }
    }];
}

//页面出现前取出计时器单例的时间进行判断是否还在倒计时
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 创建单例对象
    ZJCaptchaTimerManager *manager = [ZJCaptchaTimerManager sharedTimerManager];
    int temp = manager.Forgotwordtimeout;
    if (temp > 0) {
        _timeout= temp; //倒计时时间
        _Verification.alpha = 0.4;
        _Verification.userInteractionEnabled = NO;
        [self timerCountDown];
    }else {
        _Verification.alpha = 1;
        _Verification.userInteractionEnabled = YES;
    }
}

//页面消失前记录倒计时时间到单例里
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.timeout > 0) {
        ZJCaptchaTimerManager *manager = [ZJCaptchaTimerManager sharedTimerManager];
        if (manager.Forgotwordtimeout == 0) {
            manager.Forgotwordtimeout = _timeout;
            [manager countDown:3];
        }
        _timeout = 0;//置为0，释放controller
    }
}

//控制器里的计时器

- (void)timerCountDown{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(_timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                _Verification.alpha = 1;
                [_Verification setTitle:@"重新发送" forState:UIControlStateNormal];
                _Verification.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                _Verification.alpha = 0.4;
                [_Verification setTitle:[NSString stringWithFormat:@"%d秒后重发",_timeout] forState:UIControlStateNormal];
            });
            _timeout--;
        }
    });
    dispatch_resume(_timer);
}

//判断数值进行倒计时
- (void)countDown{
    
    if (_timeout > 0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            
            if(_timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
            }else{
                _timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}

//向服务器发送找回密码
- (void)LoginZJ{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self) weakself=self;
    [CartoonUtils requestWithRetrievepasswordPhone:_PhoneTexeField.text andSmscode:_passwordTextField.text andPwd:_NewPasswordTextField.text andCallback:^(id obj)  {
        NSString *str = obj;
        if ([str isEqualToString:@"网络异常，请稍后重试"]) {
            [HUD hide:YES];
            [weakself bounced:str];
            return ;
        }
        if (str == NULL) {
            [HUD hide:YES];
            ZJLoginViewControllerViewController *Login = [[ZJLoginViewControllerViewController alloc]init];
            [weakself.navigationController pushViewController:Login animated:YES];
        }else {
           [HUD hide:YES];
           NSString *urldecode = [str zj_urlDecode];
           [weakself autorAlertViewWithMsg:urldecode];
        }
    }];

    
}
- (void)bounced:(NSString *) Error{
    NSString *str = NSLocalizedString(Error, nil);;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:Cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



#pragma mark - 限制手机号码输入格式
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * temp = [textField.text stringByAppendingString:string];
    if ((textField == _PhoneTexeField && [temp zj_isStringAccordWith:@"^1[0-9]{0,10}?$"]) ){//手机号码
        return YES;//^1[0-9]\\d{9}$
        
    }else if  ((textField == _passwordTextField && [temp zj_isStringAccordWith:@"^[0-9]{0,4}?$"])){
        return YES;
    }else if (textField == _NewPasswordTextField && _NewPasswordTextField.text.length < 16){
        return YES;
    }
    return NO;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
