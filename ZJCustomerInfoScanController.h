//
//  ZJCustomerInfoScanController.h
//  CRM
//
//  Created by mini on 16/9/20.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJBaseViewController.h"

@class ZJFollowUpTableInfo,ZJcustomerTableInfo,ZJCustomerInfoScanController;

@protocol CustomerInfoScanControllerDelegate <NSObject>

-(void)ZJCustomerInfoScanController:(ZJCustomerInfoScanController *)view customerInfo:(ZJcustomerTableInfo *)cusromerInfo;


@end

//block传值

typedef void(^customerTableInfo)(ZJcustomerTableInfo *customerInfoModel);


typedef NS_ENUM(NSInteger,ZJCustomerEnting){
    
    ZJCustomerEntingFull,
    
    ZJCustomerEntingScan,
        
    ZJCustomerEntingEdit
};

@interface ZJCustomerInfoScanController : ZJBaseViewController

//**录入模式**//
@property(nonatomic,assign)ZJCustomerEnting entingModel;
//*编辑模式下的模型**//
@property(nonatomic,strong)ZJcustomerTableInfo *customerModel;

//跟进模型
@property(nonatomic,strong) ZJFollowUpTableInfo *followModel;

//**block**//
@property(nonatomic,copy)customerTableInfo customerInfo;

//**代理**//
@property(nonatomic,weak) id <CustomerInfoScanControllerDelegate>delegate;

@end
