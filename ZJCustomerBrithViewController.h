//
//  ZJCustomerBrithViewController.h
//  CRM
//
//  Created by mini on 16/10/12.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZJViewState){
    
    ZJViewStateSetting,
    ZJViewStateEditing
};


@class ZJCustomerBrithViewController;

@protocol ZJCustomerBrithViewDelegate <NSObject>

-(void)ZJCustomerBrith:(ZJCustomerBrithViewController *)view switctButton:(NSInteger)isSelect;

@end

@interface ZJCustomerBrithViewController : UIViewController

//**代理**//
@property(nonatomic,weak) id<ZJCustomerBrithViewDelegate> delegate;

//**头像地址**//
@property(nonatomic,copy)NSString *cPhotoUrl;

//**姓名**//
@property(nonatomic,copy)NSString *cName;

//**性别**//
@property(nonatomic,assign)NSInteger iSex;

//**出生日期**//
@property(nonatomic,copy)NSString *cBirthDay;

//**选中状态**//
@property(nonatomic,assign)NSInteger openRemind;



@end
