//
//  UIView+Cagetory.m
//  CRM
//
//  Created by mini on 16/9/18.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "UIButton+Cagetory.h"

@implementation UIButton (Cagetory)

/**
 *  改变图片和文字的位置
 */

-(void)zj_changeImageAndTitel{
    
    if (!self.currentImage) return;
    CGSize size = CGSizeMake(MAXFLOAT, ZJNavigationHeight);

    CGFloat imageW = self.currentImage.size.width;
    
    CGFloat labelW = [self.titleLabel.text zj_getRealSizeWithMaxSize:size fount:[UIFont systemFontOfSize:18.0]].width;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelW, 0, -labelW);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageW, 0, imageW);

}

//图片和文字成上下显示
-(void)zj_imageUpTitleDownWith:(CGFloat)margin{
    
    if (!self.currentImage)return;
    CGFloat imgW = self.imageView.width;
    
    CGFloat imgH = self.imageView.height;
    
    CGFloat imgY = self.imageView.y;
    
    CGFloat labelW = 0.0;
    CGFloat labelH = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >=8.0) {
        
        labelW = self.titleLabel.intrinsicContentSize.width;
        
        labelH = self.titleLabel.intrinsicContentSize.height;
    }else{
        
        labelW = self.titleLabel.width;
        
        labelH = self.titleLabel.height;
    }
    
    self.imageEdgeInsets = UIEdgeInsetsMake(-imgY, labelW/2, imgY, -labelW/2);
    
    CGFloat top = (imgH+labelH)/2 -imgY +margin;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(top, -imgW, -top, 0);

}


//创建左边的图片和文字
+(instancetype)zj_creatDefaultLeftButton{
    
    UIButton*back = [UIButton buttonWithType:UIButtonTypeCustom];
    
    back.size = CGSizeMake(70, 30);
    
    [back setImage:[UIImage imageNamed:@"Returns--arrow"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"Returns--arrow"] forState:UIControlStateHighlighted];
    
    [back setTitle:@"返回" forState:UIControlStateNormal];
    
    back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    back.contentEdgeInsets  = UIEdgeInsetsMake(0, -10, 0, 0);
    
    return back;
}


@end
