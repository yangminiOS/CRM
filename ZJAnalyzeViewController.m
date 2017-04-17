//
//  ZJStudyViewController.m
//  CRM
//
//  Created by mini on 16/8/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJAnalyzeViewController.h"
#import "ZJCustomButton.h"
//人数统计
#import "ZJPesonCountsViewController.h"
//增速分析
#import "ZJSpeedUpViewController.h"
//状态分析
#import "ZJStatusViewController.h"
//来源统计
#import "ZJSourceViewController.h"
//渠道分析
#import "ZJChannelViewController.h"
//放贷类型
#import "ZJLendingViewController.h"

@interface ZJAnalyzeViewController ()

@property(nonatomic,weak)UIView *contentView;

@end

@implementation ZJAnalyzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZJBackGroundColor;
    self.navigationItem.title=@"分析";
    
    [self setupUI];
}

-(void)setupUI{
    
    NSArray *titleArray = @[@"人数统计",@"增速分析",@"状态分析",@"来源分析",@"渠道分析",@"放贷类型"];
    NSArray *imageName = @[@"D-A_people-counting",@"D-A_Growth-analysis",@"D-A_state-analysis",@"D-A_stream-analysis",@"D-A_channel-list",@"D-A_Lending-type"];
    
    CGFloat width = self.view.width;
    
    CGFloat height = PX2PT(830);
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    contentView.backgroundColor = ZJColorFFFFFF;
    
    [self.view addSubview:contentView];
    
    self.contentView = contentView;
    
    [self setSeparatorViewWithFrame:CGRectMake(width/3, 0, 1, height)];
    
    [self setSeparatorViewWithFrame:CGRectMake(2*width/3+1, 0, 1, height)];
    
    [self setSeparatorViewWithFrame:CGRectMake(0, height/2, width, 1)];
    
    [self setSeparatorViewWithFrame:CGRectMake(0, height-1, width, 1)];
    
    for (NSInteger i = 0; i<titleArray.count; i++) {
        
        ZJCustomButton *button = [[ZJCustomButton alloc]initWithMargin:PX2PT(20)];
        
        [button setImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateNormal];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
        [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
        button.width = 66;
        button.height = 66 +PX2PT(20)+13;
        button.centerX = self.contentView.width*(i%3*2+1)/6.0;
        
        button.centerY = self.contentView.height*(2*(i/3)+1)/4.0;
        
        button.tag = i;
        
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
    }
    
}

-(void)setSeparatorViewWithFrame:(CGRect)frame{
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = ZJColorDCDCDC;
    
    [self.contentView addSubview:view];
    
    view.frame = frame;

}

#pragma mark---------点击Button

-(void)clickButton:(UIButton *)button{
    
    switch (button.tag) {
        case 0:
        {
            ZJPesonCountsViewController *pesoncouts = [ZJPesonCountsViewController new];
            [self.navigationController pushViewController:pesoncouts animated:YES];
        }
            break;
        case 1:
        {
            ZJSpeedUpViewController *pesoncouts = [ZJSpeedUpViewController new];
            [self.navigationController pushViewController:pesoncouts animated:YES];
            break;
        }
        case 2:
        {
            ZJStatusViewController *staus = [ZJStatusViewController new];
            [self.navigationController pushViewController:staus animated:YES];
            break;
        }
        case 3:
        {
            ZJSourceViewController *soure = [ZJSourceViewController new];
            [self.navigationController pushViewController:soure animated:YES];
            break;
        }
        case 4:
        {
            ZJChannelViewController *chanel = [ZJChannelViewController new];
            [self.navigationController pushViewController:chanel animated:YES];
            break;
        }
        default:
        {
            ZJLendingViewController *lending = [ZJLendingViewController new];
            [self.navigationController pushViewController:lending animated:YES];
        }
            break;
    }
    
}


@end
