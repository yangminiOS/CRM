//
//  ZJCheckcodeViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/22.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCheckcodeViewController.h"
#import "CartoonUtils.h"
#import "AFNetworking.h"
#import "ZJLoginViewControllerViewController.h"
#import "ZJUUID.h"
#import "MBProgressHUD.h"
#import "ZJCaptchaTimerManager.h"
@interface ZJCheckcodeViewController ()<UITextFieldDelegate>
{
    //完成按钮
    UIButton *_phoneButton;
    //验证码文本输入
    UITextField *_phoneTextField;
    //验证码按钮
    UIButton *_VoButton;
}
@property (nonatomic, assign) __block int timeout;

@property (nonatomic,weak)UILabel *timerLabel;



@end

@implementation ZJCheckcodeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号";
    //修改手机号
    self.view.backgroundColor = ZJBackGroundColor;
    [self loadSyte];
    [_phoneTextField becomeFirstResponder];
}


- (void)SendVerificationCode{
    __weak __typeof(self) weakself=self;
    _VoButton.userInteractionEnabled = NO;
    //向网络发送请求
    [CartoonUtils requestWithAnimation:weakself.phone andType:@"up" andCallback:^(id obj) {
        NSString *str = obj;
        if ([str isEqualToString:@"网络异常，请稍后重试"]) {
            [weakself autorAlertViewWithMsg:str];
            return ;
        }
        if (str != NULL) {
            NSString *urldecode = [str zj_urlDecode];
            [weakself autorAlertViewWithMsg:urldecode];
            _VoButton.userInteractionEnabled = YES;
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
    int temp = manager.ChangePhonetimeout;
    if (temp > 0) {
        _timeout= temp; //倒计时时间
        _VoButton.alpha = 0.4;
        _VoButton.userInteractionEnabled = NO;
        [self timerCountDown];
    }else {
        _VoButton.alpha = 1;
        _VoButton.userInteractionEnabled = YES;
    }
}

//页面消失前记录倒计时时间到单例里
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.timeout > 0) {
        ZJCaptchaTimerManager *manager = [ZJCaptchaTimerManager sharedTimerManager];
        if (manager.ChangePhonetimeout == 0) {
            manager.ChangePhonetimeout = _timeout;
            [manager countDown:5];
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
                _VoButton.alpha = 1;
                [_VoButton setTitle:@"重新发送" forState:UIControlStateNormal];
                _VoButton.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                _VoButton.alpha = 0.4;
                [_VoButton setTitle:[NSString stringWithFormat:@"%d秒后重发",_timeout] forState:UIControlStateNormal];
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





- (void)loadSyte{

    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, PX2PT(180), zjScreenWidth, PX2PT(200 + 100 + 128 + 200))];
    view.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:view];
    //虚线
    UIView *LineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)];
    LineView.backgroundColor = ZJColorDCDCDC;
    [view addSubview:LineView];
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, PX2PT(200) - 1, zjScreenWidth, 1)];
    middleView.backgroundColor = ZJColorDCDCDC;
    [view addSubview:middleView];
    
    UIView *lastView = [[UIView alloc]initWithFrame:CGRectMake(0, PX2PT(200 + 100 + 128 + 200) - 1, zjScreenWidth, 1)];
    lastView.backgroundColor = ZJColorDCDCDC;
    [view addSubview:lastView];
    
    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(zjScreenWidth - PX2PT(312), 0, 1, PX2PT(200))];
    right.backgroundColor = ZJColorDCDCDC;
    [view addSubview:right];
    
    UILabel *Checkcode = [[UILabel alloc]init];
    Checkcode.textAlignment = NSTextAlignmentLeft;
    [Checkcode zj_labelText:@"校验码" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    Checkcode.x = PX2PT(40);
    Checkcode.centerY = PX2PT(200)/3;
    Checkcode.font = [UIFont systemFontOfSize:ZJTextSize45PX weight:30];
    [Checkcode zj_adjustWithMin];
    [view addSubview:Checkcode];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(PX2PT(40) + Checkcode.width + PX2PT(40),0,zjScreenWidth - PX2PT(312) - 100,PX2PT(200))];
    NSString *holderText = @"短信校验码";
    _phoneTextField = textField;
    _phoneTextField.delegate = self;
    textField .keyboardType = UIKeyboardTypeNumberPad;
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:ZJColorDCDCDC
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:ZJTextSize45PX]
                        range:NSMakeRange(0, holderText.length)];
    textField.attributedPlaceholder = placeholder;
   
    [view addSubview:textField];
    
    UIButton *phoneButton = [[UIButton alloc]initWithFrame:CGRectMake(PX2PT(60), PX2PT(200 + 100), PX2PT(1122), PX2PT(128))];
    _phoneButton = phoneButton;
    phoneButton.tag = 2;
    [phoneButton setTitle:@"完成" forState:UIControlStateNormal];
    [phoneButton setTitleColor:ZJColorDCDCDC forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(PhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneButton];
    
    //获取验证码按钮
    UIButton *obtain = [[UIButton alloc]initWithFrame:CGRectMake(zjScreenWidth - PX2PT(312), 0, PX2PT(312),PX2PT(200))];
    _VoButton  = obtain;
    obtain.tag = 1;
    [obtain setTitle:@"获取验证码" forState:UIControlStateNormal];
    [obtain setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    obtain.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [obtain addTarget:self action:@selector(PhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:obtain];
   
    
}





- (void)PhoneClick:(UIButton *)sender{
    __weak __typeof(self) weakself=self;
    if (sender.tag == 1) {
        
            UILabel *label = [[UILabel alloc]init];
            label.textAlignment = NSTextAlignmentCenter;
            [label zj_labelText:[NSString stringWithFormat:@"请输入%@收到的短信校验码",self.phone] textColor:ZJColor505050 textSize:ZJTextSize35PX];
            label.x = PX2PT(40);
            label.y = PX2PT(60);
            [label zj_adjustWithMin];
            [self.view addSubview:label];
        
        //检测网络状态
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
           
            if (status ==AFNetworkReachabilityStatusNotReachable) {
                [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
            }else{
               [weakself SendVerificationCode];
                
            }
        }];
        //开始检测
        [manager startMonitoring];
    }else{
        if (_phoneTextField.text.length < 4) {
            [_phoneTextField becomeFirstResponder];
            [self autorAlertViewWithMsg:@"请输入正确的验证码"];
        }else {
            //检测网络状态
            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
            [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
             
                if (status ==AFNetworkReachabilityStatusNotReachable) {
                    [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
                }else{
                     [weakself ReplacePhoneNumber];
                    
                }
            }];
            //开始检测
            [manager startMonitoring];
           
        }
    }
    
    
}


- (void)ReplacePhoneNumber{
    // 获取Token值
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *Token = [ud stringForKey:@"TOKEN"];
    //获取UUID
    NSString *identifierForVendor = [ZJUUID getUUID];
    _phoneButton.userInteractionEnabled = NO;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在保存...";
    __weak __typeof(self) weakself=self;
    [CartoonUtils requestWithReplacePhone:weakself.phone andVerification:_phoneTextField.text andToken:Token andMeid:identifierForVendor andCallback:^(id obj) {
        NSString *str = obj;
        
        if ([str isEqualToString:@"网络异常，请稍后重试"]) {
            [HUD hide:YES];
            [weakself bounced:str];
            return ;
        }
        if ([str isEqualToString:@"token错误，请重新登录"]) {
            [HUD hide:YES];
             NSString *urldecode = [str zj_urlDecode];
            [weakself bounced:urldecode];
            return;
        }else if (str != NULL){
            [HUD hide:YES];
            NSString *urldecode = [str zj_urlDecode];
            [weakself autorAlertViewWithMsg:urldecode];
        
        }else {
            [HUD hide:YES];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger phone = [_phoneTextField.text integerValue];
        [userDefaults setInteger:phone forKey:@"phoneNumber"];
        NSFileManager * fileManager = [[NSFileManager alloc]init];
        NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
        [fileManager removeItemAtPath:documentsPath error:nil];
        [CartoonUtils requestWithThecanToken:Token andMeid:identifierForVendor andCallback:^(id obj) {
            
            NSString *str = obj;
            }];
            [weakself autorAlertViewWithMsg:@"修改成功，请使用新账号重新登陆"];
            ZJLoginViewControllerViewController *Login = [[ZJLoginViewControllerViewController alloc]init];
            [weakself.navigationController pushViewController:Login animated:YES];
        }
    }];
}

// 根据返回值错误信息提示
- (void)bounced:(NSString *) Error{
    
    NSString *str = NSLocalizedString(Error, nil);;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([str isEqualToString:@"token错误，请重新登录"]) {
            ZJLoginViewControllerViewController *Login = [[ZJLoginViewControllerViewController alloc]init];
            [self.navigationController pushViewController:Login animated:YES];
        }
      
    }];
    
    [alert addAction:Cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _phoneButton.layer.masksToBounds = YES;
     _phoneButton.layer.cornerRadius = PX2PT(20);
    _phoneButton.userInteractionEnabled = YES;
    [_phoneButton setBackgroundImage:[UIImage imageNamed:@"Send-blessings"] forState:UIControlStateNormal];
    [_phoneButton setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
    return YES;
}


#pragma mark - 限制手机号码输入格式
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * temp = [textField.text stringByAppendingString:string];
    if ((textField == _phoneTextField && [temp zj_isStringAccordWith:@"^[0-9]{0,4}?$"]) ){//手机号码
        return YES;//^1[0-9]\\d{9}$
        
    }
    return NO;
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
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
