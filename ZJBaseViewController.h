//
//  ZJBaseViewController.h
//  CRM
//
//  Created by mini on 16/8/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJBaseViewController : UIViewController

//照片选择控制器
//@property(nonatomic,strong) UIImagePickerController *imagePickerController;

//从系统中获取照片
//-(void)getPictureFromeSystem;


//封装弹框 自动
-(void)autorAlertViewWithMsg:(NSString *)msg;

//手动
-(void)alertViewWithTitle:(NSString *)title  message:(NSString *)msg;

//从系统中获取照片
-(void)getPictureForIcon;

//**照片**//
@property(nonatomic,strong) UIImage *iconImage;

@end
