//
//  ZJFollowCustomerController.h
//  CRM
//
//  Created by mini on 16/11/24.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJFollowCustomerController,ZJcustomerTableInfo;

@protocol ZJFollowCustomerDelegate <NSObject>

-(void)ZJFollowCustomerController:(ZJFollowCustomerController *)view customerModel:(ZJcustomerTableInfo *)customerModel;

@end

@interface ZJFollowCustomerController : UIViewController

//**代理**//
@property(nonatomic,weak) id <ZJFollowCustomerDelegate>delegate;

@end
