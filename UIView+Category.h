//
//  UIView+Category.h
//  CRM
//
//  Created by mini on 16/9/18.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

//**size**//
@property(nonatomic,assign)CGSize  size;

//**高度**//
@property(nonatomic,assign)CGFloat  height;

//**宽度**//
@property(nonatomic,assign)CGFloat  width;

//**坐标**//
@property(nonatomic,assign)CGPoint  origin;

//****//
@property(nonatomic,assign)CGFloat  x;

//****//
@property(nonatomic,assign)CGFloat  y;

//**中心点X**//
@property(nonatomic,assign)CGFloat  centerX;

//**中心点Y**//
@property(nonatomic,assign)CGFloat  centerY;


@end
