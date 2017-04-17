//
//  ZJLoanCustonerController.m
//  CRM
//
//  Created by mini on 16/9/19.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJLoanCustonerController.h"
#import <Masonry.h>
#import "ZJCustomerInfoScanController.h"
#import "ZJCustomButton.h"
#import "ZJPurposeViewController.h"

@interface ZJLoanCustonerController ()

@property(nonatomic,weak) UIImageView *imgView;
//**完成客户录入**//
@property(nonatomic,weak) UIButton *fullButton;

//**意向客户录入**//
@property(nonatomic,weak) UIButton *purposeButton;

//**扫描身份证客户录入**//
@property(nonatomic,weak) UIButton *scanButton;

//**底部按钮**//
@property(nonatomic,weak) UIButton *cancelButton;

@end

@implementation ZJLoanCustonerController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏信息
    [self setupNavigation];
    
    //设置UI
    [self setupUI];
    
}

#pragma mark   导航栏信息
-(void)setupNavigation{
    
    self.navigationItem.title = @"贷款客户管理";
}
#pragma mark   设置UI
-(void)setupUI{
    
    CGRect frame = CGRectMake(0, -ZJTNHeight, zjScreenWidth, zjScreenHeight);
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:frame];
    
    [self.view addSubview:imgView];
    
    imgView.image = [UIImage imageNamed:@"indistinct"];
    
    imgView.userInteractionEnabled = YES;
    
    self.imgView = imgView;
    
    //完整客户录入
    ZJCustomButton *fullButton = [[ZJCustomButton alloc]init];
    
    [imgView addSubview:fullButton];
    
    CGFloat margin = PX2PT(30);
    
    CGFloat fullButtonW = [self button:fullButton setTitle:@"完整客户录入"  titleFont:PX2PT(45) titleColor:ZJColor505050 imgageName:@"Customer-Data-entry"];
    
    CGFloat buttonHeight = fullButton.currentImage.size.height + margin + 30;
    
    fullButton.frame = CGRectMake(PX2PT(106), PX2PT(686) +ZJTNHeight, fullButtonW, buttonHeight);
    [fullButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.fullButton = fullButton;
    
    //意向客户录入
    ZJCustomButton *purposeButton = [[ZJCustomButton alloc]init];
    
    [imgView addSubview:purposeButton];
    
    [self button:purposeButton setTitle:@"意向客户录入" titleFont:PX2PT(45) titleColor:ZJColor505050 imgageName:@"Interested-buyers"];

    CGFloat purposeButtonX = imgView.width - fullButtonW -PX2PT(106);
    
    purposeButton.frame = CGRectMake(purposeButtonX, PX2PT(686) +ZJTNHeight, fullButtonW, buttonHeight);
    [purposeButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.purposeButton= purposeButton;
    
    //扫描省份证录入

    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"ocr"]intValue] == 1) {
        
        ZJCustomButton *scanButton = [[ZJCustomButton alloc]init];
        
        [imgView addSubview:scanButton];
        
        CGFloat scanW = [self button:scanButton
            setTitle:@"扫描身份证录入"
           titleFont:PX2PT(45)
          titleColor:ZJColor505050
          imgageName:@"Scanning"];

        CGFloat scanX = (imgView.width - scanW)/2;
        
        CGFloat scanY = CGRectGetMaxY(fullButton.frame);
        scanButton.frame = CGRectMake(scanX, scanY, scanW, buttonHeight);
        [scanButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.scanButton = scanButton;
        
    }
    
    //底部Button
    UIButton *cancelButton= [[UIButton alloc]initWithFrame:CGRectMake(0, imgView.height - PX2PT(146), imgView.width, PX2PT(146))];
    [imgView addSubview:cancelButton];
    
    cancelButton.backgroundColor = [UIColor whiteColor];
    
    [cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    
    [cancelButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton = cancelButton;
    
}

//点击button
-(void)clickButton:(UIButton *)button{
    
    if (button == self.fullButton) {//完整客户录入
        ZJCustomerInfoScanController *customerInfoScan = [[ZJCustomerInfoScanController alloc]init];
        customerInfoScan.entingModel =ZJCustomerEntingFull;

        [self.navigationController pushViewController:customerInfoScan animated:YES];
        
    }else if (button == self.purposeButton){//意向客户录入
        ZJPurposeViewController *prupose = [[ZJPurposeViewController alloc]init];
        
        [self.navigationController pushViewController:prupose animated:YES];
        
    }else if (button == self.scanButton){//扫描录入
        
        ZJCustomerInfoScanController *customerInfoScan = [[ZJCustomerInfoScanController alloc]init];
        
        customerInfoScan.entingModel =ZJCustomerEntingScan;

        [self.navigationController pushViewController:customerInfoScan animated:YES];
        
    }else if (button == self.cancelButton){
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


#pragma mark   设置button相关属性
-(CGFloat)button:(UIButton *)button setTitle:(NSString *)title titleFont:(CGFloat)titleSize titleColor:(UIColor *)color imgageName:(NSString *)imgName{
    
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:titleSize];
    
    CGFloat imgWidth = button.currentImage.size.width ;
    
    CGFloat titleWidth =[button.titleLabel.text zj_getStringRealWidthWithHeight:30 fountSize:titleSize];
    
    CGFloat buttonWith = imgWidth > titleWidth?imgWidth:titleWidth;
    
    return buttonWith;
}

@end
