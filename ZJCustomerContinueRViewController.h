//
//  ZJCustomerContinueRViewController.h
//  CRM
//
//  Created by mini on 16/10/12.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZJContinueViewState){
    
    ZJContinueViewStateSetting,
    
    ZJContinueViewStateEditing,
};

@class ZJCustomerContinueRViewController;

@protocol ZJCustomerContinueDelegate <NSObject>

-(void)ZJCustomerContinue:(ZJCustomerContinueRViewController *)view switctButton:(NSInteger)isSelect date:(NSString *)date;

@end

@interface ZJCustomerContinueRViewController : UIViewController
//**代理**//
@property(nonatomic,weak) id<ZJCustomerContinueDelegate> delegate;

//**可以续贷日期**//
@property(nonatomic,copy)NSString *CTimeString;

//**贷款日期**//
@property(nonatomic,copy)NSString *loanTimeString;


//**是否开启提醒**//
@property(nonatomic,assign)NSInteger openRemind;

@end
