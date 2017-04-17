//
//  ZJVerificationcodeViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJVerificationcodeViewController.h"
//网络请求
#import "CartoonUtils.h"
//归档对象
#import "ZJUser.h"
#import "AFNetworking.h"

#import "ZJUUID.h"
#import "ZJCustomerserviceQQViewController.h"
#import "ZJCaptchaTimerManager.h"
@interface ZJVerificationcodeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *obtainButton;
@property (weak, nonatomic) IBOutlet UIButton *NOgetButton;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;


@property (nonatomic, assign) __block int timeout;
@end

@implementation ZJVerificationcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"验证码";
    self.phoneTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.obtainButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    self.NOgetButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    self.LoginButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize55PX];
    self.LoginButton.userInteractionEnabled = NO;
    self.ImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.ImageView.clipsToBounds  = YES;
}
- (IBAction)AllClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
        {
           
            if (self.phoneTextField.text.length < 11) {
                [self autorAlertViewWithMsg:@"请输入正确的手机号"];
                break;
            }else {
        
                self.LoginButton.userInteractionEnabled = YES;
                //检测网络状态
                AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
                __weak __typeof(self) weakself=self;
                [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                 
                    if (status ==AFNetworkReachabilityStatusNotReachable) {
                        [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
                    }else{
                        [weakself Sendverification];
                    }
                }];
                //开始检测
                [manager startMonitoring];
                }
        }
            break;
        case 2:
        {
            //跳转客服
            ZJCustomerserviceQQViewController *zj = [ZJCustomerserviceQQViewController new];
            [self.navigationController pushViewController:zj animated:YES];
            
        }
            break;
        case 3:
        {
            if (self.phoneTextField.text.length < 11) {
                [self.phoneTextField becomeFirstResponder];
                [self autorAlertViewWithMsg:@"请输入正确的手机号"];
                break;
            }
            if (self.passwordTextField.text.length < 4) {
                [self.passwordTextField becomeFirstResponder];
                [self autorAlertViewWithMsg:@"请输入4位数的验证码"];
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
        default:
            break;
    }
    
}

//发送验证码
- (void)Sendverification{
    __weak __typeof(self) weakself=self;
    self.obtainButton.userInteractionEnabled = NO;
    [CartoonUtils requestWithAnimation:weakself.phoneTextField.text andType:@"ls" andCallback:^(id obj) {
        NSString *str = obj;
        if ([str isEqualToString:@"网络异常，请稍后重试"]) {
            [weakself autorAlertViewWithMsg:str];
            self.obtainButton.userInteractionEnabled = YES;
            return ;
        }
        if (str != NULL) {
            NSString *urldecode = [str zj_urlDecode];
            [weakself autorAlertViewWithMsg:urldecode];
            self.obtainButton.userInteractionEnabled = YES;
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
    int temp = manager.VerificationLoginwordtimeout;
    if (temp > 0) {
        _timeout= temp; //倒计时时间
        self.obtainButton.alpha = 0.4;
        self.obtainButton.userInteractionEnabled = NO;
        [self timerCountDown];
    }else {
        self.obtainButton.alpha = 1;
        self.obtainButton.userInteractionEnabled = YES;
    }
}

//页面消失前记录倒计时时间到单例里
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.timeout > 0) {
        ZJCaptchaTimerManager *manager = [ZJCaptchaTimerManager sharedTimerManager];
        if (manager.VerificationLoginwordtimeout == 0) {
            manager.VerificationLoginwordtimeout = _timeout;
            [manager countDown:2];
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
                self.obtainButton.alpha = 1;
                [self.obtainButton setTitle:@"重新发送" forState:UIControlStateNormal];
                self.obtainButton.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.obtainButton.alpha = 0.4;
                [self.obtainButton setTitle:[NSString stringWithFormat:@"%d秒后重发",_timeout] forState:UIControlStateNormal];
                
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



//登陆
- (void)LoginZJ{
    UIDevice *device = [[UIDevice alloc]init];
    NSString *name = device.name;
    NSString *identifierForVendor = [ZJUUID getUUID];
    self.LoginButton.userInteractionEnabled = NO;
    __weak __typeof(self) weakself=self;
    [CartoonUtils requestWithPhone:weakself.phoneTextField.text andPassword:weakself.passwordTextField.text andDevicename:name andMeid:identifierForVendor andCallback:^(id obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *str = obj;
            if ([str isEqualToString:@"网络异常，请稍后重试"]) {
                [weakself autorAlertViewWithMsg:str];
                self.LoginButton.userInteractionEnabled = YES;
                return ;
            }
            if([str isEqualToString:@"1111111"]){
              [weakself.navigationController popToRootViewControllerAnimated:YES];
            }else{
                NSString *urldecode = [str zj_urlDecode];
                [weakself autorAlertViewWithMsg:urldecode];
                self.LoginButton.userInteractionEnabled = YES;
            }
        }
    }];

    
    
}




#pragma mark - 限制手机号码输入格式
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * temp = [textField.text stringByAppendingString:string];
    if ((textField == self.phoneTextField && [temp zj_isStringAccordWith:@"^1[0-9]{0,10}?$"]) ){//手机号码
        return YES;//^1[0-9]\\d{9}$
        
    }else if  ((textField == self.passwordTextField && [temp zj_isStringAccordWith:@"^[0-9]{0,4}?$"])){
        return YES;
    }
    return NO;
    
}




#pragma mark - 文本框输入开始编辑后调用的方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.LoginButton.userInteractionEnabled = YES;
    [self.LoginButton setBackgroundImage:[UIImage imageNamed:@"Send-blessings"] forState:UIControlStateNormal];
    [self.LoginButton setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
