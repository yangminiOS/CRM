//
//  ZJremindSetView.m
//  CRM
//
//  Created by mini on 16/9/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJremindSetView.h"
#import "ZJRemindView.h"
#import <Masonry.h>
@interface ZJremindSetView()

{
    CGFloat birthDayH;
    
}
@end

@implementation ZJremindSetView

-(instancetype)initWithType:(ZJremindSetViewType)viewType;
{
    
    if (self = [super init]) {
        self.type = viewType;

        _birthDayView = [[ZJRemindView alloc]initWithViewType:RemindBirthDayType ONImgName:@"birthday" OFFImgName:@"UN-birthday" title:@"生日提醒"];
        [self addSubview:_birthDayView];
        _birthDayView.clickButton.tag = 2;
        [_birthDayView.clickButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _birthCoverButton = [self addCoverViewWithImg:[UIImage imageNamed:@"UN-birthday"]];
        _birthCoverButton.titleLabel.numberOfLines = 2;
        [_birthCoverButton setTitle:@"生日提醒\n未设置相关日期，无法操作此项" forState:UIControlStateNormal];
        _birthDayView.clickButton.enabled = NO;
        [self.birthDayView addSubview:_birthCoverButton];
        
//        self.birthSwitch = _birthDayView.swich;

        
        
        _contunueLoanView = [[ZJRemindView alloc]initWithViewType:RemindContinueLoanType ONImgName:@"-Renew-loans" OFFImgName:@"UN-Renew-loans" title:@"续贷提醒"];
        [self addSubview:_contunueLoanView];
        _contunueLoanView.clickButton.tag = 3;
        [_contunueLoanView.clickButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _continueCoverButton = [self addCoverViewWithImg:[UIImage imageNamed:@"-UN-Renew-loans"]];
        _continueCoverButton.titleLabel.numberOfLines = 2;
        [_continueCoverButton setTitle:@"续贷提醒\n未设置相关日期，无法操作此项" forState:UIControlStateNormal];

        _contunueLoanView.clickButton.enabled = NO;
        [self.contunueLoanView addSubview:_continueCoverButton];
//        self.continueSwitch = _contunueLoanView.swich;

        
        
        _firstView = [[ZJRemindView alloc]initWithViewType:RemindFirstType ONImgName:@"Repayment-date" OFFImgName:@"UN-Repayment-date" title:@"首期还款日提醒"];
        [self addSubview:_firstView];
        _firstView.clickButton.tag = 4;
        [_firstView.clickButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _firstCoverButton = [self addCoverViewWithImg:[UIImage imageNamed:@"UN-Repayment-date"]];
        _firstCoverButton.titleLabel.numberOfLines = 2;
        [_firstCoverButton setTitle:@"首期还款日提醒\n未设置相关日期，无法操作此项" forState:UIControlStateNormal];

        _firstView.clickButton.enabled = NO;
        [self.firstView addSubview:_firstCoverButton];
//        self.firstSwitch = _firstView.swich;

        
    }
    
    return self;
}

//生日
-(void)setBirthText:(NSString *)birthText{
    
    _birthText = birthText;
    _birthDayView.detailText= birthText;
    if (birthText.length>0&&_birthCoverButton) {
        [_birthCoverButton removeFromSuperview];
        _birthCoverButton = nil;
        _birthDayView.clickButton.enabled = YES;
    }
}
-(void)setContinueText:(NSString *)continueText{
    _continueText = continueText;
    _contunueLoanView.detailText = continueText;
    if (continueText.length>0&&_continueCoverButton) {
        [_continueCoverButton removeFromSuperview];
        _continueCoverButton = nil;
        _contunueLoanView.clickButton.enabled = YES;
        
    }
}

-(void)setFirstText:(NSString *)firstText{
    _firstText = firstText;
    _firstView.detailText = firstText;
    if (firstText.length>0 &&_firstCoverButton) {
        [_firstCoverButton removeFromSuperview];
        _firstCoverButton = nil;
        _firstView.clickButton.enabled = YES;
        
    }
    
}


#pragma mark   覆盖Button
-(void)clickButton:(UIButton *)button{
    
    [self.delegate ZJremindSetViewView:self didClickButton:button.tag];
}

#pragma mark   覆盖View
-(UIButton *)addCoverViewWithImg:(UIImage *)img{
    UIButton *coverButton = [[UIButton alloc]init];
    coverButton.backgroundColor = ZJRGBColor(220, 220, 220, 1.0);
//    [coverButton setTitle:@"未设置相关日期，无法操作此项" forState:UIControlStateNormal];
    [coverButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    [coverButton setImage:img forState:UIControlStateNormal];
    coverButton.enabled = NO;
    coverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    coverButton.contentEdgeInsets =UIEdgeInsetsMake(0, ZJmargin40, 0, 0);
    coverButton.titleEdgeInsets = UIEdgeInsetsMake(0, PX2PT(60), 0, 0);
    
    coverButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    return coverButton;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_birthDayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(birthDayH);
        make.height.mas_equalTo(PX2PT(200));
        
    }];
    
    [_birthCoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.mas_equalTo(_birthDayView);
    }];
    
    [_contunueLoanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_birthDayView.mas_bottom).offset(1);
        make.height.mas_equalTo(PX2PT(200));
        
    }];
    
    [_continueCoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.mas_equalTo(_contunueLoanView);
    }];
    
    [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_contunueLoanView.mas_bottom).offset(1);
        make.height.mas_equalTo(PX2PT(200));
        
    }];
    
    [_firstCoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.mas_equalTo(_firstView);
    }];
}

@end
