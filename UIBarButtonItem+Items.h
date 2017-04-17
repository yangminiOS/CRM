//
//  UIBarButtonItem+Items.h
//  CRM
//
//  Created by mini on 16/8/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Items)


//创建UIBarButtonItem 并初始化一些值   如默认图片   高亮图片  位置等
+(instancetype)zj_BarButtonItemWithButtonItemImage:(NSString *)name heightLightImage:(NSString *)heightLightName target:(id)targer action:(SEL)action;

//创建UIBarButtonItem 并初始化文字
+(instancetype)zj_BarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color target:(id)targer action:(SEL)action;

//创建左边的图片和文字
+(instancetype)zj_creatDefaultLeftButton;
@end
