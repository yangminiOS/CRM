//
//  ZJRemindView.h
//  CRM
//
//  Created by mini on 16/9/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJRemindView;
typedef NS_ENUM(NSInteger,ZJRemindViewType){
    
    RemindFollowType,
    RemindBirthDayType,
    RemindContinueLoanType,
    RemindFirstType,
    
};


@interface ZJRemindView : UIView

-(instancetype)initWithViewType:(ZJRemindViewType)viewType ONImgName:(NSString *)ONName OFFImgName:(NSString *)OFFName title:(NSString *)title;

//**视图类型**//
@property(nonatomic,assign) ZJRemindViewType viewType;


//**点击Button**//
@property(nonatomic,strong)UIButton *clickButton;


//**详细信息**//
@property(nonatomic,copy)NSString *detailText;

//**选择开关**//
//@property(nonatomic,strong) UISwitch *swich;


@end
