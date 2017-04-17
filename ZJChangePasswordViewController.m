//
//  ZJChangePasswordViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/22.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJChangePasswordViewController.h"
#import "CartoonUtils.h"
#import "AFNetworking.h"
#import "ZJLoginViewControllerViewController.h"

#import "ZJUUID.h"
#import "MBProgressHUD.h"
#import "ZJCaptchaTimerManager.h"
@interface ZJChangePasswordViewController ()<UITextFieldDelegate>
{
    // 验证码按钮
    UIButton *_VoButton;
    //新密码文本
    UITextField *_NewPasswordTextField;
    //校验码
    UITextField *_VoTextField;
    //隐藏密码按钮
    UIButton *_SecondButton;
    UIButton *_determine;
}
@property (nonatomic, assign) __block int timeout;


@end

@implementation ZJChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = ZJBackGroundColor;
    
    [self loadSyte];
  
}


- (void)SendVerificationCode{
    __weak __typeof(self) weakself=self;
     _VoButton.userInteractionEnabled = NO;
    [CartoonUtils requestWithAnimation:weakself.Phone andType:@"cp" andCallback:^(id obj) {
        NSString *str = obj;
       
        if ([str isEqualToString:@"网络异常，请稍后重试"]) {
            [weakself autorAlertViewWithMsg:str];
            _VoButton.userInteractionEnabled = YES;
            return ;
        }
        if (str == NULL) {
            _timeout = 60; //倒计时时间
            [weakself timerCountDown];
        }else {
            NSString *urldecode = [str zj_urlDecode];
            [weakself autorAlertViewWithMsg:urldecode];
            _VoButton.userInteractionEnabled = YES;
        }
    }];
}

//页面出现前取出计时器单例的时间进行判断是否还在倒计时
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 创建单例对象
    ZJCaptchaTimerManager *manager = [ZJCaptchaTimerManager sharedTimerManager];
    int temp = manager.ChangePasswordtimeout;
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
        if (manager.ChangePasswordtimeout == 0) {
            manager.ChangePasswordtimeout = _timeout;
            [manager countDown:4];
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





//进入界面显示内容
- (void)loadSyte{

    UIView *Checkcode = [[UIView alloc]initWithFrame:CGRectMake(0, PX2PT(160), zjScreenWidth, PX2PT(200))];
    Checkcode.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:Checkcode];
    
    UILabel *CheckLabel = [[UILabel alloc]init];
    CheckLabel.textAlignment = NSTextAlignmentLeft;
    [CheckLabel zj_labelText:@"校验码" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    CheckLabel.x = PX2PT(40);
   CheckLabel.centerY = PX2PT(200)/3;
    CheckLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX weight:30];
    [CheckLabel zj_adjustWithMin];
    [Checkcode addSubview:CheckLabel];
    //虚线
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)];
    view.backgroundColor = ZJColorDCDCDC;
    [Checkcode addSubview:view];
    
    UIView *other = [[UIView alloc]initWithFrame:CGRectMake(0, Checkcode.height - 1, zjScreenWidth, 1)];
    other.backgroundColor = ZJColorDCDCDC;
    [Checkcode addSubview:other];
    
    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(zjScreenWidth - PX2PT(312), 0, 1, PX2PT(200))];
    right.backgroundColor = ZJColorDCDCDC;
    [Checkcode addSubview:right];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(PX2PT(40) + CheckLabel.width + PX2PT(40),0,zjScreenWidth - PX2PT(550),PX2PT(200))];
    NSString *holderText = @"请输入验证码";
    _VoTextField = textField;
    textField.delegate = self;
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
    
    [Checkcode addSubview:textField];
    
    //获取验证码按钮
    UIButton *obtain = [[UIButton alloc]initWithFrame:CGRectMake(Checkcode.width - PX2PT(312), 0, PX2PT(312),PX2PT(200))];
    _VoButton = obtain;
    [obtain setTitle:@"获取验证码" forState:UIControlStateNormal];
    [obtain setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    obtain.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    obtain.tag = 1;
    [obtain addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [Checkcode addSubview:obtain];
    
    //第二行
    UIView *SecondView = [[UIView alloc]initWithFrame:CGRectMake(0, Checkcode.height + PX2PT(160 + 40), zjScreenWidth, PX2PT(200))];
    SecondView.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:SecondView];
    
    //虚线
    UIView *SecondLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)];
    SecondLine.backgroundColor = ZJColorDCDCDC;
    [SecondView addSubview:SecondLine];
    
    UIView *SecondotherLine = [[UIView alloc]initWithFrame:CGRectMake(0, Checkcode.height - 1, zjScreenWidth, 1)];
    SecondotherLine.backgroundColor = ZJColorDCDCDC;
    [SecondView addSubview:SecondotherLine];
    
    UILabel *SecondLabel = [[UILabel alloc]init];
    SecondLabel.textAlignment = NSTextAlignmentLeft;
    [SecondLabel zj_labelText:@"新密码" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    SecondLabel.x = PX2PT(40);
    SecondLabel.centerY = PX2PT(200)/3;
    SecondLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX weight:30];
    [SecondLabel zj_adjustWithMin];
    [SecondView addSubview:SecondLabel];
    
    UITextField *SecondtextField = [[UITextField alloc]initWithFrame:CGRectMake(PX2PT(40) + CheckLabel.width + PX2PT(40),0,zjScreenWidth - PX2PT(312 + 150),PX2PT(200))];
    NSString *Text = @"请输入新密码";
    SecondtextField.secureTextEntry = YES;
    _NewPasswordTextField = SecondtextField;
    SecondtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    SecondtextField.delegate = self;
    NSMutableAttributedString *loginSecond = [[NSMutableAttributedString alloc] initWithString:Text];
    [loginSecond addAttribute:NSForegroundColorAttributeName
                        value:ZJColorDCDCDC
                        range:NSMakeRange(0, loginSecond.length)];
    [loginSecond addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:ZJTextSize45PX]
                        range:NSMakeRange(0, loginSecond.length)];
    SecondtextField.attributedPlaceholder = loginSecond;
    [SecondView addSubview:SecondtextField];
    
    UIButton *SecondButton = [[UIButton alloc]initWithFrame:CGRectMake(SecondView.width - PX2PT(100) - PX2PT(40), SecondView.height/3, PX2PT(100), PX2PT(58))];
    [SecondButton setImage:[UIImage imageNamed:@"I_close"] forState:UIControlStateNormal];
    [SecondButton setImage:[UIImage imageNamed:@"I_open"] forState:UIControlStateSelected];
    
    [SecondView addSubview:SecondButton];
    SecondButton.tag = 2;
    [SecondButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    //创建密码的组成样式
    UILabel *Composition = [[UILabel alloc]init];
    Composition.textAlignment = NSTextAlignmentLeft;
    Composition.x = PX2PT(40);
    Composition.y = Checkcode.height + SecondView.height + PX2PT(160 + 40 + 40);
    [Composition zj_labelText:@"密码由6-16位英文字母、数字组成" textColor:ZJColor505050 textSize:ZJTextSize35PX];
    [Composition zj_adjustWithMin];
    [self.view addSubview:Composition];
    
    //第三行
    UIView *DetermineView = [[UIView alloc]initWithFrame:CGRectMake(0,  Checkcode.height + SecondView.height + Composition.height +PX2PT(160 + 40 + 40 + 40), zjScreenWidth,PX2PT(428))];
    DetermineView.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:DetermineView];
    
    //虚线
    UIView *DetermineLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)];
    DetermineLine.backgroundColor = ZJColorDCDCDC;
    [DetermineView addSubview:DetermineLine];
    
    UIView *DetermineotherLine = [[UIView alloc]initWithFrame:CGRectMake(0, DetermineView.height - 1, zjScreenWidth, 1)];
    DetermineotherLine.backgroundColor = ZJColorDCDCDC;
    [DetermineView addSubview:DetermineotherLine];
    
    UIButton *DeterButton = [[UIButton alloc]initWithFrame:CGRectMake(PX2PT(60), PX2PT(100), PX2PT(1122), PX2PT(128))];
    _determine = DeterButton;
    
    DeterButton.backgroundColor = ZJColor00D3A3;
    DeterButton.layer.masksToBounds = YES;
    DeterButton.layer.cornerRadius = PX2PT(20);
    [DeterButton setTitle:@"确定" forState:UIControlStateNormal];
    DeterButton.tag = 3;
    [DeterButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [DetermineView addSubview:DeterButton];
    
}



- (void)Click:(UIButton *)sender{
    
    switch (sender.tag) {
        case 1:
        {
            UILabel *phoneLabel = [[UILabel alloc]init];
            phoneLabel.textAlignment = NSTextAlignmentLeft;
            [phoneLabel zj_labelText:[NSString stringWithFormat:@"请输入%@收到的短信校验码",self.Phone] textColor:ZJColor505050 textSize:ZJTextSize45PX];
            [phoneLabel zj_adjustWithMin];
            phoneLabel.x = PX2PT(40);
            phoneLabel.centerY = PX2PT(160)/2;
            [self.view addSubview:phoneLabel];
        
            __weak __typeof(self) weakself=self;
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
            if (_NewPasswordTextField.text.length < 6) {
                [_NewPasswordTextField becomeFirstResponder];
                [self autorAlertViewWithMsg:@"密码长度至少6位"];
                break;
            }else if(_VoTextField.text.length < 4){
                [_VoTextField becomeFirstResponder];
                [self autorAlertViewWithMsg:@"请输入正确的验证密码"];
                break;
            }
            
            __weak __typeof(self) weakself=self;
        
            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
            [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
              
                if (status ==AFNetworkReachabilityStatusNotReachable) {
                    [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
                }else{
                  [weakself ChangeThePassword];
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



- (void)ChangeThePassword{
     __weak __typeof(self) weakself=self;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *identifierForVendor = [ZJUUID getUUID];
    NSString *Token = [ud stringForKey:@"TOKEN"];
     _determine.userInteractionEnabled = NO;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在保存...";
    [CartoonUtils requestWithModifythe:self.Phone andSmscode:_VoTextField.text andPassword:_NewPasswordTextField.text andToken:Token andMeid:identifierForVendor andCallback:^(id obj) {
        NSString *str = obj;
   
        if ([str  isEqualToString:@"网络异常，请稍后重试"]) {
            [HUD hide:YES];
            [weakself bounced:str];
            return ;
        }
        if ([str isEqualToString:@"token错误，请重新登录"]) {
            [HUD hide:YES];
            NSString *urldecode = [str zj_urlDecode];
            [weakself bounced:urldecode];
            return;
        }else if(str != NULL){
            NSString *urldecode = [str zj_urlDecode];
            [weakself autorAlertViewWithMsg:urldecode];
            _determine.userInteractionEnabled = YES;
        }else{
            [HUD hide:YES];
            [CartoonUtils requestWithThecanToken:Token andMeid:identifierForVendor andCallback:^(id obj) {
                NSString *str = obj;
            }];
            NSFileManager * fileManager = [[NSFileManager alloc]init];
            NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
            [fileManager removeItemAtPath:documentsPath error:nil];
            ZJLoginViewControllerViewController *Login = [[ZJLoginViewControllerViewController alloc]init];
            [weakself.navigationController pushViewController:Login animated:YES];
        }
    }];

}

- (void)bounced:(NSString *) Error{
    NSString *str = NSLocalizedString(Error, nil);;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([str isEqualToString:@"token错误，请重新登录"]) {
            ZJLoginViewControllerViewController *Login = [ZJLoginViewControllerViewController new];
            [self.navigationController pushViewController:Login animated:YES];
        }
        
    }];
    [alert addAction:Cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 限制手机号码输入格式
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * temp = [textField.text stringByAppendingString:string];
    if ((textField == _VoTextField && [temp zj_isStringAccordWith:@"^[0-9]{0,4}?$"]) ){//手机号码
        return YES;//^1[0-9]\\d{9}$
        
    }else if (textField == _NewPasswordTextField && _NewPasswordTextField.text.length < 16){
        return YES;
    }
    return NO;
    
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
