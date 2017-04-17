//
//  ZJReplaceViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/22.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJReplaceViewController.h"
#import "ZJCheckcodeViewController.h"
#import "ZJUser.h"
@interface ZJReplaceViewController ()<UITextFieldDelegate>
{
    UITextField *_PhoneTextField;
}
@property (nonatomic,weak)UIButton *nextButton;

@end

@implementation ZJReplaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换手机号";
    
    self.view.backgroundColor = ZJBackGroundColor;

    [self loadSyte];
    [_PhoneTextField becomeFirstResponder];
}

- (void)loadSyte{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    [label zj_labelText:@"请输入您需要绑定的新手机号" textColor:ZJColor505050 textSize:ZJTextSize35PX];
    label.x = zjScreenWidth / 3;
    label.y = PX2PT(60);
    [label zj_adjustWithMin];
    [self.view addSubview:label];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, PX2PT(60) + label.height + PX2PT(60), zjScreenWidth, PX2PT(200 + 100 + 128 + 200))];
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
    
    
    
    UILabel *personLable = [[UILabel alloc]init];
    personLable.textAlignment = NSTextAlignmentLeft;
    [personLable zj_labelText:@"新手机号" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    personLable.x = PX2PT(40);
    personLable.centerY = PX2PT(200)/3;
    [personLable zj_adjustWithMin];
    [view addSubview:personLable];
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    [phoneLabel zj_labelText:@"+ 86" textColor:ZJColor00D3A3 textSize:ZJTextSize45PX];
    phoneLabel.x = PX2PT(40) + personLable.width + PX2PT(20);
    phoneLabel.centerY = PX2PT(200)/3;
    [phoneLabel zj_adjustWithMin];
    [view addSubview:phoneLabel];
    
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(40) + personLable.width + PX2PT(20) + phoneLabel.width + PX2PT(20), 0, 1, PX2PT(200))];
    phoneView.backgroundColor = ZJColorDCDCDC;
    [view addSubview:phoneView];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(PX2PT(40) + personLable.width + PX2PT(20) + phoneLabel.width + PX2PT(20) + PX2PT(20), 0, zjScreenWidth - PX2PT(40) + personLable.width + PX2PT(20) + phoneLabel.width + PX2PT(20) + PX2PT(20), PX2PT(200))];
    textField .keyboardType = UIKeyboardTypeNumberPad;
    _PhoneTextField = textField;
    textField.delegate = self;
    NSString *holderText = @"请输入您要绑定的手机号";
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
    self.nextButton = phoneButton;
    [phoneButton setTitle:@"下一步" forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(PhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneButton];
    
    
}

- (void)PhoneClick:(UIButton *)sender{
    
    if (_PhoneTextField.text.length < 11) {
        [_PhoneTextField becomeFirstResponder];
        [self autorAlertViewWithMsg:@"请输入正确的手机号"];
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"]];
    ZJUser * User = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    if ([_PhoneTextField.text isEqualToString: User.Phone]) {
        
        [_PhoneTextField becomeFirstResponder];
        [self autorAlertViewWithMsg:@"输入的手机号不可为当前账户"];
        return;
    }else {
         ZJCheckcodeViewController *checkcode = [ZJCheckcodeViewController new];
         checkcode.phone = _PhoneTextField.text;
         [self.navigationController pushViewController:checkcode animated:YES];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.layer.cornerRadius = PX2PT(20);
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"Send-blessings"] forState:UIControlStateNormal];
    [self.nextButton setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
    return YES;
}



#pragma mark - 限制手机号码输入格式
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * temp = [textField.text stringByAppendingString:string];
    if ((textField == _PhoneTextField && [temp zj_isStringAccordWith:@"^1[0-9]{0,10}?$"]) ){//手机号码
        return YES;//^1[0-9]\\d{9}$
        
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
