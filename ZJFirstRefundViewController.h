//
//  ZJFirstRefundViewController.h
//  CRM
//
//  Created by 杨敏 on 16/10/12.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZJFirstViewState){
    
    ZJFirstViewStateSetting,
    ZJFirstViewStateEditing
};

@class ZJFirstRefundViewController;

@protocol ZJFirstRefundViewDelegate <NSObject>

-(void)ZJFirstView:(ZJFirstRefundViewController *)view switctButton:(NSInteger)isSelect date:(NSString *)date;

@end

@interface ZJFirstRefundViewController : UIViewController

//**代理**//
@property(nonatomic,weak) id<ZJFirstRefundViewDelegate> delegate;

//**还款日期**//
@property(nonatomic,copy)NSString *ReTimeString;

//**贷款日期**//
@property(nonatomic,copy)NSString *loanTimeString;

//**是否开启提醒**//
@property(nonatomic,assign)NSInteger openRemind;

//**视图状态**//
@property(nonatomic,assign)ZJFirstViewState viewState;
@end
