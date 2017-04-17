//
//  ZJCustomerserviceQQViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/12/7.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomerserviceQQViewController.h"

@interface ZJCustomerserviceQQViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *HelpLabel;

@property (weak, nonatomic) IBOutlet UIButton *HelpButton;
@property (weak, nonatomic) IBOutlet UILabel *Lable1;
@property (weak, nonatomic) IBOutlet UILabel *Lable2;
@property (weak, nonatomic) IBOutlet UILabel *Lable3;
@property (weak, nonatomic) IBOutlet UILabel *Lable4;
@property (weak, nonatomic) IBOutlet UILabel *Lable5;


@end

@implementation ZJCustomerserviceQQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"收不到验证码";
    self.view.backgroundColor = ZJColorFFFFFF;
    self.Lable1.font = [UIFont systemFontOfSize:ZJTextSize55PX];
    self.Lable1.textColor = ZJColor848484;
    self.Lable2.font = [UIFont systemFontOfSize:ZJTextSize55PX];
    self.Lable2.textColor = ZJColor848484;
    self.Lable3.font = [UIFont systemFontOfSize:ZJTextSize55PX];
    self.Lable3.textColor = ZJColor848484;
    self.Lable4.font = [UIFont systemFontOfSize:ZJTextSize55PX];
    self.Lable4.textColor = ZJColor848484;
    self.Lable5.font = [UIFont systemFontOfSize:ZJTextSize55PX];
    self.Lable5.textColor = ZJColor848484;
}




- (IBAction)Customerservice:(id)sender {
    
    NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"2558710290"];
    
    NSURL *url = [NSURL URLWithString:qqstr];
    [[UIApplication sharedApplication] openURL:url];
    
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
