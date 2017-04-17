//
//  ZJCustomerSearchView.h
//  CRM
//
//  Created by mini on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJCustomerSearchView;

@protocol ZJCustomerSearchViewDelegate <NSObject>

-(void)ZJCustomerSearchView:(ZJCustomerSearchView*)view didClickCancleButton:(UIButton *)button;

@end

@interface ZJCustomerSearchView : UIView

//**搜索textField**//
@property(nonatomic,strong)  UITextField*searchTF;

//**搜索控件UISearchBar--20161229-mjd
@property(nonatomic, strong) UISearchBar *mysearch;

@property(nonatomic,weak) UIView *coverView;


//代理方法
@property(nonatomic,weak) id<ZJCustomerSearchViewDelegate> delegate;


@end
