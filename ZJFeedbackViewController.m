//
//  ZJFeedbackViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/22.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJFeedbackViewController.h"
#import "YYTextView.h"
@interface ZJFeedbackViewController ()

//问题描述或建议
@property (nonatomic,weak)UILabel *problemlabel;

//截图按钮
@property (nonatomic,weak)UIButton *Screenshots;
//联系方式
@property (nonatomic,weak)UILabel *contact;
//第三方输入框
@property (nonatomic,strong)YYTextView *textView;
@end

@implementation ZJFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = ZJBackGroundColor;
    
    
    [self loadSyte];
}

- (void)loadSyte{
    UILabel *problemlabel = [[UILabel alloc]init];
    self.problemlabel = problemlabel;
    problemlabel.textAlignment = NSTextAlignmentLeft;
    problemlabel.x = PX2PT(40);
    problemlabel.y = PX2PT(40);
    [problemlabel zj_labelText:@"问题描述或建议:" textColor:ZJColor505050 textSize:ZJTextSize35PX];
    [problemlabel zj_adjustWithMin];
    [self.view addSubview:problemlabel];
    
    //文本输入
    self.textView = [[YYTextView alloc]initWithFrame:CGRectMake(PX2PT(40),PX2PT(40) + problemlabel.height + PX2PT(40),PX2PT(1162),PX2PT(600))];
    self.textView.backgroundColor = ZJColorFFFFFF;
    self.textView.placeholderText = @"请再此处描述您遇到的问题或建议（必填）";
    
    [self.view addSubview:self.textView];
    
    
    UIButton *Screenshots = [[UIButton alloc]initWithFrame:CGRectMake(PX2PT(40), problemlabel.height + self.textView.height + PX2PT(120), PX2PT(256), PX2PT(256))];
    self.Screenshots = Screenshots;
    [Screenshots setImage:[UIImage imageNamed:@"I_add-image"] forState:UIControlStateNormal];
    [self.view addSubview:Screenshots];
    
    UILabel *ScreenshotsLable = [[UILabel alloc]init];
    ScreenshotsLable.textAlignment = NSTextAlignmentLeft;
    ScreenshotsLable.x = PX2PT(40 + 80) + Screenshots.width ;
    ScreenshotsLable.y = problemlabel.height + self.textView.height + PX2PT(120) + Screenshots.height/2.5;
    [ScreenshotsLable zj_labelText:@"添加截图" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    [ScreenshotsLable zj_adjustWithMin];
    [self.view addSubview:ScreenshotsLable];
   
   [self Login];
}

//未登录的
- (void)NotLog{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentLeft;
    [label zj_labelText:@"联系方式 :" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    label.x = PX2PT(40);
    label.y = self.problemlabel.height + self.textView.height + self.Screenshots.height + PX2PT(40 + 40 + 40 + 40);
    [label zj_adjustWithMin];
    [self.view addSubview:label];
    
    UITextField *phonetextField = [[UITextField alloc]initWithFrame:CGRectMake(0, self.problemlabel.height + self.textView.height + self.Screenshots.height + label.height + PX2PT(40 + 40 + 40 + 40 + 40), zjScreenWidth, PX2PT(128))];
    phonetextField.backgroundColor = ZJColorFFFFFF;
    NSString *Text = @"    请输入电话或邮箱（必填）";
    NSMutableAttributedString *loginSecond = [[NSMutableAttributedString alloc] initWithString:Text];
    
    [loginSecond addAttribute:NSForegroundColorAttributeName
                        value:ZJColorDCDCDC
                        range:NSMakeRange(0, loginSecond.length)];
    [loginSecond addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:ZJTextSize35PX]
                        range:NSMakeRange(0, loginSecond.length)];
    phonetextField.attributedPlaceholder = loginSecond;
    [self.view addSubview:phonetextField];
    
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0,self.problemlabel.height + self.textView.height + self.Screenshots.height + label.height + phonetextField.height +PX2PT(40 + 40 + 40 + 40 + 40 + 40) , zjScreenWidth, zjScreenHeight - self.problemlabel.height + self.textView.height + self.Screenshots.height + label.height + phonetextField.height +PX2PT(40 + 40 + 40 + 40 + 40 + 40) )];
    upView.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:upView];
    
    UIButton *Submit = [[UIButton alloc]initWithFrame:CGRectMake(PX2PT(60), PX2PT(200), PX2PT(1122), PX2PT(128))];
    [Submit setTitle:@"提交" forState:UIControlStateNormal];
    Submit.backgroundColor = ZJColor00D3A3;
    Submit.layer.cornerRadius = PX2PT(10);
    Submit.layer.masksToBounds = YES;
    [Submit setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
    [upView addSubview:Submit];
    
    [Submit addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

//登录过
- (void)Login{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentLeft;
    [label zj_labelText:@"联系方式 : xxxxx" textColor:ZJColorDCDCDC textSize:ZJTextSize45PX];
    label.x = PX2PT(40);
    label.y = self.problemlabel.height + self.textView.height + self.Screenshots.height + PX2PT(40 + 40 + 40 + 40);
    [label zj_adjustWithMin];
    [self.view addSubview:label];
    
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0,self.problemlabel.height + self.textView.height + self.Screenshots.height + label.height + PX2PT(40 + 40 + 40 + 40 + 40) , zjScreenWidth,  zjScreenHeight -  self.problemlabel.height + self.textView.height + self.Screenshots.height + label.height + PX2PT(40 + 40 + 40 + 40 + 40))];
    upView.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:upView];
    
    UIButton *Submit = [[UIButton alloc]initWithFrame:CGRectMake(PX2PT(60), PX2PT(360), PX2PT(1122), PX2PT(128))];
    [Submit setTitle:@"提交" forState:UIControlStateNormal];
    Submit.backgroundColor = ZJColor00D3A3;
    Submit.layer.cornerRadius = PX2PT(10);
    Submit.layer.masksToBounds = YES;
    [Submit setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
    [upView addSubview:Submit];
    
    [Submit addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];

}




- (void)Click:(UIButton *)sender{
    
    
    
    
    
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
