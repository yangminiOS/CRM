//
//  ZJRecodeView.h
//  CRM
//
//  Created by mini on 16/9/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJRecodeView;

@protocol ZJRecodeViewDelegate <NSObject>

-(void)ZJRecodeView:(ZJRecodeView*)view addHeight:(CGFloat)addHeight;
-(void)ZJRecodeView:(ZJRecodeView*)view activeTextView:(UITextView *)textView;
-(void)ZJRecodeView:(ZJRecodeView*)view warnText:(NSString *)string;

@end

typedef NS_ENUM(NSInteger,RecodeButtonState){
    
    RecodeStarState,
    RecodeRecodeingState,
    RecodeListenState,
    
};
@interface ZJRecodeView : UIView

//**textView的文字**//
@property(nonatomic,copy)NSString *textViewText;

//**代理**//
@property(nonatomic,weak)id<ZJRecodeViewDelegate> delegate;

//**TextView**//
@property(nonatomic,strong)UITextView *tempTextView;

//**录音文件路径**//
@property(nonatomic,strong) NSMutableArray *recodeArray;

//**录音的文字**//
@property(nonatomic,copy)  NSString *recodeText;

//**guid**//
@property(nonatomic,copy)NSString *GUID;

//BOLL值用来记录录音状态
@property (nonatomic,assign)BOOL Recording;

//**计时器**//
@property(nonatomic,strong) NSTimer *timer;
@end
