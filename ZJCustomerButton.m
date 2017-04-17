//
//  ZJCustomerButton.m
//  CRM
//
//  Created by mini on 16/9/14.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomerButton.h"

@implementation ZJCustomerButton

-(void)changeImageAndTitel{
    
    if (self.currentImage == nil) return;
    
    CGFloat imageW = self.imageView.width;
    
    CGFloat labelW = self.titleLabel.width;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelW, 0, -labelW);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageW, 0, imageW);
    
}
//
//-(void)layoutSubviews{
//    
//    [super layoutSubviews];
//    if (self.currentImage == nil) return;
//    
//    CGFloat imageW = self.imageView.width;
//    
//    CGFloat labelW = self.titleLabel.width;
//    
//    ZJLogFunc;
//    
//    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelW, 0, -labelW);
//    
//    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageW, 0, imageW);
//    
//}

@end
