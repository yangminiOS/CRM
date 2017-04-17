//
//  ZJCustomerTypeView.h
//  CRM
//
//  Created by mini on 16/9/21.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ZJViewType) {
    
    ZJCustomerStateView,
    ZJCustomerSourceView,
    ZJCustomerLoanTypeView,
    
};

@class ZJCustomerTypeView,ZJcustomerTableInfo;

@protocol ZJCustomerTypeViewDelegate <NSObject>

@required;
//增加高度

-(void)ZJCustomerTypeView:(ZJCustomerTypeView *)View ZJViewType:(ZJViewType)type viewHeight:(CGFloat)Height;

//弹框内容
-(void)ZJCustomerTypeView:(ZJCustomerTypeView *)view warnText:(NSString*)text;

//手机号码
-(void)ZJCustomerTypeView:(ZJCustomerTypeView *)view;

//激活textfield时移动视图
-(void)ZJCustomerTypeView:(ZJCustomerTypeView *)view actionTextField:(UITextField *)textField;
@end

@interface ZJCustomerTypeView : UIView

//**代理**//
@property(nonatomic,weak) id<ZJCustomerTypeViewDelegate>delegate;
//**备注信息**//
@property(nonatomic,strong)UIButton*remarkTextButton;
//**介绍人姓名**//
@property(nonatomic,strong) UITextField *introducerNameTField;

//****//
@property(nonatomic,assign)CGFloat customerItemsHeight;
//初始化方法
-(instancetype)initZJCustomerTypeViewWithTitle:(NSString *)title viewType:(ZJViewType)type;
//返回选中Items文字的方法
-(NSString *)ZJCustomerTypeViewWithSelectedItemsString;

//**编辑是传入的模型**//
@property(nonatomic,strong)ZJcustomerTableInfo *model;

//**被激活 的textfield**//
@property(nonatomic,weak) UITextField *actionField;


@end
