//
//  ZJContactViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/21.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJContactViewController.h"
#import "ZJReplaceViewController.h"
@interface ZJContactViewController ()

@end

@implementation ZJContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系方式";
    self.view.backgroundColor = ZJBackGroundColor;
    [self loadSyte];
    NSLog(@"self.phone%@",self.phone);
}

- (void)loadSyte{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, PX2PT(40), zjScreenWidth, PX2PT(200 + 100 + 128 + 200))];
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
    [personLable zj_labelText:@"联系方式" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    personLable.x = PX2PT(40);
    personLable.centerY = PX2PT(200)/3;
    personLable.font = [UIFont boldSystemFontOfSize:15];
    [personLable zj_adjustWithMin];
    [view addSubview:personLable];
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.textAlignment = NSTextAlignmentRight;
    [phoneLabel zj_labelText:[NSString stringWithFormat:@"手机 %@",self.phone] textColor:ZJColorDCDCDC textSize:ZJTextSize45PX];
    phoneLabel.x = zjScreenWidth - 200;
    phoneLabel.width = view.height - PX2PT(40);
    phoneLabel.centerY = PX2PT(200)/3;
    [phoneLabel zj_adjustWithMin];
    [view addSubview:phoneLabel];
    
    UIButton *phoneButton = [[UIButton alloc]initWithFrame:CGRectMake(PX2PT(62), PX2PT(200 + 100), PX2PT(1122), PX2PT(128))];
    phoneButton.backgroundColor = ZJColor00D3A3;
    phoneButton.layer.masksToBounds = YES;
    phoneButton.layer.cornerRadius = PX2PT(20);
    [phoneButton setTitle:@"更换手机号" forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(PhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneButton];
    
    //下方的文字内容
    UILabel *sNoteLabel = [[UILabel alloc]init];
    sNoteLabel.numberOfLines = 0;
    sNoteLabel.textAlignment = NSTextAlignmentLeft;
    sNoteLabel.textColor = ZJColor505050;
    NSString *sNote = @"注意 ：更换手机号后，您的登录账号也会随之改变。\n如 ：当前手机号为13888888888\n若 ：更改手机号为13999999999\n则 ：以后登陆时请使用13999999999进行操作";
    sNoteLabel.text = sNote;
    sNoteLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    CGFloat labelX = PX2PT(62);
    NSDictionary *labeldict = @{NSFontAttributeName : [UIFont systemFontOfSize:ZJTextSize45PX]};
    CGSize labelSize = [sNote sizeWithAttributes:labeldict];
    CGFloat labelW = labelSize.width;
    CGFloat labelH = [sNote boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:labeldict context:nil].size.height;
    CGFloat labelY = view.height + PX2PT(60);
    sNoteLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    [view addSubview:sNoteLabel];
    

    
    
}

//跳转更换手机号页面
- (void)PhoneClick:(UIButton *)sender{
    

    ZJReplaceViewController *replace = [ZJReplaceViewController new];
    replace.Phone = self.phone;
    [self.navigationController pushViewController:replace animated:YES];
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
