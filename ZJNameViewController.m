//
//  ZJNameViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/21.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJNameViewController.h"
#import "CartoonUtils.h"
#import "AFNetworking.h"
#import "ZJUser.h"
#import "MBProgressHUD.h"

#import "ZJUUID.h"
#import "ZJLoginViewControllerViewController.h"
@interface ZJNameViewController ()<UITextFieldDelegate>
{
    UITextField *_NametextField;
}
@property (nonatomic,strong)NSString *UserName;




@end

@implementation ZJNameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"姓名";
    //从归档对象中取出用户之前的姓名
    NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
    NSData *data = [NSData dataWithContentsOfFile:documentsPath];
    ZJUser * User = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *urldecode = [User.Name zj_urlDecode];
    self.UserName = urldecode;
    self.view.backgroundColor = ZJBackGroundColor;
    [self loadSyte];
}

- (void)loadSyte{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, PX2PT(40), zjScreenWidth, PX2PT(128));
    view.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:view];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = CGRectMake(20, PX2PT(40), zjScreenWidth - 40, PX2PT(128));
    textField.text = self.UserName;
    _NametextField = textField;
    textField.delegate = self;
    [textField becomeFirstResponder];
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:textField];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(SaveClick:)];
    rightItem.tintColor = ZJColorFFFFFF;
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)SaveClick:(UIBarButtonItem *)bar{
    
    if (_NametextField.text.length < 1) {
        [self autorAlertViewWithMsg:@"请输入姓名"];
        return;
    }else if ([_NametextField.text isEqualToString:self.UserName]){
        
        //是否提示用户姓名一样?
        [self autorAlertViewWithMsg:@"与当前名称重复，换个名称吧"];
        return;
    }
    
    __weak __typeof(self) weakself=self;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      
        if (status ==AFNetworkReachabilityStatusNotReachable) {
            [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
        }else{
            [weakself ModifyTheName];
        }
    }];
    //开始检测
    [manager startMonitoring];
}



- (void)ModifyTheName{
    [self.navigationItem.rightBarButtonItem.customView setAlpha:0.0];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在保存...";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *identifierForVendor = [ZJUUID getUUID];
    NSString *Token = [ud stringForKey:@"TOKEN"];
    __weak __typeof(self) weakself=self;
    [CartoonUtils requestWithModifyUser:_NametextField.text andType:@"name" andToken:Token andMeid:identifierForVendor andCallback:^(id obj) {
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
        }else if(str != NULL){
            [HUD hide:YES];
            NSString *urldecode = [str zj_urlDecode];
            [weakself autorAlertViewWithMsg:urldecode];
            [self.navigationItem.rightBarButtonItem.customView setAlpha:1.0];
        }else{
            [HUD hide:YES];
            weakself.name(_NametextField.text);
            NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
            NSData *data = [NSData dataWithContentsOfFile:documentsPath];
            ZJUser * User = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            User.Name = _NametextField.text;
            NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:User];
            [data1 writeToFile:documentsPath atomically:YES];
        [weakself.navigationController popViewControllerAnimated:YES];
        }
    }];

    
}

//token错误时的弹框
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

#pragma mark - 限制手机号码输入格式
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if  (textField == _NametextField &&  _NametextField.text.length < 10 ){
        return YES;
    }
    return NO;
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
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
