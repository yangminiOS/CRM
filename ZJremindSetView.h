//
//  ZJremindSetView.h
//  CRM
//
//  Created by mini on 16/9/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZJremindSetViewType){
    
    ZJremindSetViewScan,
    ZJremindSetViewExamine,
    
};
@class ZJRemindView,ZJremindSetView;

@protocol ZJremindSetViewDelegate <NSObject>

-(void)ZJremindSetViewView:(ZJremindSetView *)view didClickButton:(NSInteger)tap;

@end
@interface ZJremindSetView : UIView

//初始化方法

-(instancetype)initWithType:(ZJremindSetViewType)viewType;

//**代理**//
@property(nonatomic,weak) id<ZJremindSetViewDelegate> delegate;

//**view样式**//
@property(nonatomic,assign)ZJremindSetViewType type;

//**生日提醒**//
@property(nonatomic,strong) ZJRemindView *birthDayView;

//**续贷提醒**//
@property(nonatomic,strong)ZJRemindView * contunueLoanView;

//**首期还款日提醒**//
@property(nonatomic,strong)ZJRemindView *firstView;

//**详细信息**//
@property(nonatomic,copy)NSString *birthText;
//**续贷提醒**//
@property(nonatomic,copy)NSString *continueText;
//**首期还款提醒**//
@property(nonatomic,copy)NSString *firstText;

//**生日选择开关**//
//@property(nonatomic,strong) UISwitch *birthSwitch;

//**续贷选择开关**//
//@property(nonatomic,strong) UISwitch *continueSwitch;

//**首期还款选择开关**//
//@property(nonatomic,strong) UISwitch *firstSwitch;

//**生日覆盖**//
@property(nonatomic,strong) UIButton *birthCoverButton;

//**续贷覆盖**//
@property(nonatomic,strong) UIButton *continueCoverButton;
//**首期覆盖**//
@property(nonatomic,strong) UIButton *firstCoverButton;

@end
