//
//  ZJAddRemindView.h
//  CRM
//
//  Created by 杨敏 on 16/10/6.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJAddRemindView;

@protocol ZJAddRemindViewDelegate <NSObject>

-(void)ZJAddRemindView:(ZJAddRemindView *)view text:(NSString *)text clickButton:(UIButton *)button;

@end

@interface ZJAddRemindView : UIView

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title;

//**代理**//
@property(nonatomic,weak)id<ZJAddRemindViewDelegate>  delegate;

//**textView信息**//
@property(nonatomic,copy)NSString *msg;


//**<#注释#>**//
@property(nonatomic,weak)UITextView * textView;

@end
