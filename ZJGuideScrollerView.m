//
//  CRMGuideScrollerView.m
//  CRM
//
//  Created by mini on 16/8/16.
//  Copyright © 2016年 mini. All rights reserved.
//

#import "ZJGuideScrollerView.h"
#import "ZJTabBarController.h"

@implementation ZJGuideScrollerView


-(void)guideViewWithFrame:(CGRect)frame guideImagesName:(NSArray *)imageArray{
    
    self.frame = frame;
    
    CGFloat width = frame.size.width;
    
    CGFloat height = frame.size.height;
    
    self.pagingEnabled = YES;
    
    self.showsHorizontalScrollIndicator = NO;
    
    self.showsVerticalScrollIndicator = NO;
    
    self.contentSize = CGSizeMake(imageArray.count * width, height);
    
    for (NSInteger i = 0; i < imageArray.count; i++) {
        
        UIImageView *guideImage = [[UIImageView alloc]init];
        
        guideImage.frame = CGRectMake(i *width, 0, width, height);
        
        guideImage.image = [UIImage imageNamed: imageArray[i]];
        
        [self addSubview:guideImage];
        
        if (i == imageArray.count - 1) {
            
            guideImage.userInteractionEnabled = YES;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(0, width - 100, width, height);
            
            [guideImage addSubview:button];
            
            [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    
}

-(void)clickButton{
    
    ZJTabBarController *TBC = [[ZJTabBarController alloc]init];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    window.rootViewController = TBC;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"0" forKey:@"birthMarker"];
//    
//    [defaults synchronize];
    //是否需要引导界面
    [defaults setObject:@(1) forKey:@"isGuide"];
    //设置登录界面
    [defaults setObject:@(1) forKey:@"isFirstLogin"];
    //ocr默认开启值
    [defaults setObject:@(1) forKey:@"ocr"];
    //首期还款日提醒
    [defaults setObject:@"30" forKey:@"firstloan"];
    //续贷提醒
    [defaults setObject:@"6" forKey:@"continueloan"];
    //首页界面标签提醒  每天一次
    [defaults setObject:@"0" forKey:@"firstMarker"];
    [defaults setObject:@"0" forKey:@"continueMarker"];
    [defaults setObject:@"0" forKey:@"birthMarker"];

    [defaults synchronize];
}

@end
