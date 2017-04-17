//
//  ZJNewregisteredViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJNewregisteredViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GYZChooseCityController.h"
#import "CartoonUtils.h"
#import "ZJCustomerserviceQQViewController.h"
#import "ZJPersonalinformationViewController.h"
#import "AFNetworking.h"
#import "ZJAbout0urProductViewController.h"

#import "ZJUUID.h"
#import "ZJCaptchaTimerManager.h"
@interface ZJNewregisteredViewController ()<UITextFieldDelegate,CLLocationManagerDelegate,GYZChooseCityDelegate>
{
    
    UIButton *_DeterButton;
    //输入密码
    UITextField *_ConfirmtextField;
    //确认密码
    UITextField *_NewconfirmtextField;
    //勾选视图
    UIButton *_Button;
    
}
// 勾选按钮
@property (nonatomic,weak)UIButton *marqueeButton;
// 箭头图片
@property (nonatomic,weak)UIImageView *imageView;
// 城市按钮
@property (nonatomic,weak)UIButton *cityButton;
//地图定位
@property (nonatomic,strong)CLLocationManager *mrg;
/** 地里编码 */
@property(nonatomic,strong)CLGeocoder *geocoder;
/** 经度 */
@property(assign)double longitude;
/** 纬度 */
@property(assign)double latitude;

@property(nonatomic,strong)UILabel *locationLB;
//输入电话
@property (nonatomic,weak)UITextField *phoneTextField;
//输入验证码
@property (nonatomic,weak)UITextField *VerificationTextFiled;
//验证码按钮
@property (nonatomic,weak)UIButton *Obtain;

@property (nonatomic, assign) __block int timeout;



@end

@implementation ZJNewregisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户注册";
    self.view.backgroundColor = ZJBackGroundColor;
    [self Map];
    [self loadSyte];
}



-  (void)Map{
    self.mrg = [[CLLocationManager alloc] init];
    //征求 户的同意(在前台和后台定位)
    self.mrg.desiredAccuracy = kCLLocationAccuracyBest;
    self.mrg.distanceFilter = 20;
    [self.mrg requestAlwaysAuthorization];
    [self.mrg requestWhenInUseAuthorization];
    [self.mrg startUpdatingLocation];
    [self.mrg startUpdatingLocation];
    //设置地图相关代理
    self.mrg.delegate = self;

}





- (void)loadSyte{
    UIView *UPView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, PX2PT(600))];
    UPView.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:UPView];
    
    //虚线
    [UPView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, PX2PT(200) - 1, zjScreenWidth, 1)]];
    
    [UPView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, PX2PT(400) - 1, zjScreenWidth, 1)]];
    
    [UPView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, PX2PT(600) - 1, zjScreenWidth, 1)]];
    
    [UPView addSubview:[self setSeparatorViewWithFrame:CGRectMake(zjScreenWidth - PX2PT(312) - 1, PX2PT(400), 1, PX2PT(200))]];
    
    
    UILabel *cityLabel = [[UILabel alloc]init];
    cityLabel.textAlignment = NSTextAlignmentLeft;
    [cityLabel zj_labelText:@"所在城市" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    cityLabel.x = PX2PT(40);
    cityLabel.y = PX2PT(200)/3;
    [cityLabel zj_adjustWithMin];
    [UPView addSubview:cityLabel];
    
    //定位图标
    UIImageView *positioningImageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX2PT(40 + 100 + 80) + cityLabel.width , PX2PT(200)/3,PX2PT(35), PX2PT(48))];
    positioningImageView.image = [UIImage imageNamed:@"positioning"];
    
    [UPView addSubview:positioningImageView];
    
    //箭头图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(zjScreenWidth - PX2PT(40) - 8, PX2PT(200)/3, 8, 16)];
    self.imageView = imageView;
   
    imageView.image = [UIImage imageNamed:@"I_arrows_right"];
    
    [UPView addSubview:imageView];
    
    //选择城市按钮
    UIButton *cityButton = [[UIButton alloc]initWithFrame:CGRectMake(zjScreenWidth - imageView.width - PX2PT(20) - 100, PX2PT(200)/3, 100, cityLabel.height)];
    self.cityButton = cityButton;
    
    cityButton.tag = 1;
    [cityButton setTitle:@"选择城市" forState:UIControlStateNormal];
    [cityButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    cityButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [cityButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [UPView addSubview:cityButton];
    
    //定位Label
    UILabel *CityLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX2PT(40 + 100 + 20 + 80) + positioningImageView.width + cityLabel.width, PX2PT(200)/3, zjScreenWidth - positioningImageView.width - cityButton.width - PX2PT(40), cityLabel.height)];
    self.locationLB = CityLabel;
    cityLabel.text = @"正在定位";
    CityLabel.textAlignment = NSTextAlignmentLeft;
    CityLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX weight:50];
    [UPView addSubview:CityLabel];
    
    //手机号文本输入
    UITextField *textField = [self AddUITextFieldWithFrame:CGRectMake(PX2PT(40),PX2PT(200) + 1,zjScreenWidth - 40,PX2PT(200)) andString:@"请输入手机号"];
    self.phoneTextField = textField;
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [UPView addSubview:textField];
    
    //验证码文本输入
    UITextField *verification = [self AddUITextFieldWithFrame:CGRectMake(PX2PT(40),PX2PT(400) + 1,zjScreenWidth - PX2PT(312) - 20,PX2PT(200)) andString:@"请输入验证码"];
    verification.delegate = self;
    verification.keyboardType = UIKeyboardTypeNumberPad;
    verification.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.VerificationTextFiled = verification;
    [UPView addSubview:verification];
    
    //获取验证码按钮
    UIButton *obtain = [[UIButton alloc]initWithFrame:CGRectMake(UPView.width - PX2PT(312), PX2PT(400) + 1, PX2PT(312),PX2PT(200))];
    self.Obtain = obtain;
    [obtain setTitle:@"获取验证码" forState:UIControlStateNormal];
    [obtain setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    obtain.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    obtain.tag = 2;
    [obtain addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [UPView addSubview:obtain];
    
    //收不到验证码
    UIButton *NOobtain = [[UIButton alloc]initWithFrame:CGRectMake(zjScreenWidth - PX2PT(312), UPView.height   + 1, PX2PT(312), PX2PT(80))];
    [NOobtain setTitle:@"收不到验证码 ?" forState:UIControlStateNormal];
    [NOobtain setTitleColor:ZJColor505050 forState:UIControlStateNormal];
     NOobtain.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
     NOobtain.tag = 3;
    [NOobtain addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:NOobtain];
    
    //收不到验证码下的虚线
    UIView *obtainLine = [[UIView alloc]initWithFrame:CGRectMake(10, NOobtain.height - 8, NOobtain.width - 20 , 1)];
    obtainLine.backgroundColor = ZJColor505050;
    [NOobtain addSubview:obtainLine];
    
    //底部视图
    UIView *middle = [[UIView alloc]initWithFrame:CGRectMake(0,UPView.height + PX2PT(80), zjScreenWidth, PX2PT(400))];
    middle.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:middle];
    
    //底部视图虚线
    [middle addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)]];
    
    [middle addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, PX2PT(200), zjScreenWidth, 1)]];
    
    [middle addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, PX2PT(400) - 1, zjScreenWidth, 1)]];
    
    
    //输入密码
    UITextField *passtextField = [self AddUITextFieldWithFrame:CGRectMake(PX2PT(40),0,zjScreenWidth - PX2PT(40) ,PX2PT(200)) andString:@"输入密码"];
    passtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passtextField.delegate = self;
    passtextField.secureTextEntry = YES;
    _ConfirmtextField = passtextField;
    [middle addSubview:passtextField];
    
    //输入密码
    UITextField *confirmtextField = [self AddUITextFieldWithFrame:CGRectMake(PX2PT(40),PX2PT(200),zjScreenWidth - PX2PT(40),PX2PT(200)) andString:@"确认密码"];
    confirmtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmtextField.delegate = self;
    confirmtextField.secureTextEntry = YES;
    _NewconfirmtextField = confirmtextField;
    [middle addSubview:confirmtextField];
    
    
    //创建密码的组成样式
    UILabel *Composition = [[UILabel alloc]init];
    Composition.textAlignment = NSTextAlignmentLeft;
    Composition.x = PX2PT(40);
    Composition.y = UPView.height + NOobtain.height + middle.height +PX2PT(40);
    [Composition zj_labelText:@"密码由6-16位英文字母、数字组成" textColor:ZJColor505050 textSize:ZJTextSize35PX];
    [Composition zj_adjustWithMin];
    [self.view addSubview:Composition];
    
    
    //注册按钮
    UIButton *DeterButton = [[UIButton alloc]initWithFrame:CGRectMake(PX2PT(60), UPView.height + middle.height + PX2PT(80 + 160), PX2PT(1122), PX2PT(128))];
    _DeterButton = DeterButton;
    DeterButton.userInteractionEnabled = YES;
    [DeterButton setTitle:@"注册" forState:UIControlStateNormal];
    [DeterButton setBackgroundImage:[UIImage imageNamed:@"press_gray"] forState:UIControlStateNormal];
    DeterButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize55PX weight:10];
    [DeterButton setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
    DeterButton.tag = 4;
    [_DeterButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:DeterButton];
    
    //选框按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(DeterButton.width / 2 - 40, UPView.height + middle.height + DeterButton.height + PX2PT(80 + 160 + 100), 15, 15)];
    _Button = button;
    button.selected = YES;
    button.layer.borderColor = ZJColorDCDCDC.CGColor;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1;
    [button setImage:[UIImage imageNamed:@"I_agree"] forState:UIControlStateSelected];
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentLeft;
    [label zj_labelText:@"同意" textColor:ZJColor505050 textSize:ZJTextSize35PX];
    label.x = DeterButton.width / 2 - 40 + 15 + PX2PT(20);
    label.y = UPView.height + middle.height + DeterButton.height + PX2PT(80 + 160 + 100);
    [label zj_adjustWithMin];
    [self.view addSubview:label];
    
    UIButton *marquee = [[UIButton alloc]initWithFrame:CGRectMake(DeterButton.width / 2 - 40, UPView.height + middle.height + DeterButton.height + PX2PT(80 + 160 + 100), button.width + label.width + PX2PT(20), 15)];
    //marquee.backgroundColor = [UIColor redColor];
    self.marqueeButton = marquee;
    marquee.tag = 5;
    [marquee addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:marquee];
    
    
    //服务协议按钮
    UIButton *service = [[UIButton alloc]initWithFrame:CGRectMake(DeterButton.width / 2 - 40 + label.width + 15 + PX2PT(20), UPView.height + middle.height + DeterButton.height + PX2PT(80 + 160 + 100), 100, 15)];
    [service setTitle:@"《平台服务协议》" forState:UIControlStateNormal];
    [service setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    service.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    [service addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    service.tag = 6;
    [self.view addSubview:service];
    
    
}

- (void)Click:(UIButton *)sender{
    
    switch (sender.tag) {
        case 1:
        {
            //选择城市三方库
            GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
            [cityPickerVC setDelegate:self];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:nil];
        }
            
            break;
        case 2:
        {
           
            //检测网络状态
            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
             __weak __typeof(self) weakself=self;
            [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
              
                if (status ==AFNetworkReachabilityStatusNotReachable) {
                    [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
                }else{
                    [weakself VerificationCode];
                    
                }
            }];
            //开始检测
            [manager startMonitoring];
          
        }
            break;
        case 3:
        {
            // 跳转客服QQ
            ZJCustomerserviceQQViewController *QQView = [[ZJCustomerserviceQQViewController alloc]init];
            [self.navigationController pushViewController:QQView animated:YES];
        }
            break;
        case 4:
        {
            if ([self.locationLB.text isEqualToString:@"定位失败"]) {
                [self autorAlertViewWithMsg:@"请先选择城市"];
                break;
            }else if (self.phoneTextField.text.length < 11){
                [self autorAlertViewWithMsg:@"请输入正确的手机号"];
                break;
            }else if (self.VerificationTextFiled.text.length < 4){
                [self.VerificationTextFiled becomeFirstResponder];
                [self autorAlertViewWithMsg:@"请输入完整的验证码"];
                break;
            }else if( _NewconfirmtextField.text.length < 6 || _ConfirmtextField.text.length < 6 ){
                [self autorAlertViewWithMsg:@"请输入至少6位数的密码"];
                break;
            }else if(![_NewconfirmtextField.text isEqualToString: _ConfirmtextField.text]){
                [self autorAlertViewWithMsg:@"输入的密码不一致"];
                break;
            }else if (_Button.selected != YES){
                [self autorAlertViewWithMsg:@"请先同意平台服务协议"];
                break;
            }
            
            //检测网络状态
            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
            __weak __typeof(self) weakself=self;
            [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
             
                if (status ==AFNetworkReachabilityStatusNotReachable) {
                    [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
                }else{
                    [weakself Registered];
                    
                }
            }];
            //开始检测
            [manager startMonitoring];
            
        }
            break;
        case 5:
        {
            //同意按钮
            _Button.selected = !_Button.selected;
         
        }
            break;
        case 6:
        {
            //网络协议
            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
            __weak __typeof(self) weakself=self;
            [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
              
                if (status ==AFNetworkReachabilityStatusNotReachable) {
                    [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
                }else{
                    ZJAbout0urProductViewController * About = [[ZJAbout0urProductViewController alloc]init];
                    [weakself.navigationController pushViewController:About animated:YES];
                    
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


//发送验证码请求
- (void)VerificationCode{
    
    if (self.phoneTextField.text.length < 11) {
        [self autorAlertViewWithMsg:@"请输入正确的手机号"];
    }else {
        
        _DeterButton.userInteractionEnabled = YES;
        _DeterButton.selected = YES;
        [_DeterButton setBackgroundImage:[UIImage imageNamed:@"Send-blessings"] forState:UIControlStateNormal];
        
        [_DeterButton setTitle:@"确定" forState:UIControlStateNormal];
       self.Obtain.userInteractionEnabled = NO;
        __weak __typeof(self) weakself=self;
        [CartoonUtils requestWithAnimation:weakself.phoneTextField.text andType:@"rs" andCallback:^(id obj) {
            NSString *str = obj;
            
            if ([str isEqualToString:@"网络异常，请稍后重试"]) {
                [weakself autorAlertViewWithMsg:str];
                weakself.Obtain.userInteractionEnabled = YES;
                return ;
            }
            if(str != NULL){
                NSString *urldecode = [str zj_urlDecode];
                [weakself bounced:urldecode];
              weakself.Obtain.userInteractionEnabled = YES;
            }else {
                _timeout = 60; //倒计时时间
                [weakself timerCountDown];
            }
            
        }];
    }
}

- (void)bounced:(NSString *) Error{
    NSString *str = NSLocalizedString(Error, nil);;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:Cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

//页面出现前取出计时器单例的时间进行判断是否还在倒计时
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 创建单例对象
    ZJCaptchaTimerManager *manager = [ZJCaptchaTimerManager sharedTimerManager];
    int temp = manager.NewUserwordtimeout;
    if (temp > 0) {
        _timeout= temp; //倒计时时间
        self.Obtain.alpha = 0.4;
        self.Obtain.userInteractionEnabled = NO;
        [self timerCountDown];
    }else {
        self.Obtain.alpha = 1;
        self.Obtain.userInteractionEnabled = YES;
    }
}

//页面消失前记录倒计时时间到单例里
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //手动停止定位
    [self.mrg stopUpdatingLocation];
    if (self.timeout > 0) {
        ZJCaptchaTimerManager *manager = [ZJCaptchaTimerManager sharedTimerManager];
        if (manager.NewUserwordtimeout == 0) {
            manager.NewUserwordtimeout = _timeout;
            //标记当前控制器为1
            [manager countDown:1];
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
                self.Obtain.alpha = 1;
                [self.Obtain setTitle:@"重新发送" forState:UIControlStateNormal];
                self.Obtain.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.Obtain.alpha = 0.4;
                [self.Obtain setTitle:[NSString stringWithFormat:@"%d秒后重发",_timeout] forState:UIControlStateNormal];
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




//发送注册请求
- (void)Registered{
    UIDevice *device = [[UIDevice alloc]init];
    NSString *name = device.name;
    NSString *identifierForVendor = [ZJUUID getUUID];
    _DeterButton.userInteractionEnabled = NO;
    __weak __typeof(self) weakself=self;
    [CartoonUtils requestWithRegistered:weakself.VerificationTextFiled.text andPhone:weakself.phoneTextField.text andCity:weakself.locationLB.text andPassword:_NewconfirmtextField.text andCallback:^(id obj) {
        NSString *str = obj;
    
        if ([str isEqualToString:@"网络异常，请稍后重试"]) {
            [weakself autorAlertViewWithMsg:str];
            return ;
        }
        if (str != NULL) {
            NSString *urldecode = [str zj_urlDecode];
            [weakself autorAlertViewWithMsg:urldecode];
            _DeterButton.userInteractionEnabled = YES;
        }else {
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
         NSInteger phone = [self.phoneTextField.text integerValue];
         [userDefaults setInteger:phone forKey:@"phoneNumber"];
         [userDefaults synchronize];
         [CartoonUtils requestWithPasswordLoginPhone:weakself.phoneTextField.text andPassword:_NewconfirmtextField.text andDevicename:name andMeid:identifierForVendor andCallback:^(id obj) {
        }];
            ZJPersonalinformationViewController *person = [ZJPersonalinformationViewController new];
            person.Phone = _phoneTextField.text;
            [self.navigationController pushViewController:person animated:YES];
        }
    }
  ];
}




#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    if (city.capital != NULL) {
        self.locationLB.text = [NSString stringWithFormat:@"%@ %@",city.capital,city.cityName];
    }else {
        self.locationLB.text = city.cityName;
    }
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - GYZCityPickerDelegate 错误时返回的方法
- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 限制手机号码输入格式
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * temp = [textField.text stringByAppendingString:string];
    if ((textField == self.phoneTextField &&[temp zj_isStringAccordWith:@"^1[0-9]{0,10}?$"])){//手机号码
        return YES;//^1[0-9]\\d{9}$
        
    }else if (textField == self.VerificationTextFiled &&[temp zj_isStringAccordWith:@"^[0-9]{0,4}?$"]){
        return YES;
    }else if (textField == _ConfirmtextField && _ConfirmtextField.text.length < 16){
        return YES;
    }else if (textField == _NewconfirmtextField && _NewconfirmtextField.text.length < 16){
        return YES;
    }
    return NO;
    
}



//懒加载
- (CLLocationManager *)mrg{
    if (!_mrg) {
        _mrg = [[CLLocationManager alloc]init];
    }
    return _mrg;
}

- (CLGeocoder*)geocoder{
    if(!_geocoder){
        _geocoder = [[CLGeocoder alloc]init];
    }
    return  _geocoder;
}


//监控到户点击弹出框的动作(允许、不允许)
- (void) locationManager:(CLLocationManager * )manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusDenied:
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            //设置定位的频率(发送请求的次数)
            self.mrg.distanceFilter = 5;
            //定位开始
            [self.mrg startUpdatingLocation];
        break;
      default:
            break;
  }
   
}


// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
//    NSLog(@"经度:%f",newLocation.coordinate.longitude);
//    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    CLGeocoder* geo = [[CLGeocoder alloc]init];
    //        //        地理位置 　　　　@property (nonatomic, readonly) CLLocation *location;
    //        //
    //        //        区域　　　　　　 @property (nonatomic, readonly) CLRegion *region;
    //        //
    //        //        详细的地址信息   @property (nonatomic, readonly) NSDictionary *addressDictionary;
    //        //
    //        //        地址名称　　　　@property (nonatomic, readonly) NSString *name;
    //        //
    //        //        城市　　　　　　@property (nonatomic, readonly) NSString *locality;
    [geo reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *firstPlacemark=[placemarks firstObject];
    
        if (firstPlacemark.locality!=nil) {
            _locationLB.text = [NSString stringWithFormat:@"%@ %@",firstPlacemark.administrativeArea,firstPlacemark.locality];
        }else {
            _locationLB.text = firstPlacemark.locality;
        }
        
    }];
    
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.locationLB.text=@"定位失败";
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


//创建文本输入框
- (UITextField *)AddUITextFieldWithFrame:(CGRect)frame andString:(NSString *) string{
    UITextField *TextField = [[UITextField alloc]init];
    TextField.frame = frame;
    
    NSMutableAttributedString *passplaceholder = [[NSMutableAttributedString alloc] initWithString:string];
    [passplaceholder addAttribute:NSForegroundColorAttributeName
                            value:ZJColorDCDCDC
                            range:NSMakeRange(0, string.length)];
    [passplaceholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:ZJTextSize45PX]
                            range:NSMakeRange(0, string.length)];
    TextField.attributedPlaceholder = passplaceholder;
    
    return TextField;
}

//创建虚线
-(UIView *)setSeparatorViewWithFrame:(CGRect)frame  {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = ZJColorDCDCDC;
    view.frame = frame;
    return view;
    
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
