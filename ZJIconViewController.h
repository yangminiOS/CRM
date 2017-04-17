//
//  ZJIconViewController.h
//  CRM
//
//  Created by mini on 16/12/3.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJBaseViewController.h"

@class ZJIconViewController;

@protocol ZJIconViewDelegate <NSObject>


-(void)ZJIconViewController:(ZJIconViewController *)view iconImg:(UIImage *)iconImg;

@end

@interface ZJIconViewController : ZJBaseViewController

//**代理**//
@property(nonatomic,weak) id<ZJIconViewDelegate> delegate;

//**图片**//
@property(nonatomic,strong) UIImage *iconImg;

//**返回图片**//
@property(nonatomic,strong) UIImage *retuImg;
@end
