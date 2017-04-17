//
//  ZJFollowRAndPView.h
//  CRM
//
//  Created by mini on 16/11/3.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJFollowRAndPView;
@protocol ZJFollowRAndPViewDelegate <NSObject>
//点击照片
-(void)ZJFollowRAndPView:(ZJFollowRAndPView *)view clickButton:(UIButton *)button;
//判断是否在录音  弹框
-(void)ZJFollowRAndPView:(ZJFollowRAndPView *)view isActive:(BOOL)active;
//点击保存  传递录音的路径 名字
-(void)ZJFollowRAndPView:(ZJFollowRAndPView *)view recodePath:(NSString *)path recodeFileName:(NSString *)name recodeTime:(NSInteger )time;
@end

typedef NS_ENUM(NSInteger,RecodeButtonState){
    
    RecodeStarState,
    RecodeRecodeingState,
    RecodeListenState,
    
};
@interface ZJFollowRAndPView : UIView

//**代理**//
@property(nonatomic,weak) id<ZJFollowRAndPViewDelegate> delegate;
//录音BUtton
@property(nonatomic,strong) UIButton *recodeButton;

//**图片Button**//
@property(nonatomic,strong) UIButton *photoButton;

//**判断在当前环境下是否能做其他的是**//
@property(nonatomic,assign,getter=isActive) BOOL active;

//**计时器**//
@property(nonatomic,strong) NSTimer *timer;

@end
