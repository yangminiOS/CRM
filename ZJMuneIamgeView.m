//
//  ZJMuneIamgeView.m
//  CRM
//
//  Created by mini on 16/11/28.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJMuneIamgeView.h"

@interface ZJMuneIamgeView ()<UIGestureRecognizerDelegate>

@property(nonatomic,weak) UIImageView *backImageView;

//**编辑**//
@property(nonatomic,weak) UIButton *editButton;

//**删除**//
@property(nonatomic,weak) UIButton *deleButton;

@end

@implementation ZJMuneIamgeView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        self.frame = frame;
        
        [self setupUI];
        
    }
    
    return self;
}

-(void)setupUI{
    CGFloat imgX = (self.width+ PX2PT(customerIcon))/2.0 +ZJmargin40;
    CGFloat imgW = self.width - imgX - ZJmargin40;
    UIImageView *mune = [[UIImageView alloc]init];
    mune.userInteractionEnabled= YES;
    mune.image = [UIImage imageNamed:@"edit-delete-1"];
    [self addSubview:mune];
    self.backImageView =mune;
    mune.frame = CGRectMake(imgX, 54, imgW, 100);
    
    //编辑
    UIButton *editButton = [[UIButton alloc]init];
    editButton.tag = 1;
    self.editButton = editButton;
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    editButton.frame = CGRectMake(6, 14, imgW-12, 40);
    [mune addSubview:editButton];
    [editButton addTarget:self action:@selector(clickMuneEditButton:) forControlEvents:UIControlEventTouchUpInside];
    //分割线
    UIView *view = [[UIView alloc]init];
    [mune addSubview:view];
    view.frame =  CGRectMake(6, 54, imgW-12, 1);
    view.backgroundColor = ZJColorDCDCDC;
    //删除
    UIButton *delecteButton = [[UIButton alloc]init];
    delecteButton.tag = 2;
    self.deleButton = delecteButton;
    [delecteButton setTitle:@"删除" forState:UIControlStateNormal];
    //        editButton.backgroundColor = [UIColor redColor];
    [delecteButton setTitleColor:ZJRGBColor(254, 0, 0, 1.0) forState:UIControlStateNormal];
    delecteButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    delecteButton.frame = CGRectMake(6, 55, imgW-12, 40);
    [mune addSubview:delecteButton];
    [delecteButton addTarget:self action:@selector(clickMuneDelecteButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark   点击编辑button
-(void)clickMuneEditButton:(UIButton *)button{
    
    [self.delegate ZJMuneIamgeView:self didDlickButton:self.editButton];
}

#pragma mark   点击删除button
-(void)clickMuneDelecteButton:(UIButton *)button{
    
    [self.delegate ZJMuneIamgeView:self didDlickButton:self.deleButton];
}

#pragma mark   点击View
-(void)tapView{
    [self.delegate ZJMuneIamgeView:self didDlickButton:nil];
}

#pragma mark   判断是点击空白View 还是Button
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) {
        
        return NO;
        
    }else{
        
        return YES;
        
    }
}
@end
