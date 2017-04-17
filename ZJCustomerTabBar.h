//
//  ZTTabBar.h
//  SinaWeibo
//
//  Created by user on 15/10/16.
//  Copyright © 2015年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJCustomerTabBar;

#warning ZTTabBar继承自UITabBar，所以ZTTabBar的代理必须遵循UITabBar的代理协议！
@protocol ZJCustomerTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(ZJCustomerTabBar *)tabBar;

@end

@interface ZJCustomerTabBar : UITabBar

@property (nonatomic, weak) id<ZJCustomerTabBarDelegate> delegate;

@end
