//
//  ZJCaptchaTimerManager.m
//  CRM
//
//  Created by 蒙建东 on 16/12/21.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCaptchaTimerManager.h"

@implementation ZJCaptchaTimerManager

+ (id)sharedTimerManager{
    
    static ZJCaptchaTimerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (manager == nil) {
            
            manager = [[self alloc]init];
            
        }
        
    });
    
    return manager;
    
}


- (void)countDown:(NSInteger ) time{
    
    
    switch (time) {
        case 1:

            if (_NewUserwordtimeout > 0) {
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                
                dispatch_source_set_event_handler(_timer, ^{
                    
                    if(_NewUserwordtimeout<=0){ //倒计时结束，关闭
                        
                        dispatch_source_cancel(_timer);
                        
                    }else{
                        
                        _NewUserwordtimeout--;
                        
                    }
                    
                });
                
                dispatch_resume(_timer);
                
            }
            break;
        case 2:
            if (_VerificationLoginwordtimeout > 0) {
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                
                dispatch_source_set_event_handler(_timer, ^{
                    
                    if(_VerificationLoginwordtimeout<=0){ //倒计时结束，关闭
                        
                        dispatch_source_cancel(_timer);
                        
                    }else{
                        
                        _VerificationLoginwordtimeout--;
                        
                    }
                    
                });
                
                dispatch_resume(_timer);
                
            }

            break;
        case 3:
            if (_Forgotwordtimeout > 0) {
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                
                dispatch_source_set_event_handler(_timer, ^{
                    
                    if(_Forgotwordtimeout<=0){ //倒计时结束，关闭
                        
                        dispatch_source_cancel(_timer);
                        
                    }else{
                        
                        _Forgotwordtimeout--;
                        
                    }
                    
                });
                
                dispatch_resume(_timer);
                
            }

            break;
        case 4:
            if (_ChangePasswordtimeout > 0) {
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                
                dispatch_source_set_event_handler(_timer, ^{
                    
                    if(_ChangePasswordtimeout<=0){ //倒计时结束，关闭
                        
                        dispatch_source_cancel(_timer);
                        
                    }else{
                        
                        _ChangePasswordtimeout--;
                        
                    }
                    
                });
                
                dispatch_resume(_timer);
                
            }

            break;
        case 5:
            if (_ChangePhonetimeout > 0) {
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                
                dispatch_source_set_event_handler(_timer, ^{
                    
                    if(_ChangePhonetimeout<=0){ //倒计时结束，关闭
                        
                        dispatch_source_cancel(_timer);
                        
                    }else{
                        
                        _ChangePhonetimeout--;
                        
                    }
                    
                });
                
                dispatch_resume(_timer);
                
            }

            break;
        default:
            break;
    }
    
}




@end
