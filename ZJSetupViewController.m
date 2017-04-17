//
//  ZJSetupViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/22.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJSetupViewController.h"
#import "ZJChangePasswordViewController.h"
#import "ZJFeedbackViewController.h"
#import "ZJCustomerserviceQQViewController.h"

@interface ZJSetupViewController ()

@end

@implementation ZJSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于好客";
    self.view.backgroundColor = ZJBackGroundColor;
    [self loadSyte];
    
}


- (void)loadSyte{
    
    UIView *UpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, PX2PT(520))];
#pragma 图片变量
    //图片
    float imageX = zjScreenWidth / 3;
    float imageY = PX2PT(250);
    float imageWidth = PX2PT(596) / 1.5;
    float imageHeight = PX2PT(304) / 1.5;
    
#pragma 绘制logo
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake( imageX, imageY, imageWidth, imageHeight)];
    imageView.image = [UIImage imageNamed:@"haoke-lg"];
    
    [self.view addSubview:imageView];
    
#pragma 版本变量
    
    float copyheight = imageView.height  + PX2PT(300);
    float copyNote = copyheight + PX2PT(128)/3.5 - PX2PT(40);
#pragma 版本说明
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appCopyRight = [NSString stringWithFormat:@"好客 %@", app_Version];
    UILabel *copyNoteLabel = [[UILabel alloc]init];
    copyNoteLabel.textAlignment = NSTextAlignmentLeft;
    [copyNoteLabel zj_labelText:appCopyRight
                      textColor:ZJColor505050
                       textSize:ZJTextSize45PX];
    copyNoteLabel.centerX = (zjScreenWidth / 2) -  (appCopyRight.length *4)  ;
    copyNoteLabel.centerY = copyNote;
    [copyNoteLabel zj_adjustWithMin];
    
    [self.view addSubview: copyNoteLabel];
    
#pragma 意见反馈变量
    float viewX = 0;
    float viewY = copyNote + PX2PT(40)+ PX2PT(40)+ PX2PT(40);
    
#pragma 意见反馈
    //第一行
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, zjScreenWidth, PX2PT(128))];
    view.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:view];
    //虚线
    UIView *LineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)];
    LineView.backgroundColor = ZJColorDCDCDC;
    [view addSubview:LineView];
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0,  PX2PT(128) - 1, zjScreenWidth, 1)];
    middleView.backgroundColor = ZJColorDCDCDC;
    [view addSubview:middleView];
    
    UILabel *ModifyLabel = [[UILabel alloc]init];
    ModifyLabel.textAlignment = NSTextAlignmentLeft;
    [ModifyLabel zj_labelText:@"意见反馈" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    ModifyLabel.x = PX2PT(40);
    ModifyLabel.centerY = PX2PT(128)/3.5;
    [ModifyLabel zj_adjustWithMin];
    [view addSubview:ModifyLabel];
    //创建箭头图片
    [view addSubview:[self ImagView]];
    
    UIButton *ModifyButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, view.height)];
    ModifyButton.tag = 1;
    [ModifyButton addTarget:self action:@selector(AllClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:ModifyButton];
    

#pragma 求好评变量
    float fthreedX = 0;
    float fthreedY = viewY + PX2PT(40)  + PX2PT(40) + PX2PT(128)/3.5 + PX2PT(128)/3.5;
#pragma 求好评
    //第三行
    UIView *threeView = [[UIView alloc] initWithFrame:CGRectMake(fthreedX, fthreedY  , zjScreenWidth, PX2PT(128))];
    threeView.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:threeView];
    
    UILabel *levelLabel = [[UILabel alloc] init];
    levelLabel.textAlignment = NSTextAlignmentLeft;
    [levelLabel zj_labelText:@"求好评" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    levelLabel.x = PX2PT(40);
    levelLabel.centerY = PX2PT(128)/3.5;
    [levelLabel zj_adjustWithMin];
    [threeView addSubview:levelLabel];
    //创建虚线
    UIView *threeLineViewUP = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)];
    threeLineViewUP.backgroundColor = ZJColorDCDCDC;
    UIView *threeLineViewDown = [[UIView alloc]initWithFrame:CGRectMake(0, PX2PT(128) - 1, zjScreenWidth, 1)];
    threeLineViewDown.backgroundColor = ZJColorDCDCDC;
    
    [threeView addSubview:threeLineViewDown];
    [threeView addSubview:threeLineViewUP];
    
    //创建箭头图片
    [threeView addSubview:[self ImagView]];
    UIButton *levelButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, zjScreenWidth, view.height)];
    levelButton.tag = 3;
    [levelButton addTarget:self action:@selector(AllClick:) forControlEvents:UIControlEventTouchUpInside];
    [threeView addSubview:levelButton];
    
#pragma 使用条款和隐私政策变量..

    UILabel *sNoteLabel = [[UILabel alloc]init];
    sNoteLabel.numberOfLines = 0;
    sNoteLabel.textAlignment = NSTextAlignmentCenter;
    sNoteLabel.textColor = ZJColor505050;
    NSString *sNote = @" 至简天成公司 版权所有 \n Copyright @ 2011-2016 ZJTC \n  All Rights Reserved.";
    sNoteLabel.text = sNote;
    sNoteLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    CGFloat labelX = self.view.width / 4;
    NSDictionary *labeldict = @{NSFontAttributeName : [UIFont systemFontOfSize:ZJTextSize45PX]};
    CGSize labelSize = [sNote sizeWithAttributes:labeldict];
    CGFloat labelW = labelSize.width;
    CGFloat labelH = [sNote boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:labeldict context:nil].size.height;
    CGFloat labelY = self.view.height - labelSize.height - 100;
    sNoteLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    [self.view addSubview: sNoteLabel];
    

}
//箭头图片
- (UIView *)ImagView{
    UIView *view = [[UIView alloc]init];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(zjScreenWidth - PX2PT(40) - 8 ,PX2PT(128)/3, 8, 16)];
    imageView.image = [UIImage imageNamed:@"I_arrows_right"];
    [view addSubview:imageView];
    return view;
}

- (void)AllClick:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
        {
            NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"2558710290"];
            NSURL *url = [NSURL URLWithString:qqstr];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {

            NSString * ID = @"1186630128";
            NSString *str = [NSString stringWithFormat:  @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?mt=8&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&id=%@", ID];
 
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }
            break;
        default:
            
            break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
