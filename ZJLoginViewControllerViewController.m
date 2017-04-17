//
//  ZJLoginViewControllerViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/12/1.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJLoginViewControllerViewController.h"
#import "ZJVerificationcodeViewController.h"
#import "ZJNewregisteredViewController.h"
#import "ZJForgotpasswordViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "CapthaView.h"
#import "CartoonUtils.h"
#import "ZJPersonViewController.h"
#import "AFNetworking.h"

#import "ZJUUID.h"
#import "MBProgressHUD.h"
@interface ZJLoginViewControllerViewController ()<UITextFieldDelegate>
{
    UIButton *_NewButton;
    UIButton *_VonButton;
    UIButton *_LoginButton;
    CapthaView *_CodeView;
    UITextField *_Verifythelady;
    UIButton *_VerLoginButton;
    UIButton *_UPNewButton;
    UIButton *_UPLoginButton;
    UITextField *_UserTextField;
    UIView *_UserBack;
}

@property (nonatomic,weak)UITextField *PhoneTextField;
@property (nonatomic,weak)UITextField *PasswordTextField;

@end

@implementation ZJLoginViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    self.view.backgroundColor = ZJBackGroundColor;
    
    self.PhoneTextField.delegate = self;
    self.PasswordTextField.delegate = self;
    
    [self loadSyte];
    
    // 导航栏左侧按钮
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(Reutrn)];
    barBtn.tintColor = ZJColorFFFFFF;
    self.navigationItem.leftBarButtonItem = barBtn;
}

- (void)Reutrn{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)loadSyte{
    
    UIView *UpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, PX2PT(520))];
    UIImageView *ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(zjScreenWidth / 3, PX2PT(300),PX2PT(596) / 1.5  ,PX2PT(304) / 1.5)];
    ImageView.image = [UIImage imageNamed:@"haoke-lg"];
    
    [self.view addSubview:ImageView];
    
    UIView *View = [[UIView alloc]initWithFrame:CGRectMake(0,UpView.height - 1, zjScreenWidth, 1)];
  
    [UpView addSubview:View];
    [self.view addSubview:UpView];
    
    //用户
    UIView *PersonView = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(60),UpView.height + PX2PT(100) , PX2PT(1122), PX2PT(128))];
    PersonView.backgroundColor = ZJColorFFFFFF;
    
    //虚线
    [PersonView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, 0, PersonView.width, 1)]];
    [PersonView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, PersonView.height - 1, PersonView.width, 1)]];
    [PersonView addSubview:[self setSeparatorViewWithFrame:CGRectMake(PersonView.width - 1, 0,1 , PersonView.height)]];
    [PersonView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, 0,1 , PersonView.height)]];
    
    UIImageView *PersonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX2PT(40), PX2PT(25), PX2PT(80), PX2PT(78))];
    PersonImageView.image = [UIImage imageNamed:@"I_-log-in"];
    [PersonView addSubview:PersonImageView];
    [self.view addSubview:PersonView];
    
    //密码视图
    UIView *PasswordView = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(60), UpView.height + PX2PT(100) + PersonView.height + PX2PT(20), PX2PT(1122), PX2PT(128))];
    PasswordView.backgroundColor = ZJColorFFFFFF;
    [PasswordView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, 0, PasswordView.width, 1)]];
    [PasswordView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, PasswordView.height - 1, PersonView.width, 1)]];
    [PasswordView addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, 0, 1, PasswordView.height)]];
    [PasswordView addSubview:[self setSeparatorViewWithFrame:CGRectMake(PasswordView.width - 1, 0,1 , PersonView.height)]];
    UIImageView *PasswordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX2PT(40), PX2PT(25), PX2PT(68), PX2PT(80))];
    PasswordImageView.image = [UIImage imageNamed:@"I_password"];
    [PasswordView addSubview:PasswordImageView];
    [self.view addSubview:PasswordView];
    
    //用户输入框
    UITextField  *PersonTextField = [self AddUITextFieldWithFrame:CGRectMake(PX2PT(40 + 40) + PersonImageView.width, 0, PX2PT(1122) - PX2PT(40 + 40) - PersonImageView.width, PX2PT(128)) andString:@"请输入手机号"];
    self.PhoneTextField = PersonTextField;
    PersonTextField.delegate = self;
    PersonTextField.keyboardType = UIKeyboardTypeNumberPad;
    PersonTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
     [PersonView addSubview:PersonTextField];
    
    //密码输入框
    UITextField  *PasswordTextField = [self AddUITextFieldWithFrame:CGRectMake(PX2PT(40 + 40) + PasswordImageView.width, 0, PX2PT(1122) - PX2PT(40 + 40) - PasswordImageView.width, PX2PT(128)) andString:@"请输入密码"];
    PasswordTextField.delegate = self;
    self.PasswordTextField = PasswordTextField;
    PasswordTextField.secureTextEntry = YES;
    PasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [PasswordView addSubview:PasswordTextField];
    
    UIButton *LoginButton =[[UIButton alloc]initWithFrame:CGRectMake(PX2PT(60), UpView.height + PersonView.height + PasswordView.height + PX2PT(100 + 100 + 20), PX2PT(1122), PX2PT(128))];
    _LoginButton = LoginButton;
  //  LoginButton.hidden = YES;
    [LoginButton setBackgroundImage:[UIImage imageNamed:@"Send-blessings"]  forState:UIControlStateNormal];
    [LoginButton setBackgroundImage:[UIImage imageNamed:@"Send-blessings"]  forState:UIControlStateSelected];
    [LoginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [LoginButton addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    LoginButton.tag = 1;
    [self.view addSubview:LoginButton];
    
    UIButton *NewUser = [[UIButton alloc]initWithFrame:CGRectMake(PX2PT(40), UpView.height + PasswordView.height + PersonView.height + PX2PT(100 + 20 + 100 + 40) + LoginButton.height, PX2PT(300), PX2PT(60))];
    _NewButton = NewUser;
    [NewUser setTitle:@"新用户注册" forState:UIControlStateNormal];
    [NewUser setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    NewUser.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [NewUser addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    NewUser.tag = 2;
    [self.view addSubview:NewUser];
    
    UIButton *Verification =  [[UIButton alloc]initWithFrame:CGRectMake(zjScreenWidth - PX2PT(40) - PX2PT(350),  UpView.height + PasswordView.height + PersonView.height + PX2PT(100 + 20 + 100 + 40) + LoginButton.height, PX2PT(350), PX2PT(60))];
    _VonButton = Verification;
    [Verification setTitle:@"使用验证码登陆" forState:UIControlStateNormal];
    [Verification setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
   Verification.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [Verification addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    Verification.tag = 3;
    [self.view addSubview:Verification];
    
    UIButton *FotButton = [[UIButton alloc]initWithFrame:CGRectMake(zjScreenWidth / 2 - PX2PT(130), zjScreenHeight - PX2PT(400),PX2PT(250), PX2PT(60))];
    [FotButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [FotButton setTitleColor:ZJRGBColor(81,81,81,1) forState:UIControlStateNormal];
    FotButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [FotButton addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    FotButton.tag = 4;
    [self.view addSubview:FotButton];
    
    UIView *FotView = [[UIView alloc]initWithFrame:CGRectMake(0,FotButton.height - 3,FotButton.width - 4,1)];
    FotView.backgroundColor = ZJRGBColor(81,81,81,1);
    [FotButton addSubview:FotView];
    
    //验证码
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(60), UpView.height + PersonView.height + PasswordView.height + PX2PT(100 + 100 + 20), PX2PT(650), PX2PT(128))];
    view.hidden = YES;
    view.backgroundColor = [UIColor redColor];
    view.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:view];
    
    [view addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, 0, view.width, 1)]];
    [view addSubview:[self setSeparatorViewWithFrame:CGRectMake(0,view.height - 1, view.width, 1)]];
    [view addSubview:[self setSeparatorViewWithFrame:CGRectMake(view.width - 1, 0, 1, view.height)]];
    [view addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, 0, 1, view.height)]];

    UIView *UserBack = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(60),UpView.height + PersonView.height + PasswordView.height + PX2PT(100 + 100 + 20), PX2PT(650), PX2PT(128))];
    UserBack.hidden = YES;
    _UserBack = UserBack;
    [self.view addSubview:UserBack];
    
    [UserBack addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, 0, UserBack.width, 1)]];
    [UserBack addSubview:[self setSeparatorViewWithFrame:CGRectMake(0,UserBack.height - 1, view.width, 1)]];
    [UserBack addSubview:[self setSeparatorViewWithFrame:CGRectMake(UserBack.width - 1, 0, 1, view.height)]];
    [UserBack addSubview:[self setSeparatorViewWithFrame:CGRectMake(0, 0, 1, UserBack.height)]];
    
    
//    //用户输入框
//    UITextField  *UserTextField = [self AddUITextFieldWithFrame:CGRectMake(PX2PT(64),UpView.height + PersonView.height + PasswordView.height + PX2PT(100 + 100 + 20), PX2PT(650), PX2PT(128)) andString:@"请输入验证码"];
//    UserTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    UserTextField.hidden = YES;
//    _UserTextField = UserTextField;
//    UserTextField.delegate = self;
//    UserTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    
//    [self.view addSubview:UserTextField];
    
    
//    //验证码图标
//    _CodeView = [[CapthaView alloc]initWithFrame:CGRectMake(PX2PT(40 + 650 + 80), UpView.height + PersonView.height + PasswordView.height + PX2PT(100 + 100 + 20), PX2PT(420), PX2PT(120))];
//    _CodeView.hidden = YES;
//    [self.view addSubview:_CodeView];
//    
//    //验证码出现时的登陆按钮
//    UIButton *VerLoginButton =[[UIButton alloc]initWithFrame:CGRectMake(PX2PT(60),  UpView.height + PersonView.height + PasswordView.height + PX2PT(100 + 100 + 20 +100) + view.height,PX2PT(1122) , PX2PT(128))];
//    _VerLoginButton = VerLoginButton;
//    VerLoginButton.hidden = YES;
//    
//    [VerLoginButton setBackgroundImage:[UIImage imageNamed:@"Send-blessings"]  forState:UIControlStateNormal];
//    [VerLoginButton setBackgroundImage:[UIImage imageNamed:@"Send-blessings"]  forState:UIControlStateSelected];
//    [VerLoginButton setTitle:@"登陆" forState:UIControlStateNormal];
//    [VerLoginButton addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
//    VerLoginButton.tag = 5;
//    [self.view addSubview:VerLoginButton];
//    
//    //验证码出现时的新用户注册
//    UIButton *UPNewUser = [[UIButton alloc]initWithFrame:CGRectMake(PX2PT(40), UpView.height + PersonView.height + PasswordView.height + PX2PT(100 + 100 + 20 +100 + 40 + 128) + view.height, PX2PT(300), PX2PT(60))];
//    UPNewUser.hidden = YES;
//    _UPNewButton = UPNewUser;
//    [UPNewUser setTitle:@"新用户注册" forState:UIControlStateNormal];
//    [UPNewUser setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
//    UPNewUser.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
//    [UPNewUser addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
//    UPNewUser.tag = 6;
//    [self.view addSubview:UPNewUser];
//    
//    //验证码出现时的使用验证码
//    UIButton *LoginUser = [[UIButton alloc]initWithFrame:CGRectMake(zjScreenWidth - PX2PT(40) - PX2PT(350),UpView.height + PersonView.height + PasswordView.height + PX2PT(100 + 100 + 20 +100 + 40 + 128) + view.height, PX2PT(350), PX2PT(60))];
//    LoginUser.hidden =YES;
//    _UPLoginButton = LoginUser;
//    [LoginUser setTitle:@"使用验证码登陆" forState:UIControlStateNormal];
//    [LoginUser setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
//    LoginUser.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
//    [LoginUser addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
//    LoginUser.tag = 7;
//    [self.view addSubview:LoginUser];
    
                                                          
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
//static  NSInteger sum = 0;

- (void)Login:(UIButton *)sender{
        switch (sender.tag) {
        case 1:
        {
//            if (sum >= 3) {
//                _LoginButton.hidden = YES;
//                _VonButton.hidden = YES;
//                _NewButton.hidden = YES;
//                
//                _UserBack.hidden = NO;
//                _UserTextField.hidden = NO;
//                _CodeView.hidden = NO;
//                _VerLoginButton.hidden = NO;
//                _UPLoginButton.hidden = NO;
//                _UPNewButton.hidden = NO;
//                break;
//            }

            sender.selected = !sender.selected;
            if (self.PhoneTextField.text.length < 11) {
                [self.PhoneTextField becomeFirstResponder];
                [self autorAlertViewWithMsg:@"请输入正确的手机号"];
                break;
            }
            if (self.PasswordTextField.text.length < 6) {
                [self.PasswordTextField becomeFirstResponder];
                [self autorAlertViewWithMsg:@"密码长度至少为6位"];
                break;
            }
            
            //检测网络状态
            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
            __weak __typeof(self) weakself=self;
            [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
               
                if (status ==AFNetworkReachabilityStatusNotReachable) {
                    [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
                }else{
                    [weakself  LoginZJ];
                 
                }
            }];
            //开始检测
            [manager startMonitoring];
            
        }
            break;
        case 2: //case 6:
        {
            ZJNewregisteredViewController *newregisterd = [ZJNewregisteredViewController new];
            [self.navigationController pushViewController:newregisterd animated:YES];
        }
            break;
        case 3: //case 7:
        {
            ZJVerificationcodeViewController *verficationcode = [ZJVerificationcodeViewController new];
            [self.navigationController pushViewController:verficationcode animated:YES];
        }
            break;
        case 4:
        {
            ZJForgotpasswordViewController *forgotpassword = [ZJForgotpasswordViewController new];
            [self.navigationController pushViewController:forgotpassword animated:YES];
        }
            break;
//        case 5:
//        {
//            if (self.PhoneTextField.text.length < 11) {
//                [self.PhoneTextField becomeFirstResponder];
//                [self autorAlertViewWithMsg:@"请输入正确的手机号"];
//                break;
//            }
//            if (self.PasswordTextField.text.length < 1) {
//                [self.PasswordTextField becomeFirstResponder];
//                [self autorAlertViewWithMsg:@"请输入密码"];
//                break;
//            }
//            
//            NSComparisonResult number = [_UserTextField.text caseInsensitiveCompare:_CodeView.authCodeStr];
//            if ( number != 0) {
//                [self autorAlertViewWithMsg:@"验证码输入不正确"];
//                return;
//            }
//
//            //检测网络状态
//            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//            __weak __typeof(self) weakself=self;
//            [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//                switch ((int)status) {
//                    case AFNetworkReachabilityStatusNotReachable:
//                    {
//                        [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
//                    }
//                        break;
//                    case AFNetworkReachabilityStatusReachableViaWWAN:
//                    {
//                        [weakself  LoginZJ];
//                    }
//                        break;
//                    case AFNetworkReachabilityStatusReachableViaWiFi:
//                    {
//                        [weakself  LoginZJ];
//                    }
//                        break;
//                }
//            }];
//            //开始检测
//            [manager startMonitoring];
//            
//            }
        default:
            break;
    }
}


//登陆请求
- (void)LoginZJ{
    UIDevice *device = [[UIDevice alloc]init];
    NSString *name = device.name;
    NSString *identifierForVendor = [ZJUUID getUUID];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在登陆...";
    _LoginButton.userInteractionEnabled = NO;
    [self.view endEditing:YES];
    __weak __typeof(self) weakself=self;
    [CartoonUtils requestWithPasswordLoginPhone:weakself.PhoneTextField.text andPassword:weakself.PasswordTextField.text andDevicename:name andMeid:identifierForVendor andCallback:^(id obj) {
            NSString *str = obj;
        
        if ([str isEqualToString:@"网络异常，请稍后重试"]) {
            [HUD hide:YES];
            [weakself bounced:str];
            _LoginButton.userInteractionEnabled = YES;
            return ;
        }
            if (str != NULL) {
                [HUD hide:YES];
                NSString *urldecode = [str zj_urlDecode];
                [weakself autorAlertViewWithMsg:urldecode];
               // sum ++ ;
                 _LoginButton.userInteractionEnabled = YES;
            }else {
                [HUD hide:YES];
             [weakself.navigationController popToRootViewControllerAnimated:YES];
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
    if ((textField == self.PhoneTextField && [temp zj_isStringAccordWith:@"^1[0-9]{0,10}?$"]) ){//手机号码
        return YES;//^1[0-9]\\d{9}$
        
    }else if  ((textField == self.PasswordTextField && range.location < 16 )){
        return YES;
    }else if ((textField == _UserTextField && range.location < 4 )){
        return YES;
    }
    return NO;
    
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
