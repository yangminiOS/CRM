//
//  UIBarButtonItem+Items.m
//  CRM
//
//  Created by mini on 16/8/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "UIBarButtonItem+Items.h"

@implementation UIBarButtonItem (Items)

//实现方法

+(instancetype)zj_BarButtonItemWithButtonItemImage:(NSString *)name heightLightImage:(NSString *)heightLightName target:(id)targer action:(SEL)action{
    
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [itemButton setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    
    [itemButton setBackgroundImage:[UIImage imageNamed:heightLightName] forState:UIControlStateHighlighted];
    
    itemButton.size = itemButton.currentBackgroundImage.size;
    
    [itemButton addTarget:targer action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc]initWithCustomView:itemButton];
}

//创建UIBarButtonItem 并初始化文字
+(instancetype)zj_BarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color target:(id)targer action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:color forState:UIControlStateNormal];
    
    button.width = 50;
    button.height = ZJNavigationHeight;
    
    [button addTarget:targer action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc]initWithCustomView:button];
}


@end
