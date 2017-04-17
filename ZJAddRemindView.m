//
//  ZJAddRemindView.m
//  CRM
//
//  Created by 杨敏 on 16/10/6.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJAddRemindView.h"
@interface ZJAddRemindView()<UITextViewDelegate>

//**<#注释#>**//
@property(nonatomic,weak) UIButton *leftButton;

//**<#注释#>**//
@property(nonatomic,weak) UIButton *rightButton;


@end

@implementation ZJAddRemindView

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title{
    
    if (self = [super initWithFrame: frame]) {
        
        self.msg = title;
        [self setupUI];
    }
    
    return self;
}

-(void)setupUI{
    self.backgroundColor = ZJColorFFFFFF;
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, ZJTNHeight)];
    [self addSubview:topView];
    topView.backgroundColor = ZJColor00D3A3;
    
    UIButton *leftButton = [[UIButton alloc]init];
    self.leftButton = leftButton;
    leftButton.tag = 1;
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize55PX];
    [topView addSubview:leftButton];
    leftButton.frame = CGRectMake(ZJmargin40, 31, 50, 20);
    [leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *rightButton = [[UIButton alloc]init];
    self.rightButton = rightButton;
    rightButton.tag = 2;
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize55PX];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [topView addSubview:rightButton];
    rightButton.frame = CGRectMake(self.width - ZJmargin40-50, 31, 50, 20);
    [rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *centerLabel = [[UILabel alloc]init];
    [topView addSubview:centerLabel];
    [centerLabel zj_labelText:@"备注" textColor:ZJColorFFFFFF textSize:ZJTextSize55PX];
    centerLabel.width = 50;
    centerLabel.height = 20;
    centerLabel.x = (self.width - 50)/2;
    centerLabel.y = 31;
    
    UITextView *msgTextView = [[UITextView alloc]init];
    msgTextView.delegate = self;
    [self addSubview:msgTextView];
    self.textView = msgTextView;
    msgTextView.frame = CGRectMake(0, ZJTNHeight, zjScreenWidth, self.height-ZJTNHeight);
//    msgTextView.backgroundColor = ZJRGBColor(0, 0, 0, 0.2);
    if (self.msg.length >0) {
        
        msgTextView.text = self.msg;
    }else{
        
        msgTextView.text = @"";
    }
    msgTextView.textColor = ZJRGBColor(180, 180, 180, 1.0);
    msgTextView.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [msgTextView becomeFirstResponder];
}

-(void)clickLeftButton:(UIButton *)button{
    
    [self.delegate ZJAddRemindView:self text:self.textView.text clickButton:button];
}

-(void)clickRightButton:(UIButton *)button{
    
    [self.delegate ZJAddRemindView:self text:self.textView.text clickButton:button];

    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (self.msg.length <= 0) {
        
        textView.text = @"";
    }
    
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *temp = [textView.text stringByAppendingString:text];
    
    if (temp.length<=300) {
        
        return YES;
    }else{
        
    return NO;

    }
    
}
@end
