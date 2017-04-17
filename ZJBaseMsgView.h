//
//  ZJBaseMsgView.h
//  CRM
//
//  Created by 杨敏 on 16/10/2.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJBaseMsgView,ZJcustomerTableInfo;

@protocol ZJBaseMsgViewDelegate <NSObject>

//-(void)ZJBaseMsgView:(ZJBaseMsgView *)view viewAddHight:(CGFloat)height;
-(void)ZJBaseMsgView:(ZJBaseMsgView *)view;
-(void)ZJBaseMsgView:(ZJBaseMsgView *)view didClickButtonTag:(NSInteger)tag;
-(void)ZJBaseMsgView:(ZJBaseMsgView *)view activeTextField:(UITextField *)textField;

@end

@interface ZJBaseMsgView : UIView
//**代理方法**//
@property(nonatomic,weak) id<ZJBaseMsgViewDelegate> delegate;
//姓名
@property(nonatomic,strong) UITextField *nameTF;
//**生日**//
@property(nonatomic,strong)UITextField *birthDayTF;
//**身份证号**//
@property(nonatomic,strong)UITextField *codeIDTF;
//**手机**//
@property(nonatomic,strong)UITextField *phoneTF;
//**贷款金额**//
@property(nonatomic,strong)UITextField *loanConutTF;
//**每月利息**//
@property(nonatomic,strong)UITextField *interestTF;
//**贷款日期**//
@property(nonatomic,strong)UITextField *loanDateTF;
//**贷款期限**//
@property(nonatomic,strong)UITextField *loanLimintTimeTF;

//**当前激活的textfield**//
@property(nonatomic,strong)UITextField *actionTF;

//*********************************************************
//**编辑模式下的模型**//
@property(nonatomic,strong)ZJcustomerTableInfo *model;

@end
