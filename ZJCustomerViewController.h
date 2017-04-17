//
//  ZJCustomerViewController.h
//  CRM
//
//  Created by mini on 16/9/14.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NSEnterModel){
        
    
    FirstPurposeModel,
    
    FirstNewAddModel,
    
    FirstFollowingModel,
    
    FirstLoanModel,
    
    FirstSearchModel,
    
    CustomerModel,
};

@interface ZJCustomerViewController : UIViewController

//**]**//
@property(nonatomic,assign) NSEnterModel  enterModel;

//**数据库语句**//
@property(nonatomic,copy)NSString *select;

//导航的标题

@property(nonatomic,copy) NSString *naviTitle;



@end
