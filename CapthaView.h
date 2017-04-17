//
//  CapthaView.h
//  啊实打实的
//
//  Created by 蒙建东 on 16/12/1.
//  Copyright © 2016年 蒙建东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CapthaView : UIView
@property (strong, nonatomic) NSArray *dataArray;//字符素材数组

@property (strong, nonatomic) NSMutableString *authCodeStr;//验证码字符串
@end
