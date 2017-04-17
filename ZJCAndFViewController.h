//
//  ZJCAndFViewController.h
//  CRM
//
//  Created by mini on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NSTypeViewController){
    
    NSContinueViewController,
    NSFirstViewController
};

@interface ZJCAndFViewController : UIViewController


//****//
@property(nonatomic,assign) NSTypeViewController ViewType;

//**搜索控件UISearchBar--20161229-mjd
@property(nonatomic, strong) UISearchBar *mysearch;
@property(nonatomic,assign) NSInteger *iTemp;

@end
