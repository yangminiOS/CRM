//
//  ZJFolloweViewController.h
//  CRM
//
//  Created by mini on 16/11/2.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJBaseViewController.h"

@class ZJcustomerTableInfo,ZJFolloweViewController;

typedef NS_ENUM(NSInteger,EnterModel){
    
    FirstEnterModel,//首页进入
    
    AddEnterModel,//客户资料录入
    
    DirectEnterModel,//客户界面直接进入
    
};

@protocol ZJFolloweViewDelegate <NSObject>

-(void)ZJFolloweViewController:(ZJFolloweViewController *)view;//返回刷刷新数据

@end

@class ZJFollowUpTableInfo;



//block传值

//typedef void(^followUpModel)(ZJFollowUpTableInfo *followModel);

@interface ZJFolloweViewController : ZJBaseViewController

//**代理**//
@property(nonatomic,weak) id <ZJFolloweViewDelegate>delegate;

//**block**//
//@property(nonatomic,copy) followUpModel model;

//****//
@property(nonatomic,assign)EnterModel FollowEnterModel;

//**模型**//
@property(nonatomic,strong) ZJcustomerTableInfo *customerModel;
@end
