//
//  ZJCaptchaTimerManager.h
//  CRM
//
//  Created by 蒙建东 on 16/12/21.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJCaptchaTimerManager : NSObject

//创建倒计时单例对象
@property (nonatomic, assign)__block int timeout;

@property (nonatomic, assign)__block int ChangePasswordtimeout;

@property (nonatomic, assign)__block int Forgotwordtimeout;

@property (nonatomic, assign)__block int NewUserwordtimeout;

@property (nonatomic, assign)__block int VerificationLoginwordtimeout;

@property (nonatomic, assign)__block int ChangePhonetimeout;

+ (id)sharedTimerManager;

- (void)countDown:(NSInteger) time;

@end
